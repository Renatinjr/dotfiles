-- lazy.nvim bootstrap and plugin loader
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Every file under these directories is a plugin spec (or a list of specs).
-- Plain helper modules live outside lua/plugins/ (lua/lsp, lua/themes, lua/utils).
require("lazy").setup({
	{ import = "plugins.ui" },
	{ import = "plugins.editor" },
	{ import = "plugins.coding" },
	{ import = "plugins.lsp" },
	{ import = "plugins.lang" },
	{ import = "plugins.tools" },
}, {
	defaults = { lazy = true },
	install = { colorscheme = { "koda-dark", "habamax" } },
	checker = { enabled = false },
	change_detection = { notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- Registers the ColorScheme hooks and applies the persisted theme. Must run
-- after lazy (it loads colorscheme plugins on demand) and before anything that
-- reads config.theme.current_theme.
require("config.theme.switcher").setup()
