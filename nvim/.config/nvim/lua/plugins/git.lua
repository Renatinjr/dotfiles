-- Git integration: gitsigns, crates.nvim
return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▍" },
					delete = { text = "▁" },
					topdelete = { text = "▔" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				signs_staged = {
					add = { text = "▎" },
					change = { text = "▍" },
					delete = { text = "▁" },
					topdelete = { text = "▔" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				on_attach = function(bufnr)
					local gs = require("gitsigns")

					local function map(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
					end

					map("n", "<leader>rh", gs.reset_hunk, "Reset Hunk")
					map("n", "<leader>ph", gs.preview_hunk, "Preview Hunk")
					map("n", "<leader>gb", gs.blame_line, "Blame Line")
				end,
			})
		end,
	},
	{
		"saecki/crates.nvim",
		ft = { "rust", "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			crates.show()
		end,
	},
}
