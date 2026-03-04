-- Startup notification
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimStarted",
	callback = function()
		local ft = vim.bo.filetype
		if ft == "alpha" then
			vim.opt_local.statuscolumn = ""
		end

		local stats = require("lazy").stats()
		vim.notify(
			"Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. stats.startuptime .. "ms",
			vim.log.levels.INFO
		)
	end,
})

-- Float diagnostics on cursor hold
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})

-- Templ filetype detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.templ" },
	callback = function(args)
		vim.bo[args.buf].filetype = "templ"
	end,
})
