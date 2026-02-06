local M

M = {
	"b0o/incline.nvim",
	event = "BufReadPre",
	config = function()
		local incline = require("incline")
		local theme = require("config.theme")
		local edge_bg = theme.current_theme.bg
		incline.setup({
			window = {
				padding = 0,
				margin = { horizontal = 0, vertical = 1 },
				zindex = 50,
				winhighlight = {
					Normal = "InclineNormal",
					FloatBorder = "InclineBorder",
				},
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "●" or ""
				local filetype_icon, filetype_color = require("nvim-web-devicons").get_icon_color(filename)

				local sizeForm = M.returnSize(props.buf)
				local bg_color = props.focused and theme.current_theme.incline.focused.one
					or theme.current_theme.incline.focused.two

				local buffer = {
					{ filetype_icon, guifg = filetype_color, guibg = bg_color, gui = "bold" }, -- Added bold and larger font
					{ " ", guibg = bg_color },
					{
						filename .. " " .. sizeForm,
						gui = props.focused and "bold" or "none",
						guifg = theme.current_theme.incline.file_name.guifg,
						guibg = bg_color,
					},
					{ modified, guifg = theme.current_theme.incline.modified.guifg, guibg = bg_color },
				}

				return {
					{ "", guifg = edge_bg, guibg = bg_color },
					buffer,
					{ "", guifg = edge_bg, guibg = bg_color },
				}
			end,
		})

		vim.api.nvim_set_hl(
			0,
			"InclineNormal",
			{ fg = theme.current_theme.incline.normal.fg, bg = theme.current_theme.incline.normal.bg }
		)
		vim.api.nvim_set_hl(0, "InclineBorder", { fg = edge_bg, bg = edge_bg })
		vim.api.nvim_set_hl(
			0,
			"InclineNormalNC",
			{ fg = theme.current_theme.incline.normal_nc.fg, bg = theme.current_theme.incline.normal_nc.bg }
		)
	end,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"linrongbin16/commons.nvim",
	},
}

M.returnSize = function(bufnr)
	local uv = vim.loop
	local filename = vim.api.nvim_buf_get_name(bufnr)

	if not filename or filename == "" then
		return ""
	end

	local fstat = uv.fs_stat(filename)

	if not fstat or not fstat.size then
		return ""
	end

	local fsize_value = fstat.size

	if type(fsize_value) ~= "number" or fsize_value <= 0 then
		return ""
	end

	local suffixes = { "B", "KB", "MB", "GB" }
	local i = 1
	while fsize_value > 1024 and i < #suffixes do
		fsize_value = fsize_value / 1024
		i = i + 1
	end

	local fsize_format = i == 1 and "[%d %s] " or "[%.1f %s] "
	local sizeForm = string.format(fsize_format, fsize_value, suffixes[i])
	return sizeForm
end

return M
