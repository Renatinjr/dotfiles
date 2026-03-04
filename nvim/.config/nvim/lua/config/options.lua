-- Mason PATH (must be set before LSP servers start)
local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s"
vim.opt.fillchars = { eob = " " }
vim.opt.hlsearch = false

-- Indentation
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.breakindent = true

-- Behavior
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menuone,noselect"
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- Diagnostics
local signs = { Error = "󰅙 ", Warn = " ", Hint = "💡", Info = " " }
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

-- LSP Inlay Hints
vim.api.nvim_set_hl(0, "LspInlayHint", {
	bg = theme.current_theme.inlay_hint_bg,
	fg = theme.current_theme.inlay_hint_fg,
	italic = true,
	underline = false,
})
