-- Editor options and diagnostic configuration

-- Mason PATH (must be set before LSP servers start)
local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- TypeScript/JavaScript language server. Unset means "tsc" -- TypeScript 7.0's
-- native Go server (`tsc --lsp`, plugins/lang/tsc.lua). Uncomment to fall back to
-- the Node tsserver wrapper (plugins/lang/vtsls.lua), which still has the
-- refactors TS 7.0 has not landed yet (move to file, file references).
-- vim.g.ts_lsp = "vtsls"

-- Soft cap on the TypeScript 7.0 server's heap (Go's GOMEMLIMIT). Every blink
-- completion makes the server build a checker over the whole open file, and
-- cancelling the in-flight request does not undo work the server already
-- started, so a burst of typing in a large file piles up garbage faster than the
-- collector is asked to deal with it.
--
-- This MUST sit above the project's live program or the GC thrashes and
-- completions stop returning at all -- see the measurements in
-- plugins/lang/tsc.lua. Raise it for a monorepo that legitimately needs more.
vim.g.tsc_memory_limit = "2GiB"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- UI
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.termsync = false
vim.opt.signcolumn = "no"

-- Custom status column: relative number + git sign + diagnostic sign.
require("config.statuscolumn")
vim.opt.statuscolumn = "%!v:lua.StatusCol()"
vim.opt.showmode = false
vim.opt.fillchars = { eob = " " }
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.pumheight = 5
vim.opt.pumblend = 30
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Behavior
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menuone,noselect"
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
