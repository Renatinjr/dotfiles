-- Global and LSP keybindings
local map = vim.keymap.set
local utils = require("utils")

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Save
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })

-- Move lines in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down", silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up", silent = true })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Window splits
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>=", "<C-w>=", { desc = "Equalize splits" })

-- Window resize
map("n", "<leader><Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<leader><Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<leader><Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<leader><Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Quickfix
map("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Prev quickfix" })

-- Terminal
map("n", "<leader>tt", "<cmd>botright 15split | terminal<cr>", { desc = "Open terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Paste over selection without yanking
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Delete without yanking
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Replace in visual selection
map("v", "<leader>fp", ":s/", { desc = "Replace in visual selection" })

-- Diagnostics (global, work without LSP)
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
map("n", "O", function()
	vim.diagnostic.open_float(nil, { focus = false })
end, { desc = "Hover diagnostic" })

-- LSP keymaps (set on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
	callback = function(event)
		local opts = function(desc)
			return { buffer = event.buf, silent = true, desc = desc }
		end

		map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
		map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
		map("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
		map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
		map("n", "<C-k>", vim.lsp.buf.signature_help, opts("Signature help"))
		map("n", "gr", vim.lsp.buf.references, opts("Go to references"))
		map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Type definition"))
		map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts("List workspace folders"))
		map("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts("Format document"))

		-- Toggle inlay hints (Neovim 0.10+)
		if vim.lsp.inlay_hint then
			map("n", "<leader>ih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, opts("Toggle inlay hints"))
		end
	end,
})

-- Tmux integration
for _, k in ipairs({ "h", "j", "k", "l", "o" }) do
	map({ "n", "x", "t" }, string.format("<M-%s>", k), function()
		utils.tmux_aware_navigate(k, true)
	end, { silent = true, desc = "Navigate tmux " .. k })
end
