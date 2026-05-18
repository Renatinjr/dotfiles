-- LSP configuration: Mason, mason-tool-installer, nvim-lspconfig (0.11+ API)
local rust = require("plugins.lsp.rust")
local vtsls = require("plugins.lsp.vtsls")
local kotlin = require("plugins.lsp.kotlin")

return {
	rust,
	vtsls,
	kotlin,
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		config = function(_, opts)
			require("mason").setup(opts)
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		cmd = {
			"MasonToolsInstall",
			"MasonToolsInstallSync",
			"MasonToolsUpdate",
			"MasonToolsUpdateSync",
			"MasonToolsClean",
		},
		opts = {
			ensure_installed = {
				"gofumpt",
				"goimports",
				"golines",
				"gopls",
				"lua-language-server",
				"vue-language-server",
				"rust-analyzer",
				"stylua",
				"prettier",
				"codelldb",
				"tailwindcss-language-server",
				"vtsls",
				"basedpyright",
				"black",
				"isort",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Global capabilities for all servers
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities({
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
				}),
			})

			vim.lsp.config("lua_ls", require("plugins.lsp.lua_ls"))

			vim.lsp.config("html", {})

			vim.lsp.config("tailwindcss", {
				filetypes = {
					"html",
					"css",
					"postcss",
					"sass",
					"scss",
					"javascript",
					"javascript.jsx",
					"javascriptreact",
					"typescript",
					"typescript.tsx",
					"typescriptreact",
					"vue",
					"svelte",
					"astro",
				},
				single_file_support = true,
				root_markers = {
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.mjs",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.cjs",
					"postcss.config.mjs",
					"postcss.config.ts",
					"pnpm-workspace.yaml",
					"turbo.json",
					"yarn.lock",
					"package-lock.json",
					"bun.lock",
					".git",
				},
				init_options = {
					userLanguages = {
						typescriptreact = "html",
						javascriptreact = "html",
					},
				},
				settings = {
					tailwindCSS = {
						classAttributes = { "class", "className", "ngClass", "classList" },
						validate = true,
						lint = {
							cssConflict = "warning",
							invalidApply = "error",
							invalidScreen = "error",
							invalidVariant = "error",
							invalidConfigPath = "error",
							invalidTailwindDirective = "error",
							recommendedVariantOrder = "warning",
						},
						experimental = {
							classRegex = {
								{ 'class:\\s*"([^"]*)"' },
								{ 'className:\\s*"([^"]*)"' },
								{ "clsx\\(([^)]*)\\)", '"([^"]*)"' },
								{ "cn\\(([^)]*)\\)", '"([^"]*)"' },
								{ "cva\\(([^)]*)\\)", '"([^"]*)"' },
							},
						},
					},
				},
			})

			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						keyOrdering = false,
					},
				},
			})

			vim.lsp.config("gopls", {
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
					},
				},
			})

			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "standard",
						},
					},
				},
			})

			vim.lsp.config("elixirls", {
				cmd = { "/home/renatojr/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
				settings = {
					dialyzerEnabled = true,
					fetchDeps = false,
					enableTestLenses = false,
					suggestSpecs = false,
				},
			})

			-- NOTE: rust-analyzer is managed by rustaceanvim, vtsls by its own plugin spec
			vim.lsp.enable({
				"lua_ls",
				"html",
				"tailwindcss",
				"yamlls",
				"gopls",
				"basedpyright",
				"elixirls",
			})
		end,
	},
}
