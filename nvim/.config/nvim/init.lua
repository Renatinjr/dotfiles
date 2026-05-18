-- Neovim configuration entry point
-- Target: Neovim >= 0.11

-- Guard: require minimum Neovim version
if vim.fn.has("nvim-0.11") == 0 then
	vim.api.nvim_echo({ { "This config requires Neovim >= 0.11\n", "ErrorMsg" } }, true, {})
	return
end

-- Set leader before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable built-in plugins for performance
local disabled_builtins = {
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"matchit",
	"matchparen",
	"logiPat",
	"rrhelper",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"tohtml",
	"tutor",
}
for _, plugin in ipairs(disabled_builtins) do
	vim.g["loaded_" .. plugin] = 1
end

-- Bootstrap and load configuration
require("config.lazy")
require("config.options")
require("config.autocmds")
require("config.keymaps")
