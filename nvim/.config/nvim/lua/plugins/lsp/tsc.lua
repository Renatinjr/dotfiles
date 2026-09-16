-- TypeScript/JavaScript development: TypeScript 7.0's native (Go) language
-- server -- `tsc --lsp --stdio`, shipped inside the plain `typescript` npm
-- package. No Node process, no tsserver wire protocol, no vtsls/ts_ls wrapper.
--
--     npm install -g typescript@7        # global fallback: /opt/homebrew/bin/tsc
--     npm install -D typescript@7        # per-project, wins over the global one
--
-- NOTE the two upstream renames: the binary is `tsc`, not `tsgo` (that was the
-- @typescript/native-preview beta), and nvim-lspconfig's lsp/tsgo.lua is now a
-- deprecation shim over lsp/tsc.lua. Register as "tsc".
--
-- lspconfig's lsp/tsc.lua is deep-merged under the table below and supplies
-- everything machine-specific: the binary probe (node_modules/.bin/tsc -> tsc ->
-- node_modules/.bin/tsgo -> tsgo, each gated on `--version` major >= 7 and
-- cached per root) and the lockfile-rooted, Deno-excluding `root_dir`.
-- `capabilities` comes from the vim.lsp.config("*", ...) block in
-- plugins/lsp/init.lua. So no cmd / root_dir / capabilities here.
--
-- Only one TS server may attach at a time. `vim.g.ts_lsp` picks: "tsc" (default,
-- unset counts) or "vtsls" -- see the mirrored guard in plugins/lsp/vtsls.lua.
--
-- NOTE: in a Deno project no TS client attaches at all. That is intentional:
-- lspconfig's root_dir bails without calling on_dir when deno.json/deno.lock is
-- closer than the package-manager lockfile.
local shared = require("plugins.lsp.ts_shared")

-- The client-side command name that resolved reference/implementation code
-- lenses invoke. The server only emits a command if we name one here.
local SHOW_LOCATIONS = "tsc.showReferences"

local handlers = {
	["textDocument/hover"] = shared.hover,
	["textDocument/signatureHelp"] = shared.signature_help,
	-- Diagnostics arrive over the PULL channel: the server advertises
	-- diagnosticProvider and Neovim 0.12 auto-enables pull diagnostics for such
	-- servers. It also pushes publishDiagnostics by default, and push/pull use
	-- separate diagnostic namespaces, so every message would land twice --
	-- hence `disablePushDiagnostics` in init_options below.
	["textDocument/diagnostic"] = shared.on_diagnostic,
}

