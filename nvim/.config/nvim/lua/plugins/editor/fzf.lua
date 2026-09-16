return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", desc = "Find files" },
		{ "<leader>fg", "<cmd>lua require('fzf-lua').git_files()<CR>", desc = "Find git files" },
		{ "<leader>fr", "<cmd>lua require('fzf-lua').oldfiles()<CR>", desc = "Find recent files" },
		{ "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", desc = "Find buffers" },
		{ "<leader>fl", "<cmd>lua require('fzf-lua').blines()<CR>", desc = "Find lines in current buffer" },
		{ "<leader>fs", "<cmd>lua require('fzf-lua').live_grep()<CR>", desc = "Live grep" },
		{ "<leader>fw", "<cmd>lua require('fzf-lua').grep_cword()<CR>", desc = "Grep word under cursor" },
		{ "<leader>fv", "<cmd>lua require('fzf-lua').grep_visual()<CR>", desc = "Grep visual selection" },
		{ "<leader>gs", "<cmd>lua require('fzf-lua').git_status()<CR>", desc = "Git status" },
		{ "<leader>gc", "<cmd>lua require('fzf-lua').git_commits()<CR>", desc = "Git commits" },
		{ "<leader>gbc", "<cmd>lua require('fzf-lua').git_bcommits()<CR>", desc = "Git buffer commits" },
		{ "<leader>gb", "<cmd>lua require('fzf-lua').git_branches()<CR>", desc = "Git branches" },
		{ "<leader>gS", "<cmd>lua require('fzf-lua').git_stash()<CR>", desc = "Git stash" },
		{ "<leader>gt", "<cmd>lua require('fzf-lua').git_tags()<CR>", desc = "Git tags" },
		{ "<leader>gh", "<cmd>lua require('fzf-lua').git_hunks()<CR>", desc = "Git hunks" },
		{ "<leader>gB", "<cmd>lua require('fzf-lua').git_blame()<CR>", desc = "Git blame" },
		{ "<leader>h", "<cmd>lua require('fzf-lua').help_tags()<CR>", desc = "Neovim help tags" },
		{ "<leader>mm", "<cmd>lua require('fzf-lua').man_pages()<CR>", desc = "Man pages" },
		{ "<leader>k", "<cmd>lua require('fzf-lua').keymaps()<CR>", desc = "Show keymaps" },
		{ "<leader>co", "<cmd>lua require('fzf-lua').commands()<CR>", desc = "Show commands" },
		{ "<leader>ch", "<cmd>lua require('fzf-lua').command_history()<CR>", desc = "Command history" },
		{ "<leader>sh", "<cmd>lua require('fzf-lua').search_history()<CR>", desc = "Search history" },
		{ "<leader>ma", "<cmd>lua require('fzf-lua').marks()<CR>", desc = "Show marks" },
		{ "<leader>re", "<cmd>lua require('fzf-lua').registers()<CR>", desc = "Show registers" },
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
					wrap = "nowrap",
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
				builtin = {
					extensions = {
						["png"] = { "chafa", "{file}" },
						["jpg"] = { "chafa", "{file}" },
						["jpeg"] = { "chafa", "{file}" },
						["gif"] = { "chafa", "{file}" },
						["webp"] = { "chafa", "{file}" },
						["svg"] = { "chafa", "{file}" },
						["avif"] = { "chafa", "{file}" },
					},
				},
			},
			hl = hl,
		})
	end,
}
