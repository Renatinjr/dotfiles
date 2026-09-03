-- ESLint language server (vscode-eslint-language-server, Mason package
-- "eslint-lsp").
--
-- Why this exists alongside the TypeScript server: `tsc` reports nothing at all
-- for a plain JS file unless the project sets `checkJs: true`, and on this
-- codebase that setting made the server type-check every JS file in the program
-- -- 99% CPU and past 5 GB resident. ESLint answers the question that was
-- actually being asked (what is declared and never read, what is unreachable) in
-- its own Node process that never builds a type graph, so the two are
-- complementary rather than redundant: tsc keeps completion, hover and
-- go-to-definition; eslint owns lint diagnostics.
--
-- It only attaches where a flat config is present: lspconfig's lsp/eslint.lua
-- roots on eslint.config.{js,mjs,cjs,ts,...} plus the legacy .eslintrc* names and
-- returns without calling on_dir otherwise, so a project without one never
-- starts a server. Note that its root_dir wants a package-manager lockfile or a
-- .git directory -- backend-katuxa has no lockfile, so .git is what roots it.
--
-- lspconfig also supplies cmd (preferring the project's own
-- node_modules/.bin/vscode-eslint-language-server), filetypes, a full default
-- settings table, before_init and the eslint/* handlers. Capabilities come from
-- the vim.lsp.config("*", ...) block in plugins/lsp/init.lua.
--
-- Plain module rather than a lazy spec: M.setup() has to run *after*
-- nvim-lspconfig is on the runtimepath, because it reads the shipped
-- vim.lsp.config.eslint before overriding it. plugins/lsp/init.lua calls it from
-- the nvim-lspconfig `config` hook, next to the other servers.

local M = {}

M.settings = {
	-- lspconfig defaults this to "onType", which re-lints on every keystroke.
	-- That is far cheaper than the TypeScript checker -- eslint parses one file
	-- and never resolves imports across the program -- but it is still
	-- per-keystroke work on a 5000-line controller. Opening a file still lints it
	-- immediately; only live updates wait for the write. Set "onType" for
	-- immediate feedback.
	run = "onSave",

	-- Do not let this server rewrite the buffer: prettier owns formatting here
	-- (conform.nvim), and two writers on one save race. lspconfig defaults format
	-- to true.
	format = false,

	-- Fold multi-line rule messages onto one line so they fit the inline
	-- diagnostic renderer (tiny-inline-diagnostic).
	problems = { shortenToSingleLine = true },
}

function M.setup()
	-- Read the shipped config before overriding it: lspconfig's on_attach is what
	-- creates the buffer-local :LspEslintFixAll command, and a plain `on_attach`
	-- key here would replace it rather than run alongside.
	local base_on_attach = (vim.lsp.config.eslint or {}).on_attach

	vim.lsp.config("eslint", {
		settings = M.settings,
		on_attach = function(client, bufnr)
			if base_on_attach then
				base_on_attach(client, bufnr)
			end

			-- ESLint's fixes come back as a server command rather than a plain
			-- workspace edit, so vim.lsp.buf.code_action cannot apply them
			-- wholesale -- go through the command lspconfig registered above.
			vim.keymap.set("n", "<leader>cl", "<cmd>LspEslintFixAll<CR>", {
				buffer = bufnr,
				silent = true,
				desc = "eslint fix all",
			})

			pcall(function()
				require("which-key.config").add({ { "<leader>c", group = "Code", buffer = bufnr } })
			end)

			-- Belt and braces alongside `format = false` above.
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
	})
end

return M
