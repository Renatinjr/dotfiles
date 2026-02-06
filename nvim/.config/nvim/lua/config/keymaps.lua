-- Keymaps are configured here
-- For more information, see ":help keymaps"
local map = vim.keymap.set
local utils = require("utils.utils")

-- General
map({ "n", "v", "i" }, "<C-S>", ":w<CR>", { silent = true, desc = "Save file" })
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "Move selected lines up" })
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map({ "v" }, "<leader>fp", ":s/", { desc = "Replace in visual selection" })

-- LSP (Language Server Protocol)
-- For more information, see ":help lsp"
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map("n", "<leader>wl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>f", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format file" })

-- Window & Split Management
-- For more information, see ":help windows"
map("n", "<leader>=", "<C-w>=", { silent = true, desc = "Equalize split layout" })
map(
	"n",
	"<leader><Up>",
	"<cmd>lua require('utils.utils').resize(false,-5)<CR>",
	{ silent = true, desc = "Increase horizontal split size" }
)
map(
	"n",
	"<leader><Down>",
	"<cmd>lua require('utils.utils').resize(false,5)<CR>",
	{ silent = true, desc = "Decrease horizontal split size" }
)
map(
	"n",
	"<leader><Left>",
	"<cmd>lua require('utils.utils').resize(true,-5)<CR>",
	{ silent = true, desc = "Decrease vertical split size" }
)
map(
	"n",
	"<leader><Right>",
	"<cmd>lua require('utils.utils').resize(true,5)<CR>",
	{ silent = true, desc = "Increase vertical split size" }
)

-- Tmux Integration
-- For more information, see your tmux configuration
for _, k in ipairs({ "h", "j", "k", "l", "o" }) do
	map({ "n", "x", "t" }, string.format("<M-%s>", k), function()
		utils.tmux_aware_navigate(k, true)
	end, { silent = true, desc = "Navigate tmux " .. k })
end

-- Miscellaneous
function _G.memory_usage()
	local mem = collectgarbage("count") / 1024
	local hints = vim.lsp.inlay_hint.is_enabled() and "ON" or "OFF"
	print(string.format("Memory: %.2fMB | Inlay Hints: %s", mem, hints))
end

map("n", "<leader>mu", "<cmd>lua memory_usage()<CR>", { desc = "Show memory usage" })

