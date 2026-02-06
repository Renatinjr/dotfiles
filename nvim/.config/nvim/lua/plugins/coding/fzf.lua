return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter-textobjects" },
	keys = {
		-- Find files
		{
			"<leader>ff",
			"<cmd>lua require('fzf-lua').files()<CR>",
			{ desc = "Find files", noremap = true, silent = true },
		},
		-- Find git files
		{
			"<leader>fg",
			"<cmd>lua require('fzf-lua').git_files()<CR>",
			{ desc = "Find git files", noremap = true, silent = true },
		},
		-- Find recent files
		{
			"<leader>fr",
			"<cmd>lua require('fzf-lua').oldfiles()<CR>",
			{ desc = "Find recent files", noremap = true, silent = true },
		},
		-- Find buffers
		{
			"<leader>fb",
			"<cmd>lua require('fzf-lua').buffers()<CR>",
			{ desc = "Find buffers", noremap = true, silent = true },
		},
		-- Find in current buffer
		{
			"<leader>fl",
			"<cmd>lua require('fzf-lua').blines()<CR>",
			{ desc = "Find lines in current buffer", noremap = true, silent = true },
		},
		-- Live grep
		{
			"<leader>fs",
			"<cmd>lua require('fzf-lua').live_grep()<CR>",
			{ desc = "Live grep", noremap = true, silent = true },
		},
		-- Grep word under cursor
		{
			"<leader>fw",
			"<cmd>lua require('fzf-lua').grep_cword()<CR>",
			{ desc = "Grep word under cursor", noremap = true, silent = true },
		},
		-- Grep visual selection
		{
			"<leader>fv",
			"<cmd>lua require('fzf-lua').grep_visual()<CR>",
			{ desc = "Grep visual selection", noremap = true, silent = true },
		},
		-- Git status
		{
			"<leader>gs",
			"<cmd>lua require('fzf-lua').git_status()<CR>",
			{ desc = "Git status", noremap = true, silent = true },
		},
		-- Git commits
		{
			"<leader>gc",
			"<cmd>lua require('fzf-lua').git_commits()<CR>",
			{ desc = "Git commits", noremap = true, silent = true },
		},
		-- Git buffer commits
		{
			"<leader>gbc",
			"<cmd>lua require('fzf-lua').git_bcommits()<CR>",
			{ desc = "Git buffer commits", noremap = true, silent = true },
		},
		-- Git branches
		{
			"<leader>gb",
			"<cmd>lua require('fzf-lua').git_branches()<CR>",
			{ desc = "Git branches", noremap = true, silent = true },
		},
		-- Neovim help
		{
			"<leader>h",
			"<cmd>lua require('fzf-lua').help_tags()<CR>",
			{ desc = "Neovim help tags", noremap = true, silent = true },
		},
		-- Man pages
		{
			"<leader>mm",
			"<cmd>lua require('fzf-lua').man_pages()<CR>",
			{ desc = "Man pages", noremap = true, silent = true },
		},
		-- Keymaps
		{
			"<leader>k",
			"<cmd>lua require('fzf-lua').keymaps()<CR>",
			{ desc = "Show keymaps", noremap = true, silent = true },
		},
		-- Neovim commands
		{
			"<leader>co",
			"<cmd>lua require('fzf-lua').commands()<CR>",
			{ desc = "Show commands", noremap = true, silent = true },
		},
		-- Command history
		{
			"<leader>ch",
			"<cmd>lua require('fzf-lua').command_history()<CR>",
			{ desc = "Command history", noremap = true, silent = true },
		},
		-- Search history
		{
			"<leader>sh",
			"<cmd>lua require('fzf-lua').search_history()<CR>",
			{ desc = "Search history", noremap = true, silent = true },
		},
		-- Marks
		{
			"<leader>ma",
			"<cmd>lua require('fzf-lua').marks()<CR>",
			{ desc = "Show marks", noremap = true, silent = true },
		},
		-- Registers
		{
			"<leader>re",
			"<cmd>lua require('fzf-lua').registers()<CR>",
			{ desc = "Show registers", noremap = true, silent = true },
		},
	},
	config = function()
		local theme = require("config.theme")
		local hl = theme.current_theme.fzf.setup_colors()

		require("fzf-lua").setup({
			pointer = "",
			winopts = {
				height = 0.85,
				width = 0.80,
				markers = { selected = "" },
				preview = {
					horizontal = "right:60%",
					layout = "horizontal",
					wra = "nowrap",
					scrollbar = false,
				},
			},
			fzf_opts = {
				["--pointer"] = "󰫤 ",
			},
			fzf_colors = {
				["fg"] = { "fg", "FzfLuaNormal" },
				["bg"] = { "bg", "FzfLuaNormal" },
				["hl"] = { "fg", "FzfLuaBorder" },
				["fg+"] = { "fg", "FzfLuaCursorLine" },
				["bg+"] = { "bg", "FzfLuaCursorLine" },
				["hl+"] = { "fg", "FzfLuaTitle" },
				["info"] = { "fg", "FzfLuaPreviewTitle" },
				["border"] = { "fg", "FzfLuaBorder" },
				["prompt"] = { "fg", "FzfLuaPrompt" },
				["pointer"] = { "fg", "FzfLuaPointer" },
				["marker"] = { "fg", "FzfLuaMarker" },
				["spinner"] = { "fg", "FzfLuaSpinner" },
				["header"] = { "fg", "FzfLuaHeader" },
				["gutter"] = { "bg", "Normal" },
			},
			previewers = {
				bat = {
					theme = "kanagawa-tmTheme",
				},
			},
			hl = hl,
		})
	end,
}
