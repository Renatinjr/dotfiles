-- TypeScript/JavaScript development: tsgo (typescript-go native preview)
--
-- tsgo is the experimental Go port of the TypeScript compiler + language server
-- (https://github.com/microsoft/typescript-go). It is dramatically faster than
-- the Node-based tsserver (vtsls/ts_ls/ts-bridge) but is PREVIEW software --
-- some LSP features (certain refactors/renames/code actions) are incomplete.
--
-- Install the binary (native, no tsserver resolution needed -- unlike ts-bridge,
-- so this works fine with asdf-managed Node):
--
--     npm install -g @typescript/native-preview      # provides `tsgo`
--     # or per-project:  npm install -D @typescript/native-preview
--
-- This module returns a plain config table (lua_ls.lua style) that init.lua
-- feeds to `vim.lsp.config("tsgo", ...)`. The cmd / root_dir logic is taken from
-- nvim-lspconfig's lsp/tsgo.lua so monorepo + Deno detection behave correctly.

local map = vim.keymap.set

local handlers = {
	-- Rounded, non-focusable hover/signature popups (no deprecated vim.lsp.with).
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
}

local on_attach = function(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- Prettier formatting keymap (consistent with the other TS LSP setups).
	local curr_path = vim.fn.getcwd()
	map("n", "<leader>pw", "<cmd>term ~/.local/share/nvim/mason/bin/prettier --write " .. curr_path .. "<CR>", {
		buffer = bufnr,
		desc = "Prettier Format All",
	})

	vim.notify("tsgo attached (preview)", vim.log.levels.INFO)
end

return {
	-- cmd: prefer a project-local node_modules/.bin/tsgo, else the global binary.
	-- Mirrors nvim-lspconfig's lsp/tsgo.lua.
	cmd = function(dispatchers, config)
		local cmd = "tsgo"
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
	end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	-- root_dir: pick the project root (nearest package-manager lockfile), while
	-- bailing out for Deno-managed files so denols can own those. Verbatim from
	-- nvim-lspconfig's lsp/tsgo.lua.
	root_dir = function(bufnr, on_dir)
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })

		local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
		local project_root = vim.fs.root(bufnr, root_markers)
		if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
			return
		end
		if deno_root and (not project_root or #deno_root >= #project_root) then
			return
		end
		on_dir(project_root or vim.fn.getcwd())
	end,
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	handlers = handlers,
	on_attach = on_attach,
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = {
					enabled = "literals",
					suppressWhenArgumentMatchesName = true,
				},
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
	},
}
