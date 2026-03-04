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
	"jsonc",
	"kotlin",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
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

			-- Select textobjects
			map({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "Select outer function" })
			map({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "Select inner function" })
			map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "Select outer class" })
			map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "Select inner class" })
			map({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end, { desc = "Select outer argument" })
			map({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end, { desc = "Select inner argument" })
			map({ "x", "o" }, "ai", function() select.select_textobject("@conditional.outer", "textobjects") end, { desc = "Select outer conditional" })
			map({ "x", "o" }, "ii", function() select.select_textobject("@conditional.inner", "textobjects") end, { desc = "Select inner conditional" })
			map({ "x", "o" }, "al", function() select.select_textobject("@loop.outer", "textobjects") end, { desc = "Select outer loop" })
			map({ "x", "o" }, "il", function() select.select_textobject("@loop.inner", "textobjects") end, { desc = "Select inner loop" })
			map({ "x", "o" }, "ab", function() select.select_textobject("@block.outer", "textobjects") end, { desc = "Select outer block" })
			map({ "x", "o" }, "ib", function() select.select_textobject("@block.inner", "textobjects") end, { desc = "Select inner block" })

			-- Move to next/previous textobjects
			map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
			map({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
			map({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Next argument start" })
			map({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
			map({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end, { desc = "Next class end" })
			map({ "n", "x", "o" }, "]A", function() move.goto_next_end("@parameter.inner", "textobjects") end, { desc = "Next argument end" })
			map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function start" })
			map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous class start" })
			map({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Previous argument start" })
			map({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Previous function end" })
			map({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end, { desc = "Previous class end" })
			map({ "n", "x", "o" }, "[A", function() move.goto_previous_end("@parameter.inner", "textobjects") end, { desc = "Previous argument end" })

			-- Swap textobjects
			map("n", "<leader>sa", function() swap.swap_next("@parameter.inner") end, { desc = "Swap with next argument" })
			map("n", "<leader>sf", function() swap.swap_next("@function.outer") end, { desc = "Swap with next function" })
			map("n", "<leader>sA", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap with previous argument" })
			map("n", "<leader>sF", function() swap.swap_previous("@function.outer") end, { desc = "Swap with previous function" })

			-- Incremental selection
			map("n", "<C-space>", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end, { desc = "Init selection" })

			-- Folding with treesitter
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
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
