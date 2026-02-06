return {
	"lewis6991/gitsigns.nvim",
	reuires = {
		"nvim-lua/planary.nvim",
	},
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signs_staged = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function opts(desc)
					return { buffer = bufnr, desc = desc }
				end

				local map = vim.keymap.set

				map("n", "<leader>rh", gs.reset_hunk, opts("Reset Hunk"))
				map("n", "<leader>ph", gs.preview_hunk, opts("Preview Hunk"))
				map("n", "<leader>gb", gs.blame_line, opts("Blame Line"))
			end,
		})
	end,
}