-- The TS 7.0 server reads the VS Code settings schema. It asks for four
-- sections and merges them editor < javascript < typescript < js/ts, so a single
-- `js/ts` table covers both languages and outranks everything else. Keys outside
-- the schema are silently ignored (see tsc/internal/ls/lsutil/userpreferences.go
-- upstream); settings with no VS Code path -- preferGoToSourceDefinition,
-- maximumHoverLength -- are reachable only by their raw name under `unstable`.
local settings = {
	["js/ts"] = {
		preferences = {
			importModuleSpecifier = "relative",
			importModuleSpecifierEnding = "minimal",
			useAliasesForRenames = true,
		},
		suggest = {
			autoImports = true,
			includeCompletionsForImportStatements = true,
			includeAutomaticOptionalChainCompletions = true,
			classMemberSnippets = { enabled = true },
			objectLiteralMethodSnippets = { enabled = true },
			jsdoc = { enabled = true },
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
		referencesCodeLens = {
			enabled = true,
			showOnAllFunctions = false,
		},
		-- Plural -- `implementationCodeLens` is not a real key.
		implementationsCodeLens = {
			enabled = true,
			showOnInterfaceMethods = true,
			showOnAllClassMethods = false,
		},
		-- Never fetch @types packages behind our back: it grows the program (and so
		-- every checker built over it) without being asked, and shows up as a
		-- "Loading -- Installing types for 'jsconfig.json'" progress message on
		-- every project load. This is a workspace SETTING, not an init option --
		-- the server reads it from the config sections (raw
		-- "disableAutomaticTypeAcquisition"), so it is silently ignored in
		-- init_options. Both spellings are set: the newer one is the
		-- tsserver.automaticTypeAcquisition.enabled path.
		disableAutomaticTypeAcquisition = true,
		tsserver = {
			automaticTypeAcquisition = {
				enabled = false,
			},
		},
		workspaceSymbols = {
			scope = "allOpenProjects",
			-- Keep node_modules out of the symbol index. On a project whose type
			-- graph is mostly .d.ts (990 of 1216 files here) that index is nearly
			-- all noise, and building it costs memory the checkers then multiply.
			excludeLibrarySymbols = true,
		},
		unstable = {
			-- Makes plain `gd` land on the implementation instead of a `.d.ts`
			-- stub, server-side. This replaces the old client-side definition
			-- filtering, which Neovim 0.12 no longer runs (vim.lsp.buf.definition
			-- aggregates via buf_request_all and never consults client handlers).
			preferGoToSourceDefinition = true,
			-- Server default truncates hover at 500 chars.
			maximumHoverLength = 2000,
		},
	},
}

-- vtsls exposed these as server commands (:VtsExec ...). TypeScript 7.0 has no
-- executeCommandProvider at all -- they are plain code actions now, scoped by
-- kind. tsc 7.0.2 advertises exactly five: quickfix, source.fixAll,
-- source.organizeImports, source.removeUnusedImports and source.sortImports.
-- There are no refactor.* kinds yet, so move-to-file and file-references have no
-- equivalent. Kinds are hierarchical, so the unsuffixed names here keep matching
-- if a later release re-adds the `.ts` suffix upstream carries (verified: asking
-- for `source` returns all three source.* actions, while `source.fixAll.ts`
-- returns none).
--
-- source.fixAll is the one that needs diagnostics to exist before it offers
-- anything -- it fixes what the checker flagged. In a plain JS project it is
-- therefore always empty ("No code actions available"), because `checkJs: false`
-- means the checker reports nothing. The other three are document rewrites and
-- work regardless.
local function code_action(kind, apply)
	return function()
		vim.lsp.buf.code_action({
			context = { only = { kind } },
			apply = apply ~= false,
		})
	end
end

-- `custom/textDocument/sourceDefinition` is a TS-specific request (advertised as
-- capabilities.experimental.customSourceDefinitionProvider). Handy when a symbol
-- resolves into a bundled declaration file despite preferGoToSourceDefinition.
local function goto_source_definition()
	local bufnr = vim.api.nvim_get_current_buf()
	local client = vim.lsp.get_clients({ bufnr = bufnr, name = "tsc" })[1]
	if not client then
		return vim.lsp.buf.definition()
	end

	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:request("custom/textDocument/sourceDefinition", params, function(err, result)
		if err or not result or vim.tbl_isempty(result) then
			-- Declaration-only package: fall back to the regular jump.
			return vim.lsp.buf.definition()
		end

		local locations = vim.islist(result) and result or { result }
		if #locations == 1 then
			return vim.lsp.util.show_document(locations[1], client.offset_encoding, { focus = true })
		end
		vim.fn.setqflist({}, " ", {
			title = "TS source definitions",
			items = vim.lsp.util.locations_to_items(locations, client.offset_encoding),
		})
		vim.cmd("botright copen")
	end, bufnr)
end

-- Package auto-imports are expensive: building the index walks every package the
-- project can reach, and it is charged to the same checker that is already
-- type-checking the open file -- 2.5 GB vs 1.8 GB on a 5000-line JS file.
--
-- It cannot be scoped by filetype: the server merges its settings sections
-- (editor < javascript < typescript < js/ts) into ONE preference set rather than
-- one per language, so setting this under `javascript` alone suppressed package
-- auto-imports in TypeScript too (verified: 88 -> 0 in both). Scope it by project
-- instead. A root with no tsconfig.json is a plain JS project, where the import
-- a package auto-import inserts is an ES `import` into CommonJS anyway, and
-- project-local auto-imports keep working either way. TypeScript projects keep
-- the full index -- pulling `useState` in from react is worth paying for.
-- on_init, not before_init: the client copies config.settings at construction,
-- which happens first, so a mutation there never reaches the server. on_init runs
-- before the `initialized` notification that prompts workspace/configuration.
local function on_init(client)
	local root = client.root_dir
	if not root or vim.fn.filereadable(vim.fs.joinpath(root, "tsconfig.json")) == 1 then
		return
	end
	client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
		["js/ts"] = {
			preferences = {
				autoImportFileExcludePatterns = { "**/node_modules/**" },
			},
		},
	})
	-- The server has already pulled workspace/configuration by the time on_init
	-- mutates client.settings, so tell it to pull again.
	vim.schedule(function()
		if not client.is_stopped or not client:is_stopped() then
			client:notify("workspace/didChangeConfiguration", { settings = client.settings })
		end
	end)
