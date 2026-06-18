-- TypeScript/JavaScript development: ts-bridge
--
-- ts-bridge (https://github.com/chojs23/ts-bridge) is a Rust language server
-- that bridges Neovim's LSP client to TypeScript's tsserver. It is NOT a Neovim
-- plugin and is not managed by Mason -- install the binary once with:
--
--     cargo install ts-bridge --locked
--
-- or via the upstream installer:
--
--     curl -fsSL https://raw.githubusercontent.com/chojs23/ts-bridge/main/scripts/install.sh | bash
--
-- This module returns a plain config table (lua_ls.lua style) that init.lua
-- feeds to `vim.lsp.config("ts_bridge", ...)`. ts-bridge is not in lspconfig's
-- registry, so we provide `cmd`/`filetypes`/`root_markers` ourselves.

local map = vim.keymap.set

-- Inlined from utils/filter.lua
local function filter(arr, fn)
	if type(arr) ~= "table" then
		return arr
	end

	local filtered = {}
	for k, v in pairs(arr) do
		if fn(v, k, arr) then
			table.insert(filtered, v)
		end
	end

	return filtered
end

-- Drop React/library .d.ts results so "go to definition" lands on real source.
-- Depending on the TS version, locations carry either `uri` or `targetUri`.
local function filterReactDTS(value)
	if value.uri then
		return string.match(value.uri, "%.d.ts") == nil
	elseif value.targetUri then
		return string.match(value.targetUri, "%.d.ts") == nil
	end
end

local handlers = {
	-- Rounded, non-focusable hover/signature popups. Done with plain wrappers
	-- rather than vim.lsp.with(), which is deprecated on Neovim 0.11+.
	["textDocument/hover"] = function(err, result, ctx, config)
		config = vim.tbl_extend("force", config or {}, {
			silent = true,
			border = "rounded",
			focusable = false,
		})
		return vim.lsp.handlers.hover(err, result, ctx, config)
	end,
	["textDocument/signatureHelp"] = function(err, result, ctx, config)
		config = vim.tbl_extend("force", config or {}, {
			border = "rounded",
			focusable = false,
		})
		return vim.lsp.handlers.signature_help(err, result, ctx, config)
	end,
	["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
		if not result or not result.diagnostics then
			return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
		end

		local filtered_diagnostics = {}
		for _, diagnostic in ipairs(result.diagnostics) do
			-- Skip CommonJS conversion suggestions (80001) and the
			-- "file is not a module" noise (2691).
			if diagnostic.code ~= 80001 and diagnostic.code ~= 2691 then
				-- Translate the TypeScript error into plain English when
				-- ts-error-translator.nvim is installed; otherwise no-op.
				local success, translated = pcall(function()
					return require("ts-error-translator").translate(diagnostic.message, diagnostic.code)
				end)

				if success and translated then
					diagnostic.message = translated
				end

				table.insert(filtered_diagnostics, diagnostic)
			end
		end

		result.diagnostics = filtered_diagnostics
		vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
	end,
	["textDocument/definition"] = function(err, result, method, ...)
		if not result or vim.tbl_isempty(result) then
			return vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
		end
		if vim.islist(result) and #result > 1 then
			local filtered_result = filter(result, filterReactDTS)
			return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
		end
		vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
	end,
}

-- ts-bridge forwards `preferences` and `format_options` verbatim to tsserver's
-- `configure` request, so these use the standard tsserver UserPreferences /
-- FormatCodeSettings key names (the same ones VS Code uses).
local tsserver_preferences = {
	-- Imports
	includePackageJsonAutoImports = "on",
	importModuleSpecifierPreference = "relative",
	importModuleSpecifierEnding = "minimal",
	allowRenameOfImportPath = true,
	-- Completions
	includeCompletionsForModuleExports = true,
	includeCompletionsForImportStatements = true,
	includeCompletionsWithInsertText = true,
	includeCompletionsWithSnippetText = true,
	includeAutomaticOptionalChainCompletions = true,
	includeCompletionsWithClassMemberSnippets = true,
	includeCompletionsWithObjectLiteralMethodSnippets = true,
	jsxAttributeCompletionStyle = "auto",
	-- Refactors / renames
	providePrefixAndSuffixTextForRename = true,
	allowTextChangesInNewFiles = true,
	provideRefactorNotApplicableReason = true,
	generateReturnInDocTemplate = true,
	-- Quotes
	quotePreference = "auto",
	-- Inlay hints
	includeInlayParameterNameHints = "literals",
	includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	includeInlayFunctionParameterTypeHints = false,
	includeInlayVariableTypeHints = false,
	includeInlayPropertyDeclarationTypeHints = false,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}

local tsserver_format_options = {
	-- Prettier owns actual formatting (see <leader>pw); these only affect
	-- tsserver-driven edits like organize-imports and code-action fixes.
	semicolons = "insert",
	convertTabsToSpaces = false,
	indentSize = 4,
	tabSize = 4,
	insertSpaceAfterCommaDelimiter = true,
	insertSpaceAfterSemicolonInForStatements = true,
	insertSpaceBeforeAndAfterBinaryOperators = true,
	insertSpaceAfterKeywordsInControlFlowStatements = true,
}

local settings = {
	["ts-bridge"] = {
		-- Run syntax/semantic diagnostics on a separate tsserver instance so
		-- diagnostics never block completion/hover requests.
		separate_diagnostic_server = true,
		-- "insert_leave" keeps diagnostics quiet while typing; other accepted
		-- values are "change" (live) and "save".
		publish_diagnostic_on = "insert_leave",
		enable_inlay_hints = false,
		tsserver = {
			locale = nil,
			log_directory = nil,
			log_verbosity = nil,
			-- tsserver heap cap in MB (nil = tsserver default).
			max_old_space_size = 3072,
			global_plugins = {},
			plugin_probe_dirs = {},
			extra_args = {},
			preferences = tsserver_preferences,
			format_options = tsserver_format_options,
		},
	},
}

-- Run a tsserver "source" code action by kind (organize imports, fix all, etc.)
-- and auto-apply the resulting workspace edit.
local function source_action(kind, title)
	return function()
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				only = { kind },
				diagnostics = {},
			},
		})
		if title then
			vim.notify(title, vim.log.levels.INFO)
		end
	end
