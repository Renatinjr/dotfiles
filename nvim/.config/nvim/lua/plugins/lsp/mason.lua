-- Mason: external tool installer. Servers are configured in lspconfig.lua and
-- lua/lsp/servers/; language-specific plugins live in plugins/lang/.
return {
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
				-- TypeScript/JavaScript LSP (see lua/plugins/lang/vtsls.lua).
				"vtsls",
				-- Kotlin LSP (see lua/plugins/lang/kotlin.lua). Bundles its own JBR.
				"kotlin-lsp",
				-- JS/TS lint diagnostics (see lua/lsp/eslint.lua).
				"eslint-lsp",
				"basedpyright",
				"black",
				"isort",
				-- PHP: intelephense (LSP), pint (formatter, also picked up from a
				-- project's vendor/bin), blade-formatter (Laravel views),
				-- php-debug-adapter (Xdebug, see plugins/tools/dap.lua).
				"intelephense",
				"pint",
				"blade-formatter",
				"php-debug-adapter",
				-- Servers enabled below that mason must provide.
				"elixir-ls",
				"json-lsp",
				"yaml-language-server",
				"html-lsp",
			},
		},
	},
}
