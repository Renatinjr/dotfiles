-- Shared TypeScript/JavaScript LSP helpers.
--
-- Two TS servers live in this config and only one attaches at a time (see
-- `vim.g.ts_lsp` in lua/plugins/lsp/tsc.lua): TypeScript 7.0's native Go server
-- (`tsc --lsp`) and the older Node tsserver wrapper (vtsls). They want the same
-- popup styling, the same diagnostic clean-up and the same `.d.ts`-skipping
-- definition jump, so those live here instead of being copy-pasted per server.
--
-- Plain module -- required by the two server specs, never seen by lazy.nvim.

local M = {}

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

-- Inlined from utils/filterReactDTS.lua
local function filterReactDTS(value)
	-- Depending on typescript version either uri or targetUri is returned
	if value.uri then
		return string.match(value.uri, "%.d.ts") == nil
	elseif value.targetUri then
		return string.match(value.targetUri, "%.d.ts") == nil
	end
end

-- ts-error-translator exposes no translate(); parse_errors is the public API and
-- it expects the "TS<code>: " prefix to find the template. Mirrors the plugin's
-- own translate_diagnostic_message (lua/ts-error-translator/diagnostic.lua).
local function translate(message, code)
	local with_code = code and ("TS" .. tostring(code) .. ": " .. message) or message
	local ok, parsed = pcall(require("ts-error-translator").parse_errors, with_code)
	if ok and parsed and parsed[1] and parsed[1].improvedError then
		return parsed[1].improvedError.body
	end
	return message
end

-- Diagnostic codes that are dropped before anything renders.
--
--   80001  "File is a CommonJS module; it may be converted to an ES module"
--    2691  an import path should not end in a file extension
--
-- Note that a JS project only produces diagnostics at all when its jsconfig sets
-- `checkJs: true`, and that is deliberately off here: turning it on made the
-- server type-check every JS file in the program, which drove CPU to 99% and the
-- resident set past 5 GB on this codebase. Lint-type findings (unused variables,
-- unreachable code) come from eslint instead -- see plugins/lsp/eslint.lua.
local DROP_CODES = { [80001] = true, [2691] = true }

--- Drop noisy diagnostics and rewrite the survivors through ts-error-translator.
--- Shared by the push and pull paths below, which differ only in where the list
--- lives inside the payload.
---@param diagnostics table[]?
---@return table[]
function M.clean(diagnostics)
	local kept = {}
	for _, diagnostic in ipairs(diagnostics or {}) do
		if not DROP_CODES[diagnostic.code] then
			diagnostic.message = translate(diagnostic.message, diagnostic.code)
			table.insert(kept, diagnostic)
		end
	end
	return kept
end

-- Rounded, non-focusable hover/signature popups. Plain wrappers rather than
-- vim.lsp.with(), which is deprecated on Neovim 0.11+.
function M.hover(err, result, ctx, config)
	config = vim.tbl_extend("force", config or {}, {
		silent = true,
		border = "rounded",
		focusable = false,
	})
	return vim.lsp.handlers.hover(err, result, ctx, config)
end

function M.signature_help(err, result, ctx, config)
	config = vim.tbl_extend("force", config or {}, {
		border = "rounded",
		focusable = false,
	})
	return vim.lsp.handlers.signature_help(err, result, ctx, config)
end

--- textDocument/publishDiagnostics -- the *push* path, used by vtsls. The TS 7.0
--- server is started with `disablePushDiagnostics` so it never reaches this.
function M.on_publish_diagnostics(err, result, ctx, config)
	if result and result.diagnostics then
		result.diagnostics = M.clean(result.diagnostics)
	end
	return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
end

--- textDocument/diagnostic -- the *pull* path. Neovim 0.12 enables pull
--- diagnostics for every server advertising `diagnosticProvider` (see
--- vim/lsp.lua -> diagnostic._enable), which is where TS 7.0's diagnostics
--- actually arrive. A full report carries `items`; `relatedDocuments` carries a
--- nested report per URI for inter-file dependencies.
function M.on_diagnostic(err, result, ctx)
	if result then
		if result.items then
			result.items = M.clean(result.items)
		end
		for _, report in pairs(result.relatedDocuments or {}) do
			if report.items then
				report.items = M.clean(report.items)
			end
		end
	end
	return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
end

--- Jump past React's `.d.ts` stubs when a definition request returns several
--- candidates.
---
--- NOTE: inert on Neovim 0.12 -- `vim.lsp.buf.definition` goes through
--- `buf_request_all` and aggregates the results itself, so it never dispatches
--- to a per-client handler, and `vim.lsp.handlers["textDocument/definition"]`
--- no longer exists. Kept for older clients and for explicit dispatch; the TS
--- 7.0 server solves the same problem server-side with
--- `preferGoToSourceDefinition` (see plugins/lsp/tsc.lua).
function M.definition(err, result, method, ...)
	local default = vim.lsp.handlers["textDocument/definition"]
	if not default then
		return
	end
	if not result or vim.tbl_isempty(result) then
		return default(err, result, method, ...)
	end
	if vim.islist(result) and #result > 1 then
		local filtered_result = filter(result, filterReactDTS)
		return default(err, filtered_result, method, ...)
	end
	default(err, result, method, ...)
