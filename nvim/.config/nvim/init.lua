-- Neovim configuration entry point
-- Target: Neovim >= 0.11

-- Guard: require minimum Neovim version
if vim.fn.has("nvim-0.11") == 0 then
	vim.api.nvim_echo({ { "This config requires Neovim >= 0.11\n", "ErrorMsg" } }, true, {})
	return
end

-- Keep Unix socket paths short (macOS: $TMPDIR + long username can exceed the
-- 104-byte sun_path limit, breaking `serverstart()` for fzf-lua and friends)
if vim.fn.has("win32") == 0 and (vim.env.XDG_RUNTIME_DIR or "") == "" then
	if #vim.fn.stdpath("run") > 60 then
		local run_dir = ("/tmp/nvim.%d"):format(vim.uv.getuid())
		vim.fn.mkdir(run_dir, "p", "0700")
		vim.env.XDG_RUNTIME_DIR = run_dir
	end
end

-- Set leader before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Big-file guard. Must be registered before the first file is read, so it goes
-- ahead of the plugin bootstrap.
require("config.bigfile")

-- Bootstrap and load configuration
require("config.lazy")
require("config.options")
require("config.autocmds")
require("config.keymaps")

-- Per-tag-name colors for HTML/JSX. Registers autocmds only; the work happens
-- when a buffer with tags is shown.
require("config.tagcolors").setup()
