-- nvim-lspconfig (Neovim 0.11+ vim.lsp.config / vim.lsp.enable API).
-- Per-server settings live in lua/lsp/servers/<name>.lua; TypeScript is handled
-- by plugins/lang/tsc.lua and vtsls.lua, Rust by rustaceanvim, Kotlin by kotlin.nvim.
return {
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

		for _, name in ipairs({
			"lua_ls",
			"tailwindcss",
			"yamlls",
			"gopls",
			"basedpyright",
			"elixirls",
			"intelephense",
			"html",
		}) do
			vim.lsp.config(name, require("lsp.servers." .. name))
		end

		-- Must run here rather than from a spec `init`: it reads the config
		-- nvim-lspconfig ships for eslint before overriding it, which only
		-- resolves once this plugin is on the runtimepath.
		require("lsp.eslint").setup()

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
			"intelephense",
		})
	end,
}
