-- vscode-html-language-server (Mason package "html-lsp").
--
-- `filetypes` is set only to add `blade` to lspconfig's default list, which is
-- what gives Laravel views tag and attribute completion, closing-tag help and
-- hover docs on HTML elements. The server emits no diagnostics of its own, so
-- blade directives and `{{ ... }}` expressions pass through it without
-- complaint -- unlike intelephense, which is why that one stays off blade (see
-- servers/intelephense.lua).
--
-- `templ` is carried over from lspconfig's default so the *.templ filetype set
-- in config/autocmds.lua keeps whatever it had.
return {
	filetypes = { "html", "templ", "blade" },
}