end

-- <leader>ce. tsc.nvim looks for tsconfig.json / tsconfig.*.json only -- a
-- jsconfig.json does not count -- and when it finds none it takes the same
-- early-return as a run that is already going, reporting "Type-checking already
-- in progress". That is indistinguishable from a real failure, so say what is
-- actually wrong before handing over.
local function workspace_errors()
	local ok, utils = pcall(require, "tsc.utils")
	if ok and #utils.find_tsconfigs(true) == 0 then
		vim.notify(
			"No tsconfig.json in this project, so :TSC has nothing to type-check.\n"
				.. "tsc.nvim does not read jsconfig.json. Diagnostics still come from the LSP.",
			vim.log.levels.WARN
		)
		return
	end
	vim.cmd("TSC")
end

local on_attach = function(client, bufnr)
	-- Enable omnifunc
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Keeps a full semanticTokens request off every keystroke; see ts_shared.
	shared.tame_semantic_tokens(client, bufnr)

	-- referencesCodeLens/implementationsCodeLens above render nothing unless the
	-- client is told to collect lenses for this buffer.
	if client:supports_method("textDocument/codeLens") then
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
		-- Resolved lenses call back into us with (uri, position, locations).
		client.commands[SHOW_LOCATIONS] = function(command)
			local locations = command.arguments and command.arguments[3] or {}
			if vim.tbl_isempty(locations) then
				return
			end
			vim.fn.setqflist({}, " ", {
				title = command.title or "TS locations",
				items = vim.lsp.util.locations_to_items(locations, client.offset_encoding),
			})
			vim.cmd("botright copen")
		end
	end

	-- Set with vim.keymap.set rather than which-key's `add()`: which-key only
	-- drains its spec queue once, from its own setup(), so an `add()` issued later
	-- -- e.g. from an LspAttach handler like this one -- is queued and silently
	-- never applied. Same reasoning as plugins/lsp/kotlin.lua. The group label
	-- still goes through which-key, via the module setup() itself calls.
	local keys = {
		{ "<leader>ce", workspace_errors, "workspace errors (TSC)" },
		{ "<leader>cF", code_action("source.fixAll"), "fix all" },
		-- Kept as an alias for the vtsls muscle memory, but it is NOT vtsls's
		-- "add all missing imports": tsc 7.0.2 returns no quickfix actions at all
		-- (verified -- an unresolved name yields a diagnostic and zero code
		-- actions), so there is nothing on the server to bind that to yet.
		-- source.fixAll here only fixes what the checker already flags, e.g.
		-- unused declarations.
		{ "<leader>ci", code_action("source.fixAll"), "fix all (alias)" },
		{ "<leader>co", code_action("source.organizeImports"), "organize imports" },
		{ "<leader>cu", code_action("source.removeUnusedImports"), "remove unused imports" },
		{ "<leader>cS", code_action("source.sortImports"), "sort imports" },
		{ "<leader>cs", code_action("source", false), "source actions" },
		{ "<leader>cd", goto_source_definition, "go to source definition" },
	}
	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { buffer = bufnr, silent = true, desc = key[3] })
	end

	pcall(function()
		require("which-key.config").add({ { "<leader>c", group = "TypeScript Actions", buffer = bufnr } })
	end)

	shared.prettier_keymap(bufnr)
end

local M = {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	init_options = {
		disablePushDiagnostics = true,
		codeLensShowLocationsCommandName = SHOW_LOCATIONS,
	},
	handlers = handlers,
	on_init = on_init,
	on_attach = on_attach,
	settings = settings,
}

