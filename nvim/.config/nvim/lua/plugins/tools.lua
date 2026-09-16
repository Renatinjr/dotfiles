-- Tool integrations: tmux navigation, Claude Code
return {
	-- Tmux navigator
	{
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
	},

	-- Claude Code
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
}
