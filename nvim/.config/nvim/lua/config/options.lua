vim.opt.tabstop = 2
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s" -- Example with relative line numbers

local signs = { Error = "󰅙 ", Warn = " ", Hint = "💡", Info = " " }
local theme = require("config.theme")

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.INFO] = signs.Info,
			[vim.diagnostic.severity.HINT] = signs.Hint,
		},
	},
	underline = true,
	virtual_text = false,
	virtual_lines = false,
	update_in_insert = true,
	float = {
		header = "true",
		border = "rounded",
		focusable = true,
	},
})

vim.api.nvim_set_hl(0, "LspInlayHint", {
	bg = theme.current_theme.inlay_hint_bg,
	fg = theme.current_theme.inlay_hint_fg,
	italic = true,
	underline = false,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})
