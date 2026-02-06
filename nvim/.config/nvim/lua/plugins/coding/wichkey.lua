local M
M = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	config = function()
		local wk = require("which-key")
		wk.setup({
			plugins = {
				marks = true, -- shows a list of your marks on ' and `
				registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				spelling = {
					enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
					suggestions = 20, -- how many suggestions should be shown in the list?
				},
				presets = {
					operators = true, -- adds help for operators like d, y, ...
					motions = true, -- adds help for motions
					text_objects = true, -- help for text objects triggered after entering an operator
					windows = true, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
			},
			-- add icons to the descriptions
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and its description
				group = "+", -- symbol prepended to a group description
			},
			win = {
				no_overlap = true,
				-- width = 1,
				-- height = { min = 4, max = 25 },
				-- col = 0,
				-- row = math.huge,
				-- border = "none",
				padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
				title = true,
				title_pos = "center",
				zindex = 1000,
				-- Additional vim.wo and vim.bo options
				bo = {},
				wo = {
					-- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
				},
			},
			layout = {
				width = { min = 20 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
			},
			show_help = true, -- show help message on the command line when the popup is visible
		})

		-- New spec format using wk.register directly with mode and key specifications
		wk.add({
			-- Find group
			{
				"<leader>ff",
				function()
					require("fzf-lua").files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fg",
				function()
					require("fzf-lua").git_files()
				end,
				desc = "Find git files",
			},
			{
				"<leader>fr",
				function()
					require("fzf-lua").oldfiles()
				end,
				desc = "Find recent files",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Find buffers",
			},
			{
				"<leader>fl",
				function()
					require("fzf-lua").blines()
				end,
				desc = "Find lines in current buffer",
			},
			{
				"<leader>fs",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Live grep",
			},
			{
				"<leader>fw",
				function()
					require("fzf-lua").grep_cword()
				end,
				desc = "Grep word under cursor",
			},
			{
				"<leader>fv",
				function()
					require("fzf-lua").grep_visual()
				end,
				desc = "Grep visual selection",
			},

			-- Git group
			{ "<leader>g", group = "Git" },
			{
				"<leader>gs",
				function()
					require("fzf-lua").git_status()
				end,
				desc = "Git status",
			},
			{
				"<leader>gc",
				function()
					require("fzf-lua").git_commits()
				end,
				desc = "Git commits",
			},

			-- Git branches subgroup
			{
				"<leader>gbc",
				function()
					require("fzf-lua").git_bcommits()
				end,
				desc = "Git buffer commits",
			},

			-- LSP group
			{ "<leader>l", group = "LSP" },
			{
				"<leader>lq",
				function()
					vim.diagnostic.setloclist()
				end,
				desc = "Open diagnostics list",
			},
			{
				"<leader>la",
				function()
					vim.lsp.buf.add_workspace_folder()
				end,
				desc = "Add workspace folder",
			},
			{
				"<leader>lr",
				function()
					vim.lsp.buf.remove_workspace_folder()
				end,
				desc = "Remove workspace folder",
			},
			{
				"<leader>ll",
				function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				desc = "List workspace folders",
			},
			{
				"<leader>lD",
				function()
					vim.lsp.buf.type_definition()
				end,
				desc = "Go to type definition",
			},
			{
				"<leader>lR",
				function()
					vim.lsp.buf.rename()
				end,
				desc = "Rename symbol",
			},
			{
				"<leader>lA",
				function()
					vim.lsp.buf.code_action()
				end,
				desc = "Code action",
			},
			{
				"<leader>lf",
				function()
					vim.lsp.buf.format({ async = true })
				end,
				desc = "Format file",
			},
			{ "<leader>lh", M.toggle_inlay_hints, desc = "Toggle inlay hints" },

			-- Window group
			{ "<leader>w", group = "Window" },
			{ "<leader>w=", "<C-w>=", desc = "Normalize split layout" },
			{
				"<leader>w<Up>",
				function()
					require("utils.utils").resize(false, -5)
				end,
				desc = "Horizontal split increase",
			},
			{
				"<leader>w<Down>",
				function()
					require("utils.utils").resize(false, 5)
				end,
				desc = "Horizontal split decrease",
			},
			{
				"<leader>w<Left>",
				function()
					require("utils.utils").resize(true, -5)
				end,
				desc = "Vertical split decrease",
			},
			{
				"<leader>w<Right>",
				function()
					require("utils.utils").resize(true, 5)
				end,
				desc = "Vertical split increase",
			},

			-- Misc group
			{
				"<leader>mu",
				function()
					memory_usage()
				end,
				desc = "Show memory usage",
			},
		})
	end,
	colors = true,
	keys = {
		Up = " ",
		Down = " ",
		Left = " ",
		Right = " ",
		C = "󰘴 ",
		M = "󰘵 ",
		D = "󰘳 ",
		S = "󰘶 ",
		CR = "󰌑 ",
		Esc = "󱊷 ",
		ScrollWheelDown = "󱕐 ",
		ScrollWheelUp = "󱕑 ",
		NL = "󰌑 ",
		BS = "󰁮",
		Space = "󱁐 ",
		Tab = "󰌒 ",
		F1 = "󱊫",
		F2 = "󱊬",
		F3 = "󱊭",
		F4 = "󱊮",
		F5 = "󱊯",
		F6 = "󱊰",
		F7 = "󱊱",
		F8 = "󱊲",
		F9 = "󱊳",
		F10 = "󱊴",
		F11 = "󱊵",
		F12 = "󱊶",
	},
	cmd = "WhichKey",
}

function M.toggle_inlay_hints()
	local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		if client.supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			return
		end
	end
	vim.notify("No LSP client with inlay hint support found", vim.log.levels.WARN)
end

return M
