local custom_hint_handlers = {
	sumneko_lua = function() end,
}

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimStarted",
	callback = function()
		local ft = vim.bo.filetype
		if ft == "alpha" then
			vim.opt_local.statuscolumn = ""
		end

		local stats = require("lazy").stats()
		vim.notify(
			"🚀 Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. stats.startuptime .. "ms",
			vim.log.levels.INFO
		)
	end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})

local api = require("nvim-tree.api")
api.events.subscribe(api.events.Event.TreeOpen, function()
	vim.opt_local.statuscolumn = ""
end)

vim.api.nvim_create_user_command("VtslsOrganizeImports", function()
	vim.lsp.buf.execute_command({
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	})
end, {})

vim.api.nvim_create_user_command("VtslsRenameFile", function(opts)
	local new_name = opts.args
	if not new_name or new_name == "" then
		vim.notify("Please provide a new filename", vim.log.levels.ERROR)
		return
	end
	vim.lsp.buf.execute_command({
		command = "_typescript.applyRenameFile",
		arguments = {
			{
				sourceUri = vim.uri_from_fname(vim.api.nvim_buf_get_name(0)),
				targetUri = vim.uri_from_fname(new_name),
			},
		},
	})
end, { nargs = 1 })

vim.api.nvim_create_user_command("VtslsImportAll", function()
	vim.lsp.buf.execute_command({
		command = "_typescript.importAll",
		arguments = { vim.api.nvim_buf_get_name(0) },
	})
end, {})
