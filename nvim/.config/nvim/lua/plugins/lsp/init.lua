-- LSP configuration: Mason, mason-tool-installer, nvim-lspconfig (0.11+ API)
local rust = require("plugins.lsp.rust")
local kotlin = require("plugins.lsp.kotlin")
-- TypeScript/JavaScript: `vim.g.ts_lsp` picks which of these two actually
-- enables its server ("tsc", the TypeScript 7.0 native Go server, is the
-- default when unset). Both specs load; the loser returns early.
local tsc = require("plugins.lsp.tsc")
local vtsls = require("plugins.lsp.vtsls")
-- Lint diagnostics for JS/TS. Independent of the pair above: tsc reports nothing
-- on plain JS unless the project turns on checkJs, which is far too expensive on
-- a large untyped codebase. See lua/plugins/lsp/eslint.lua.
local eslint = require("plugins.lsp.eslint")

return {
	rust,
	kotlin,
	tsc,
	vtsls,
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
				"kulala-fmt",
				"goimports",
				"gopls",
				"lua-language-server",
				"rust-analyzer",
				"stylua",
				"prettier",
				"codelldb",
				"tailwindcss-language-server",
				-- TypeScript/JavaScript LSP (see lua/plugins/lsp/vtsls.lua).
				"vtsls",
				-- Kotlin LSP (see lua/plugins/lsp/kotlin.lua). Bundles its own JBR.
				"kotlin-lsp",
				-- JS/TS lint diagnostics (see lua/plugins/lsp/eslint.lua).
				"eslint-lsp",
				"basedpyright",
				"black",
				"isort",
				-- Servers enabled below that mason must provide.
				"elixir-ls",
				"json-lsp",
				"yaml-language-server",
				"html-lsp",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Global capabilities for all servers. blink.cmp's completion
			-- capabilities (snippets, resolve, additionalTextEdits, …) are merged
			-- in here so every enabled server inherits them. get_lsp_capabilities
			-- folds blink's caps over the default client capabilities and then our
			-- folding-range override; requiring blink here loads it on demand.
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
					"javascript.jsx",
					"javascriptreact",
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
				settings = {
					dialyzerEnabled = true,
					fetchDeps = false,
					enableTestLenses = false,
					suggestSpecs = false,
				},
			})

			-- Must run here rather than from a spec `init`: it reads the config
			-- nvim-lspconfig ships for eslint before overriding it, which only
			-- resolves once this plugin is on the runtimepath.
			eslint.setup()

			-- NOTE: rust-analyzer is managed by rustaceanvim.
			vim.lsp.enable({
				"eslint",
				"lua_ls",
				"html",
				"tailwindcss",
				"yamlls",
				"gopls",
				"basedpyright",
				"elixirls",
				"jsonls",
			})
		end,
	},
}
