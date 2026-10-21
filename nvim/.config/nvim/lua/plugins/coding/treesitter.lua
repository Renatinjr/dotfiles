local parsers = {
	"bash",
	"c",
	"css",
	"dockerfile",
	"elixir",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"heex",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"kotlin",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	-- php pulls in php_only as a dependency; blade's injections reference
	-- php_only and html directly, so both have to be present for Laravel views.
	"php",
	"php_only",
	"phpdoc",
	"blade",
	"python",
	"query",
	"regex",
	"rust",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSUpdate", "TSUpdateSync" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				lazy = true,
				branch = "main",
			},
		},
		config = function()
			-- Install missing parsers on startup
			local installed = require("nvim-treesitter").get_installed()
			local installed_set = {}
			for _, lang in ipairs(installed) do
				installed_set[lang] = true
			end
			local to_install = {}
			for _, lang in ipairs(parsers) do
				if not installed_set[lang] then
					table.insert(to_install, lang)
				end
			end
			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end

			-- Textobjects setup
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")
			local map = vim.keymap.set

			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			})

			-- Select textobjects: a<x>/i<x> for the outer/inner capture.
			for key, spec in pairs({
				f = { "function", "function" },
				c = { "class", "class" },
				a = { "parameter", "argument" },
				i = { "conditional", "conditional" },
				l = { "loop", "loop" },
				b = { "block", "block" },
			}) do
				local capture, label = spec[1], spec[2]
				map({ "x", "o" }, "a" .. key, function()
					select.select_textobject("@" .. capture .. ".outer", "textobjects")
				end, { desc = "Select outer " .. label })
				map({ "x", "o" }, "i" .. key, function()
					select.select_textobject("@" .. capture .. ".inner", "textobjects")
				end, { desc = "Select inner " .. label })
			end

			-- Move to next/previous textobjects: ]x / [x = start, ]X / [X = end.
			for key, spec in pairs({
				f = { "@function.outer", "function" },
				c = { "@class.outer", "class" },
				a = { "@parameter.inner", "argument" },
			}) do
				local capture, label = spec[1], spec[2]
				map({ "n", "x", "o" }, "]" .. key, function()
					move.goto_next_start(capture, "textobjects")
				end, { desc = "Next " .. label .. " start" })
				map({ "n", "x", "o" }, "]" .. key:upper(), function()
					move.goto_next_end(capture, "textobjects")
				end, { desc = "Next " .. label .. " end" })
				map({ "n", "x", "o" }, "[" .. key, function()
					move.goto_previous_start(capture, "textobjects")
				end, { desc = "Previous " .. label .. " start" })
				map({ "n", "x", "o" }, "[" .. key:upper(), function()
					move.goto_previous_end(capture, "textobjects")
				end, { desc = "Previous " .. label .. " end" })
			end

			-- Swap textobjects
			map("n", "<leader>sa", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap with next argument" })
			map("n", "<leader>sf", function()
				swap.swap_next("@function.outer")
			end, { desc = "Swap with next function" })
			map("n", "<leader>sA", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap with previous argument" })
			map("n", "<leader>sF", function()
				swap.swap_previous("@function.outer")
			end, { desc = "Swap with previous function" })

			-- Incremental selection
			map("n", "<C-space>", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "Init selection" })

			-- Folding with treesitter
			vim.opt.foldmethod = "expr"
			-- vim.treesitter.foldexpr, not nvim_treesitter#foldexpr: the latter
			-- is the master-branch vimscript function and does not exist here.
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt.foldenable = false
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
		},
		keys = {
			{
				"[x",
				function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end,
				desc = "Go to context",
				silent = true,
			},
		},
	},
}
