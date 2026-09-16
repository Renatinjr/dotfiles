-- which-key: popup with the keys that follow a prefix.
--
-- Only setup options and group labels live here. Real mappings belong in
-- config/keymaps.lua (global) or each plugin's `keys =` table, so they keep
-- their lazy-loading triggers and which-key just reads their `desc`.
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	cmd = "WhichKey",
	opts = {
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
			padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
			title = true,
			title_pos = "center",
			zindex = 1000,
		},
		layout = {
			width = { min = 20 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
		},
		show_help = true, -- show help message on the command line when the popup is visible
		spec = {
			{ "<leader>g", group = "Git" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>u", group = "UI" },
			{ "<leader>w", group = "Window" },
		},
	},
}
