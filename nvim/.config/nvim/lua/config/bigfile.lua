-- Big-file guard.
--
-- Nothing in this config caps what treesitter, the language server and the
-- per-line `statuscolumn` are willing to chew on, and JS is the worst case
-- because bundles, generated code and prettier-less sources all produce very
-- long lines. Measured on a 4 MB, 5000-line JS file with this config:
--
--   loading the buffer                     ~620 MB
--   one full treesitter highlight query    ~800 MB more, 52s blocked
--   tsc (TypeScript 7.0 server)            ~470 MB on a trivial project
--
-- and that is before treesitter-context re-queries on every cursor move and
-- indent-blankline walks the same tree for scope. Several GB is easy.
--
-- The cheapest place to stop all of it at once is filetype detection: give
-- such a buffer the filetype "bigfile" instead of its real one, and every
-- consumer that keys off filetype -- vim.treesitter.start (config/autocmds),
-- vim.lsp.enable, indent-blankline, ftplugins -- simply never engages. Regex
-- syntax is put back afterwards under a `synmaxcol` cap so the file is still
-- readable.
--
-- To load one normally anyway: `:setlocal filetype=javascript`.

local M = {}

-- Any one of these trips the guard.
M.max_bytes = 1536 * 1024 -- 1.5 MB
M.max_lines = 20000
-- Bytes per line. Catches minified/bundled files that are small enough to
-- pass the size check but whose lines are long enough to make the treesitter
-- highlighter quadratic. Ordinary source sits well under 100.
M.max_avg_line = 400

---Reason this buffer is considered too big, or nil if it is fine.
---@param buf integer
---@param path string
---@return string?
function M.reason(buf, path)
	local size = vim.fn.getfsize(path)
	-- -1 for a new or unreadable file, and -2 for one over 2 GB.
	if size == -2 then
		return "over 2 GB"
	elseif size < 0 then
		return nil
	end

	if size > M.max_bytes then
		return ("%.1f MB"):format(size / 1048576)
	end

	local lines = vim.api.nvim_buf_line_count(buf)
	if lines > M.max_lines then
		return ("%d lines"):format(lines)
	end

	local avg = size / math.max(lines, 1)
	if avg > M.max_avg_line then
		return ("%d bytes/line"):format(math.floor(avg))
	end
end

-- The hook below runs inside vim.filetype.match, and the handler needs to ask
-- vim.filetype.match what the real filetype would have been -- so bar the door
-- behind us for that second call.
local detecting = false

vim.filetype.add({
	pattern = {
		[".*"] = {
			function(path, buf)
				if detecting or not path or vim.bo[buf].buftype ~= "" then
					return
				end
				local reason = M.reason(buf, path)
				if reason then
					vim.b[buf].bigfile_reason = reason
					return "bigfile"
				end
			end,
			{ priority = math.huge },
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("BigFile", { clear = true }),
	pattern = "bigfile",
	callback = function(args)
		local buf = args.buf
		vim.b[buf].bigfile = true

		detecting = true
		local ft = vim.filetype.match({ buf = buf, filename = vim.api.nvim_buf_get_name(buf) })
		detecting = false
		vim.b[buf].bigfile_filetype = ft

		-- Undo history of a multi-megabyte buffer is itself multi-megabyte.
		vim.bo[buf].swapfile = false
		vim.bo[buf].undofile = false
		vim.bo[buf].undolevels = -1

		-- config/options.lua's statuscolumn runs an extmark lookup and a
		-- vim.diagnostic.get per visible line per redraw; relativenumber makes
		-- that happen on every cursor move.
		vim.opt_local.statuscolumn = ""
		vim.opt_local.relativenumber = false
		vim.opt_local.cursorline = false
		vim.opt_local.foldmethod = "manual"
		vim.opt_local.foldexpr = "0"
		vim.opt_local.list = false
		vim.opt_local.spell = false
		vim.opt_local.wrap = false
		vim.opt_local.conceallevel = 0
		vim.opt_local.synmaxcol = 200

		-- Regex highlighting instead of treesitter: capped by synmaxcol, so it
		-- costs nothing on the long lines that caused the problem. Deferred so
		-- it lands after this FileType pass rather than nesting inside it.
		if ft and ft ~= "" then
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					vim.bo[buf].syntax = ft
				end
			end)
		end

		vim.notify(
			("Big file (%s): treesitter, LSP and indent guides are off.\n:setlocal filetype=%s to load it anyway."):format(
				vim.b[buf].bigfile_reason or "?",
				ft ~= "" and ft or "<ft>"
			),
			vim.log.levels.WARN
		)
	end,
})

-- Setting a real filetype on a guarded buffer means "load it anyway": drop the
-- flag and every local override so treesitter, the LSP and the statuscolumn
-- come back. Registered here, ahead of config/autocmds.lua, so the flag is
-- already gone by the time TreesitterStart runs for the same event.
vim.api.nvim_create_autocmd("FileType", {
	group = "BigFile",
	callback = function(args)
		if args.match == "bigfile" or not vim.b[args.buf].bigfile then
			return
		end
		vim.b[args.buf].bigfile = nil
		vim.cmd(
			"setlocal statuscolumn< relativenumber< cursorline< foldmethod< foldexpr< list< "
				.. "spell< wrap< conceallevel< synmaxcol< swapfile< undofile< undolevels<"
		)
	end,
})

return M