end

-- Semantic tokens are the single most expensive thing either TS server does
-- while you type.
--
-- On an *unchanged* buffer a full semanticTokens request is nearly free (15 ms
-- on a 5154-line file). Issued after an edit it is not: it forces a fresh type
-- checker for the new program version, and the server's checker pool keeps it,
-- so the memory is live and never comes back. Neovim refreshes tokens on every
-- didChange, which means every keystroke pays for one. Measured on a 5154-line
-- controller, typing a 54-character line:
--
--   as-is                      2.4 CPU-s   1.17 -> 1.78 GB
--   semantic tokens disabled   0.1 CPU-s   1.15 -> 1.17 GB
--
-- Nothing else is close: with tokens off, pull diagnostics and code lens
-- together account for that remaining 0.1 CPU-s (the JS project sets
-- `checkJs: false`, so there is barely anything to check).
--
-- Cost per edit scales hard with file size -- 841 lines 0.2 CPU-s, 1586 lines
-- 0.3, 5154 lines 1.9 -- hence two rules rather than one:
--
--   * suspend while in insert mode, so an editing session costs one refresh
--     instead of one per keystroke. This also covers blink's completion menu:
--     it writes the selected entry into the buffer as you move through the
--     list, and each of those writes is an edit.
--   * off entirely past semantic_tokens_max_lines, where even a single refresh
--     is too expensive to pay on every InsertLeave.
M.semantic_tokens_max_lines = 2000

-- clear = false: the autocmds below are buffer-scoped and cleared per buffer.
-- Re-creating the group with clear = true on each attach would wipe the ones
-- belonging to every other buffer.
local st_group = vim.api.nvim_create_augroup("TsSemanticTokens", { clear = false })

--- Suspend semantic tokens while typing, and disable them outright on buffers
--- too large to afford a refresh at all.
function M.tame_semantic_tokens(client, bufnr)
	if not client:supports_method("textDocument/semanticTokens/full") then
		return
	end
	-- on_attach runs again for the same buffer when the server restarts.
	vim.api.nvim_clear_autocmds({ group = st_group, buffer = bufnr })

	-- Re-checked on every InsertLeave rather than once here, so a buffer that
	-- grows past the threshold turns its own tokens off.
	local function affordable()
		return vim.api.nvim_buf_line_count(bufnr) <= M.semantic_tokens_max_lines
	end

	-- bufnr only, deliberately no client_id: vim.lsp._capability.enable stores
	-- its marker on the *client* whenever a client_id is passed, even alongside
	-- a bufnr, so `{ bufnr = b, client_id = id }` disables the capability for
	-- every buffer that client is attached to rather than just this one. Passing
	-- bufnr alone stores it in vim.b and keeps the scope per buffer.
	local function set(on)
		if vim.api.nvim_buf_is_valid(bufnr) then
			pcall(vim.lsp.semantic_tokens.enable, on, { bufnr = bufnr })
		end
	end

	if not affordable() then
		set(false)
	end

	-- Only restore what we ourselves suspended, so a global
	-- `vim.lsp.semantic_tokens.enable(false)` is not undone on every InsertLeave.
	local suspended = false

	vim.api.nvim_create_autocmd("InsertEnter", {
		group = st_group,
		buffer = bufnr,
		callback = function()
			if vim.lsp.semantic_tokens.is_enabled({ bufnr = bufnr }) then
				suspended = true
				set(false)
			end
		end,
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = st_group,
		buffer = bufnr,
		callback = function()
			if suspended then
				suspended = false
				set(affordable())
			end
		end,
	})
	vim.api.nvim_create_autocmd("LspDetach", {
		group = st_group,
		buffer = bufnr,
		callback = function(args)
			if args.data and args.data.client_id == client.id then
				-- Scheduled: this would otherwise clear the group from inside
				-- one of that group's own callbacks.
				vim.schedule(function()
					vim.api.nvim_clear_autocmds({ group = st_group, buffer = bufnr })
				end)
			end
		end,
	})
end

--- <leader>pw: run the Mason-installed prettier over the whole project.
function M.prettier_keymap(bufnr)
	local curr_path = vim.fn.getcwd()
	vim.keymap.set(
		"n",
		"<leader>pw",
		"<cmd>term ~/.local/share/nvim/mason/bin/prettier --write " .. curr_path .. "<CR>",
		{
			buffer = bufnr,
			desc = "Prettier Format All",
		}
	)
end

return M
