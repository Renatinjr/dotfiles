return {
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local rainbow = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				-- Strategy controls when delimiters are re-coloured.
				--   global: re-color on every TS update for the whole buffer
				--   local : only the pair around the cursor (cheaper, but quieter)
				strategy = {
					[""] = rainbow.strategy["global"],
					-- vim's grammar is slow-ish — use local strategy there
					vim = rainbow.strategy["local"],
					commonlisp = rainbow.strategy["local"],
				},

				-- Per-filetype query overrides — picks the most useful set of
				-- nodes to colour for each language.
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks", -- colour `do…end`, `then…end`, etc.
					tsx = "rainbow-parens-react",
					javascriptreact = "rainbow-parens-react",
					html = "rainbow-tags",
					jsx = "rainbow-parens-react",
					verilog = "rainbow-blocks",
				},

				-- Higher priority wins when multiple matches exist.
				priority = {
					[""] = 110,
					lua = 210,
				},

				-- Cycle through these highlight groups (defined per-colorscheme).
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},

				-- Buffers to skip entirely (large/special filetypes where the
				-- visual noise outweighs the benefit).
				blacklist = { "text", "markdown", "help", "alpha", "neo-tree", "chadtree" },
			}
		end,
	},
}
