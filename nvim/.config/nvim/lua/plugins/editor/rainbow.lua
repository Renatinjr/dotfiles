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

				-- Per-LANGUAGE query overrides (treesitter language names, not
				-- filetypes: .jsx is `javascript`, .tsx is `tsx`).
				--
				-- The markup languages point at queries/<lang>/rainbow-tag-delims.scm
				-- in this config, which colors a tag's angle brackets by nesting
				-- depth but deliberately NOT the tag name -- the name keeps the
				-- semantic @tag / @tag.builtin color applied in
				-- config/theme/switcher.lua, so depth and tag kind are both
				-- readable at once. Brackets and braces keep their usual rainbow
				-- through the inherited javascript/typescript patterns.
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks", -- colour `do…end`, `then…end`, etc.
					verilog = "rainbow-blocks",
					html = "rainbow-tag-delims",
					javascript = "rainbow-tag-delims",
					tsx = "rainbow-tag-delims",
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
