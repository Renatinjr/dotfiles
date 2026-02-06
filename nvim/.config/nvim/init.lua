vim.g.mapleader = " "

vim.cmd("au BufRead,BufNewFile *.templ setfiletype templ")

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = { "*.templ" },
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_option(buf, "filetype", "templ")
	end,
})

vim.o.hlsearch = false
vim.wo.number = true

vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true

vim.opt.fillchars = { eob = " " }
vim.opt.number = true
vim.opt.relativenumber = true

local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

require("config.lazy").Lazy(_)
require("config.autocmds")
require("config.options")
require("config.keymaps")
