-- Autocommands for editor behavior
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
	group = augroup("HighlightYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Show diagnostics float on CursorHold
autocmd("CursorHold", {
	group = augroup("DiagnosticFloat", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})

-- Resize splits on window resize
autocmd("VimResized", {
	group = augroup("ResizeSplits", { clear = true }),
	command = "tabdo wincmd =",
})

-- Close some filetypes with q
autocmd("FileType", {
	group = augroup("CloseWithQ", { clear = true }),
	pattern = { "help", "lspinfo", "notify", "qf", "checkhealth", "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Go back to last position when opening a buffer
autocmd("BufReadPost", {
	group = augroup("LastPlace", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Templ filetype detection
autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("TemplFiletype", { clear = true }),
	pattern = { "*.templ" },
	callback = function(args)
		vim.bo[args.buf].filetype = "templ"
	end,
})

-- Start treesitter on FileType
autocmd("FileType", {
	group = augroup("TreesitterStart", { clear = true }),
	callback = function(args)
		local ok = pcall(vim.treesitter.start, args.buf)
		if ok then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- Also start treesitter on buffers that are already open when plugin loads
vim.schedule(function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			pcall(vim.treesitter.start, buf)
		end
	end
end)

-- Startup notification
autocmd("User", {
	pattern = "LazyVimStarted",
	callback = function()
		local ft = vim.bo.filetype
		if ft == "alpha" then
			vim.opt_local.statuscolumn = ""
		end

		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		vim.notify("Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms")
	end,
})
