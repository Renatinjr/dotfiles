-- TypeScript/JavaScript development: vtsls (https://github.com/yioneko/vtsls)
-- The server is registered through the native vim.lsp.config/enable API. Three
-- `lsp/vtsls.lua` layers get deep-merged before ours: nvim-lspconfig's (cmd,
-- init_options.hostInfo and the monorepo/Deno-aware `root_dir` function) and
-- nvim-vtsls' own, then the table below on top.
--
-- The `yioneko/nvim-vtsls` companion plugin registers the buffer-local :VtsExec
-- command (and :VtsRename) from an LspAttach autocmd, gated on the client being
-- named exactly "vtsls" — which vim.lsp.config("vtsls", …) guarantees.
--
-- NOTE: in a Deno project no TS client attaches at all. That is intentional:
-- lspconfig's root_dir bails without calling on_dir when deno.json/deno.lock is
-- closer than the package-manager lockfile.
--
-- Only one TS server may attach at a time. TypeScript 7.0's native server is the
-- default; set `vim.g.ts_lsp = "vtsls"` (before lazy loads plugins) to come back
-- here instead. See plugins/lang/tsc.lua for the other half of the switch.
local shared = require("lsp.ts_shared")

local handlers = {
	["textDocument/hover"] = shared.hover,
	["textDocument/signatureHelp"] = shared.signature_help,
	-- vtsls speaks the tsserver protocol and PUSHES diagnostics, so the clean-up
	-- and ts-error-translator rewrite hook the publish path here. (The TS 7.0
	-- server uses the pull path instead -- see plugins/lang/tsc.lua.)
	["textDocument/publishDiagnostics"] = shared.on_publish_diagnostics,
	["textDocument/definition"] = shared.definition,
}

-- vtsls consumes the VSCode settings schema, NOT raw tsserver preference names —
-- keys outside that schema are silently ignored, so every key here is one vtsls
-- actually reads (packages/service/configuration.schema.json upstream).
local settings = {
	typescript = {
		preferences = {
			includePackageJsonAutoImports = "on",
			importModuleSpecifier = "relative",
			importModuleSpecifierEnding = "minimal",
		},
		suggest = {
			completeFunctionCalls = true,
			autoImports = true,
			includeAutomaticOptionalChainCompletions = true,
			includeCompletionsForImportStatements = true,
		},
		inlayHints = {
			parameterNames = {
				enabled = "literals",
				suppressWhenArgumentMatchesName = true,
			},
			parameterTypes = { enabled = false },
			variableTypes = { enabled = false },
			propertyDeclarationTypes = { enabled = false },
			functionLikeReturnTypes = { enabled = true },
			enumMemberValues = { enabled = true },
		},
		updateImportsOnFileMove = { enabled = "always" },
		-- Pairs with the `goto_source_definition` keymap: jump past .d.ts stubs.
		preferGoToSourceDefinition = true,
		tsserver = {
			maxTsServerMemory = 4096,
		},
		referencesCodeLens = {
			enabled = true,
			showOnAllFunctions = false,
		},
		-- Plural — `implementationCodeLens` is not a real key.
		implementationsCodeLens = {
			enabled = true,
		},
	},
	javascript = {
		preferences = {
			importModuleSpecifier = "relative",
			importModuleSpecifierEnding = "minimal",
		},
		suggest = {
			completeFunctionCalls = true,
			autoImports = true,
			includeAutomaticOptionalChainCompletions = true,
			includeCompletionsForImportStatements = true,
		},
		inlayHints = {
			parameterNames = {
				enabled = "literals",
				suppressWhenArgumentMatchesName = true,
			},
			parameterTypes = { enabled = false },
			variableTypes = { enabled = false },
			propertyDeclarationTypes = { enabled = false },
			functionLikeReturnTypes = { enabled = true },
		},
		updateImportsOnFileMove = { enabled = "always" },
		preferGoToSourceDefinition = true,
	},
	vtsls = {
		enableMoveToFileCodeAction = true,
		autoUseWorkspaceTsdk = true,
		experimental = {
			completion = {
				enableServerSideFuzzyMatch = true,
			},
		},
	},
}

local on_attach = function(client, bufnr)
	-- Enable omnifunc
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Same TypeScript program, same cost as tsc; see ts_shared.
	shared.tame_semantic_tokens(client, bufnr)

	-- referencesCodeLens/implementationsCodeLens above render nothing unless the
	-- client is told to collect lenses for this buffer.
	if client:supports_method("textDocument/codeLens") then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end

	-- NOTE: no hand-rolled `_typescript.moveToFileRefactoring` command here —
	-- nvim-vtsls registers its own (with a picker + auto-rename) on LspAttach,
	-- and it skips registration when client.commands[…] is already set.
	-- Set with vim.keymap.set rather than which-key's `add()`: which-key only
	-- drains its spec queue once, from its own setup(), so an `add()` issued later
	-- -- e.g. from an LspAttach handler like this one -- is queued and silently
	-- never applied (that was the old pattern here, and these maps never existed).
	-- Same reasoning as plugins/lang/kotlin.lua. The group label still goes through
	-- which-key, via the module setup() itself calls.
	local keys = {
		{ "<leader>ce", "<cmd>TSC<CR>", "workspace errors (TSC)" },
		{ "<leader>cF", "<cmd>VtsExec fix_all<CR>", "fix all" },
		{ "<leader>ci", "<cmd>VtsExec add_missing_imports<CR>", "import all" },
		{ "<leader>co", "<cmd>VtsExec organize_imports<CR>", "organize imports" },
		{ "<leader>cs", "<cmd>VtsExec source_actions<CR>", "source actions" },
		{ "<leader>cu", "<cmd>VtsExec remove_unused<CR>", "remove unused" },
		{ "<leader>cU", "<cmd>VtsExec remove_unused_imports<CR>", "remove unused imports" },
		{ "<leader>cf", "<cmd>VtsExec file_references<CR>", "file references" },
		{ "<leader>cr", "<cmd>VtsExec rename_file<CR>", "rename/move file" },
		{ "<leader>cd", "<cmd>VtsExec goto_source_definition<CR>", "go to source definition" },
		{ "<leader>cV", "<cmd>VtsExec select_ts_version<CR>", "select TS version" },
		{ "<leader>cR", "<cmd>VtsExec reload_projects<CR>", "reload projects" },
	}
	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { buffer = bufnr, silent = true, desc = key[3] })
	end

	pcall(function()
		require("which-key.config").add({ { "<leader>c", group = "TypeScript Actions", buffer = bufnr } })
	end)

	shared.prettier_keymap(bufnr)
end

-- Main configuration. Deliberately minimal: `cmd`, `init_options` and the
-- monorepo-aware `root_dir` come from nvim-lspconfig's lsp/vtsls.lua, and
-- `capabilities` from the vim.lsp.config("*", …) block in plugins/lsp/lspconfig.lua.
local M = {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	handlers = handlers,
	on_attach = on_attach,
	settings = settings,
}

return {
	"yioneko/nvim-vtsls",
	ft = M.filetypes,
	dependencies = {
		-- Must load first: supplies the lockfile-rooted, Deno-excluding root_dir.
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		-- Both configured in plugins/lang/tsc.lua, which owns their specs; these are
		-- bare references so vtsls only pulls them in as load-order dependencies.
		"dmmulroy/ts-error-translator.nvim",
		"dmmulroy/tsc.nvim",
	},
	opts = M,
	config = function(_, opts)
		if vim.g.ts_lsp ~= "vtsls" then
			return
		end
		vim.lsp.config("vtsls", opts)
		vim.lsp.enable("vtsls")
	end,
}
