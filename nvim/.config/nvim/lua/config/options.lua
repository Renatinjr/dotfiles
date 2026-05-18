-- Editor options and diagnostic configuration

-- Mason PATH (must be set before LSP servers start)
local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- UI
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "no"

_G.StatusCol = function()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local lnum = vim.v.lnum

	-- Git sign (via extmarks)
	local git_sign = "  "
	local ns = vim.api.nvim_get_namespaces()["gitsigns_signs_"]
	if ns then
		local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns, { lnum - 1, 0 }, { lnum - 1, -1 }, { details = true })
		if #extmarks > 0 then
			local mark = extmarks[1][4]
			if mark.sign_hl_group and mark.sign_text then
				git_sign = "%#" .. mark.sign_hl_group .. "#" .. mark.sign_text .. "%*"
			end
		end
	end

	-- Diagnostic sign
	local diag_sign = "  "
	local diagnostics = vim.diagnostic.get(buf, { lnum = lnum - 1 })
	if #diagnostics > 0 then
		local icons = { " ", " ", " ", " " }
		local hls = { "DiagnosticSignError", "DiagnosticSignWarn", "DiagnosticSignInfo", "DiagnosticSignHint" }
		local best = 5
		for _, d in ipairs(diagnostics) do
			if d.severity < best then
				best = d.severity
			end
		end
		if best < 5 then
			diag_sign = "%#" .. hls[best] .. "#" .. icons[best] .. "%*"
		end
	end

	-- Line number
	local relnum = vim.v.relnum
	local num = relnum == 0 and vim.v.lnum or relnum

	return "%=" .. num .. " " .. git_sign .. diag_sign
end

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

-- Diagnostics
local theme = require("config.theme")

-- vim.diagnostic.config({
-- 	signs = false,
-- 	underline = true,
-- 	virtual_text = false,
-- 	virtual_lines = false,
-- 	update_in_insert = false,
-- 	severity_sort = true,
-- 	float = {
-- 		border = "rounded",
-- 		focusable = true,
-- 		style = "minimal",
-- 		source = true,
-- 		header = "",
-- 		prefix = "",
-- 	},
-- })

-- LSP Inlay Hints highlight
vim.api.nvim_set_hl(0, "LspInlayHint", {
	bg = theme.current_theme.inlay_hint_bg,
	fg = theme.current_theme.inlay_hint_fg,
	italic = true,
	underline = false,
})