end

local on_attach = function(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Client-side inlay hint rendering (server-side production is gated by
	-- settings["ts-bridge"].enable_inlay_hints above).
	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- Source-action helpers exposed as buffer commands so the keymaps below
	-- (and ad-hoc use) share one implementation.
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"TsBridgeOrganizeImports",
		source_action("source.organizeImports", "Organized imports"),
		{}
	)
	vim.api.nvim_buf_create_user_command(bufnr, "TsBridgeSortImports", source_action("source.sortImports"), {})
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"TsBridgeAddMissingImports",
		source_action("source.addMissingImports.ts", "Added missing imports"),
		{}
	)
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"TsBridgeRemoveUnused",
		source_action("source.removeUnused.ts", "Removed unused"),
		{}
	)
	vim.api.nvim_buf_create_user_command(bufnr, "TsBridgeFixAll", source_action("source.fixAll.ts", "Fixed all"), {})

	require("which-key").add({
		{ buffer = bufnr },
		{ "<leader>c", group = "TypeScript Actions" },
		{ "<leader>ci", "<cmd>TsBridgeAddMissingImports<CR>", desc = "import all (missing)" },
		{ "<leader>co", "<cmd>TsBridgeOrganizeImports<CR>", desc = "organize imports" },
		{ "<leader>cs", "<cmd>TsBridgeSortImports<CR>", desc = "sort imports" },
		{ "<leader>cu", "<cmd>TsBridgeRemoveUnused<CR>", desc = "remove unused" },
		{ "<leader>cF", "<cmd>TsBridgeFixAll<CR>", desc = "fix all" },
		{ "<leader>cD", "<cmd>TsBridgeStatus<CR>", desc = "ts-bridge status" },
	})

	-- Prettier formatting keymap (mirrors the previous vtsls setup).
	local curr_path = vim.fn.getcwd()
	map("n", "<leader>pw", "<cmd>term ~/.local/share/nvim/mason/bin/prettier --write " .. curr_path .. "<CR>", {
		buffer = bufnr,
		desc = "Prettier Format All",
	})

	vim.notify("ts-bridge attached", vim.log.levels.INFO)
end

return {
	cmd = { "ts-bridge" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	single_file_support = true,
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	flags = {
		debounce_text_changes = 150,
		allow_incremental_sync = true,
	},
	handlers = handlers,
	on_attach = on_attach,
	settings = settings,
}
