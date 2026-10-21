return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		conform.formatters["kulala_fmt"] = {
			command = "kulala-fmt",
			args = { "fix", "--stdin" },
			stdin = true,
		}

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				-- pint resolves to the project's vendor/bin/pint when there is one
				-- (so pint.json and the project's pint version win), else Mason's.
				php = { "pint" },
				blade = { "blade-formatter" },
				python = { "isort", "black" },
				http = { "kulala_fmt" },
				rest = { "kulala_fmt" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 2500,
				quiet = true,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
				quiet = true,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
