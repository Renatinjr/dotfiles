-- Status column renderer: "<relnum> <git sign><diagnostic sign>".
--
-- Exposed as a global because 'statuscolumn' evaluates a vimscript expression
-- (`%!v:lua.StatusCol()`); options.lua wires it up. Git signs are read from
-- gitsigns' extmarks so signcolumn can stay off.
_G.StatusCol = function()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local lnum = vim.v.lnum

	-- Git sign (via extmarks)
	local git_sign = "  "
	local ns = vim.api.nvim_get_namespaces()["gitsigns_signs_"]
	if ns then
		local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns, { lnum - 1, 0 }, { lnum - 1, -1 }, { details = true })
		if #extmarks > 0 then
			local mark = extmarks[1][4]
			if mark.sign_hl_group and mark.sign_text then
				git_sign = "%#" .. mark.sign_hl_group .. "#" .. mark.sign_text .. "%*"
			end
		end
	end

	-- Diagnostic sign
	local diag_sign = "  "
	local diagnostics = vim.diagnostic.get(buf, { lnum = lnum - 1 })
	if #diagnostics > 0 then
		local icons = { " ", " ", " ", " " }
		local hls = { "DiagnosticSignError", "DiagnosticSignWarn", "DiagnosticSignInfo", "DiagnosticSignHint" }
		local best = 5
		for _, d in ipairs(diagnostics) do
			if d.severity < best then
				best = d.severity
			end
		end
		if best < 5 then
			diag_sign = "%#" .. hls[best] .. "#" .. icons[best] .. "%*"
		end
	end

	-- Line number
	local relnum = vim.v.relnum
	local num = relnum == 0 and vim.v.lnum or relnum

	return "%=" .. num .. " " .. git_sign .. diag_sign
end
