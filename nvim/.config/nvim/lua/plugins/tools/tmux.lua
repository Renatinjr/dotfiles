-- vim-tmux-navigator: seamless <C-hjkl> between vim splits and tmux panes.
return {
	"christoomey/vim-tmux-navigator",
	event = "VeryLazy",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
		"TmuxNavigatorProcessList",
	},
	-- Mirrors @vim_navigator_mapping_* in ~/.tmux.conf; keep both in sync.
	keys = {
		{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Go to left pane/split" },
		{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Go to lower pane/split" },
		{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Go to upper pane/split" },
		{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Go to right pane/split" },
		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Go to previous pane/split" },
		{ "<c-Left>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Go to left pane/split" },
		{ "<c-Down>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Go to lower pane/split" },
		{ "<c-Up>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Go to upper pane/split" },
		{ "<c-Right>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Go to right pane/split" },
	},
}
