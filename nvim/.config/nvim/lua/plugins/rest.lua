return {
	{
		"rest-nvim/rest.nvim",
		-- Pin to the v2.x line. v3.x switched to luarocks-managed deps
		-- (tree-sitter-http, fidget.nvim, etc.) and fails on this machine
		-- because luarocks-build-treesitter-parser can't load its own
		-- module. v2 has no luarocks requirement.
		tag = "v2.0.1",
		-- CRITICAL: lazy.nvim sees the rockspec in the repo and tries to
		-- install via luarocks regardless of the git tag pin — disable it
		-- so lazy uses only the git checkout at v2.0.1.
		rocks = { enabled = false },
		ft = "http",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					if not vim.tbl_contains(opts.ensure_installed, "http") then
						table.insert(opts.ensure_installed, "http")
					end
				end,
			},
		},
		-- v2 doesn't auto-setup; needs an explicit call to register :Rest commands
		config = function()
			require("rest-nvim").setup({
				-- nvim 0.11+ tightened vim.highlight.range and now rejects
				-- regtype = "c" (rest.nvim v2.0.1's utils.lua:141 passes it),
				-- producing E475. Patch the call to use a valid regtype so
				-- we keep the post-request flash highlight.
				highlight = { enable = true, timeout = 750 },
			})

			-- Monkey-patch: wrap rest.nvim's highlight to convert "c" → "v".
			local utils = require("rest-nvim.utils")
			local original = utils.highlight
			utils.highlight = function(bufnr, start, end_, ns)
				local hl_range = vim.highlight.range
				vim.highlight.range = function(b, n, g, s, e, opts)
					if opts and opts.regtype == "c" then
						opts = vim.tbl_extend("force", opts, { regtype = "v" })
					end
					return hl_range(b, n, g, s, e, opts)
				end
				local ok, err = pcall(original, bufnr, start, end_, ns)
				vim.highlight.range = hl_range
				if not ok then
					vim.notify("rest.nvim highlight: " .. tostring(err), vim.log.levels.WARN)
				end
			end
		end,
	},
}