-- Optional cap on the server's heap, read from `vim.g.tsc_memory_limit`
-- (set in config/options.lua; unset it to run uncapped).
--
-- Choose the value carefully, because the right value depends on the project and a wrong one
-- is worse than none. Measured on backend-katuxa (a JS project whose controller
-- pulls in a 1216-file type graph, 990 of them node_modules .d.ts, ~2 GB live),
-- typing sixteen characters with blink cancelling each in-flight completion:
--
--   no cap        6.8 GB peak      completions return
--   GOMEMLIMIT=2GiB   5.0 GB peak  completions HANG -- 60s, zero items
--
-- GOMEMLIMIT is a soft limit: the collector works harder to stay under it and
-- never refuses an allocation, so setting it below the program's working set
-- does not fail loudly, it just spins the GC until the server is unusable. Set
-- it only above what the project actually needs -- and note that the working set
-- is per *open file*, since the program is that file's import closure: a leaf
-- module in the same repo loaded 0.43 GB where the controller loaded 2.05 GB.
--
-- Two settings-level levers are cheaper and safer to reach for first, per
-- project rather than globally:
--   preferences.autoImportFileExcludePatterns = { "**/node_modules/**" }
--     -- 2.5 GB -> 1.8 GB, at the cost of package auto-imports
--   a jsconfig.json that scopes `include` -- 2.05 GB -> 1.44 GB live
local function memory_capped_cmd()
	local limit = vim.g.tsc_memory_limit
	if not limit then
		return {}
	end

	-- lspconfig's lsp/tsc.lua probes for a binary supporting `--lsp` in root_dir
	-- and caches it for cmd, both closing over one private table -- so take the
	-- pair from a single instance rather than reimplementing the probe.
	-- GOMEMLIMIT is set around the call because the spawn happens synchronously
	-- inside it, and an environment cannot be passed through a `cmd` that is a
	-- function (cmd_env applies only when cmd is a plain argv).
	local path = vim.api.nvim_get_runtime_file("lsp/tsc.lua", false)[1]
	local ok, base = pcall(dofile, path or "")
	if not ok or type(base) ~= "table" or not base.cmd or not base.root_dir then
		vim.notify("tsc: could not wrap lspconfig's cmd; vim.g.tsc_memory_limit ignored", vim.log.levels.WARN)
		return {}
	end

	return {
		root_dir = base.root_dir,
		cmd = function(dispatchers, config)
			local saved = vim.env.GOMEMLIMIT
			vim.env.GOMEMLIMIT = limit
			local started, rpc = pcall(base.cmd, dispatchers, config)
			vim.env.GOMEMLIMIT = saved
			if not started then
				error(rpc)
			end
			return rpc
		end,
	}
end

return {
	-- Anchored on tsc.nvim rather than nvim-lspconfig: init.lua already declares
	-- nvim-lspconfig with its own `config`, and a second spec for the same plugin
	-- would collide with it. tsc.nvim is the natural home anyway -- it drives the
	-- same TypeScript 7.0 compiler from the other side (`tsc --noEmit`).
	"dmmulroy/tsc.nvim",
	ft = M.filetypes,
	cmd = { "TSC", "TSCOpen", "TSCClose", "TSCStop" },
	dependencies = {
		-- Must load first: supplies cmd, the version-gated binary probe and the
		-- lockfile-rooted, Deno-excluding root_dir.
		"neovim/nvim-lspconfig",
		{
			"dmmulroy/ts-error-translator.nvim",
			-- setup() loads the BetterTypeScriptErrors translation table that
			-- powers parse_errors(). auto_attach stays false because it wraps the
			-- GLOBAL publishDiagnostics handler, which this server never uses --
			-- ts_shared calls parse_errors itself from the pull-diagnostics path.
			opts = {
				auto_attach = false,
			},
		},
	},
	opts = {
		-- Backs <leader>ce: runs `tsc --noEmit` over the project and fills the
		-- quickfix list. Resolves tsc from the project's node_modules/.bin -- on
		-- TS 7.0 that is the native compiler, so it is no longer slow.
		auto_open_qflist = true,
		-- "tsc", not "tsgo": tsc.nvim resolves node_modules/.bin/<bin_name> and
		-- otherwise falls back to <bin_name> on $PATH, so the old beta name failed
		-- both lookups ("tsgo was not available or found in your node_modules or
		-- $PATH"). Same rename as the language server -- see the header.
		bin_name = "tsc",
		auto_focus_qflist = true,
		auto_close_qflist = false,
		run_as_monorepo = true,
		use_diagnostics = false,
		pretty_errors = true,
	},
	config = function(_, opts)
		require("tsc").setup(opts)

		if (vim.g.ts_lsp or "tsc") ~= "tsc" then
			return
		end
		vim.lsp.config("tsc", vim.tbl_extend("force", M, memory_capped_cmd()))
		vim.lsp.enable("tsc")
	end,
}
