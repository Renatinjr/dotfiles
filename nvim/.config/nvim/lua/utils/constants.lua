-- Shared constants for the Neovim configuration
local M = {}

M.diagnostic = {
	signs = { error = "󰅚 ", warn = " ", hint = "󰌶", info = " ", ok = " " },
}

M.window = {
	border = "rounded",
	layout = {
		middle = {
			scale = 0.85,
		},
		large = {
			scale = 0.9,
		},
		sidebar = {
			scale = 0.2,
			min = 20,
			max = 60,
		},
	},
	blend = 15,
}

M.perf = {
	maxfilesize = 1024 * 1024 * 5, -- 5 MB
}

M = vim.tbl_deep_extend("force", M, vim.g.lin_nvim_builtin_constants or {})

local os_name = vim.uv.os_uname().sysname

M.os = {
	name = os_name,
	is_macos = vim.fn.has("mac") > 0,
	is_windows = vim.fn.has("win32") > 0 or vim.fn.has("win64") > 0,
	is_bsd = vim.fn.has("bsd") > 0,
}

return M
