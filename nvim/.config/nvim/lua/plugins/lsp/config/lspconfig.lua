return {
	"neovim/nvim-lspconfig",
	lazy = false,
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = {
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		}

		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
		lspconfig.lua_ls.setup(require("plugins.lsp.config.lua-ls")(capabilities))
		lspconfig.html.setup({})
		lspconfig.tailwindcss.setup({
			filetypes = {
				"javascriptreact",
				"vue",
				"typescriptreact",
				"astro",
				"css",
				"postcss",
				"svelte",
				"sass",
			},
			root_dir = function(...)
				return require("lspconfig.util").root_pattern(".git")(...)
			end,
		})
		lspconfig.yamlls.setup({
			settings = {
				yaml = {
					keyOrdering = false,
				},
			},
		})

		lspconfig.gopls.setup({
			capabilities = capabilities,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
						shadow = true,
					},
					staticcheck = true,
					gofumpt = true,
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					-- Add more settings as needed
				},
			},
			flags = {
				debounce_text_changes = 150,
			},
		})

		lspconfig.elixirls.setup({
			cmd = { "/home/renatojr/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
			settings = {
				dialyzerEnabled = true,
				fetchDeps = false,
				enableTestLenses = false,
				suggestSpecs = false,
			},
		})
	end,
}
