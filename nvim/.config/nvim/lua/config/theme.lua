local M = {}

local kanso = function()
	local ok, kanso_colors = pcall(require, "kanso.colors")
	if not ok then
		return {}
	end

	local colors = kanso_colors.setup({ theme = "zen" })
	local palette = colors.palette
	local theme = colors.theme

	return {
		bg = theme.ui.bg,
		bg_sec = theme.ui.bg_gutter,
		bg_notify = theme.ui.bg_p1,
		text = theme.ui.fg,
		text_sec = theme.ui.nontext,
		inlay_hint_bg = theme.ui.bg_gutter,
		inlay_hint_fg = "#818890",

		fzf = {
			setup_colors = function()
				local fzf_colors = {
					bg = theme.ui.bg,
					fg = theme.ui.fg,
					border = theme.ui.bg_p2,
					cursor_line_bg = theme.ui.bg_gutter,
					blue = theme.syn.fun,
					light_blue = theme.syn.special1,
					purple = theme.syn.keyword,
					red = theme.diag.error,
					green = theme.syn.string,
					orange = theme.syn.constant,
					comment = theme.syn.comment,
				}

				local highlights = {
					FzfLuaNormal = { bg = fzf_colors.bg, fg = fzf_colors.fg },
					FzfLuaBorder = { fg = "#a4a7a4" },
					FzfLuaCursorLine = { bg = fzf_colors.cursor_line_bg, fg = fzf_colors.purple },
					FzfLuaTitle = { fg = fzf_colors.blue, bold = true },
					FzfLuaPrompt = { fg = fzf_colors.purple, bold = true },
					FzfLuaPointer = { fg = fzf_colors.purple, bold = true },
					FzfLuaMarker = { fg = fzf_colors.green },
					FzfLuaSpinner = { fg = fzf_colors.purple, bold = true },
					FzfLuaHeader = { fg = fzf_colors.comment },
					FzfLuaPreviewTitle = { fg = fzf_colors.purple, bold = true },
				}

				for group, opts in pairs(highlights) do
					vim.api.nvim_set_hl(0, group, opts)
				end

				return {
					normal = "FzfLuaNormal",
					border = "FzfLuaBorder",
					cursor = "FzfLuaPointer",
					cursorline = "FzfLuaCursorLine",
					title = "FzfLuaTitle",
					prompt = "FzfLuaPrompt",
					pointer = "FzfLuaPointer",
					marker = "FzfLuaMarker",
					spinner = "FzfLuaSpinner",
					header = "FzfLuaHeader",
					preview_title = "FzfLuaPreviewTitle",
					help_normal = "FzfLuaNormal",
					help_border = "FzfLuaBorder",
				}
			end,
		},

		alpha = {
			heading = theme.syn.constant,
			button = theme.syn.keyword,
			shortcut = theme.syn.fun,
		},

		incline = {
			normal = {
				bg = theme.ui.bg_p2,
				fg = theme.ui.fg,
			},
			border = {
				bg = theme.ui.bg,
				fg = theme.ui.bg,
			},
			normal_nc = {
				bg = theme.ui.bg_p2,
				fg = theme.ui.nontext,
			},
			focused = {
				one = theme.ui.bg_p2,
				two = theme.ui.bg_p2,
			},
			file_name = { guifg = theme.ui.fg },
			modified = { guifg = theme.syn.constant },
		},

		bufferline = {
			fill = {
				fg = theme.ui.bg,
				bg = theme.ui.bg,
			},
			background = {
				fg = theme.syn.comment,
				bg = theme.ui.bg,
			},
			tab = {
				fg = theme.syn.comment,
				bg = theme.ui.bg_gutter,
			},
			tab_selected = {
				fg = theme.ui.fg,
				bg = theme.ui.bg,
				bold = true,
			},
			tab_close = {
				fg = theme.syn.comment,
				bg = theme.ui.bg_gutter,
			},
			close_button = {
				fg = theme.diag.error,
				bg = theme.ui.bg_gutter,
			},
			close_button_visible = {
				fg = theme.diag.error,
				bg = theme.ui.bg_gutter,
			},
			close_button_selected = {
				fg = theme.diag.error,
				bg = theme.ui.bg,
			},
			buffer_visible = {
				fg = theme.syn.comment,
				bg = theme.ui.bg_gutter,
			},
			buffer_selected = {
				fg = theme.ui.fg,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			numbers = {
				fg = theme.syn.string,
				bg = theme.ui.bg_gutter,
			},
			numbers_visible = {
				fg = theme.syn.string,
				bg = theme.ui.bg_gutter,
			},
			numbers_selected = {
				fg = theme.syn.string,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			diagnostic = {
				fg = theme.syn.comment,
				bg = theme.ui.bg_gutter,
			},
			diagnostic_visible = {
				fg = theme.syn.comment,
				bg = theme.ui.bg_gutter,
			},
			diagnostic_selected = {
				fg = theme.ui.fg,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			hint = {
				fg = theme.syn.keyword,
				bg = theme.ui.bg_gutter,
			},
			hint_visible = {
				fg = theme.syn.keyword,
				bg = theme.ui.bg_gutter,
			},
			hint_selected = {
				fg = theme.syn.keyword,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			hint_diagnostic = {
				fg = theme.syn.keyword,
				bg = theme.ui.bg_gutter,
			},
			hint_diagnostic_visible = {
				fg = theme.syn.keyword,
				bg = theme.ui.bg_gutter,
			},
			hint_diagnostic_selected = {
				fg = theme.syn.keyword,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			info = {
				fg = theme.syn.fun,
				bg = theme.ui.bg_gutter,
			},
			info_visible = {
				fg = theme.syn.fun,
				bg = theme.ui.bg_gutter,
			},
			info_selected = {
				fg = theme.syn.fun,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			info_diagnostic = {
				fg = theme.syn.fun,
				bg = theme.ui.bg_gutter,
			},
			info_diagnostic_visible = {
				fg = theme.syn.fun,
				bg = theme.ui.bg_gutter,
			},
			info_diagnostic_selected = {
				fg = theme.syn.fun,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			warning = {
				fg = theme.diag.warning,
				bg = theme.ui.bg_gutter,
			},
			warning_visible = {
				fg = theme.diag.warning,
				bg = theme.ui.bg_gutter,
			},
			warning_selected = {
				fg = theme.diag.warning,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			warning_diagnostic = {
				fg = theme.diag.warning,
				bg = theme.ui.bg_gutter,
			},
			warning_diagnostic_visible = {
				fg = theme.diag.warning,
				bg = theme.ui.bg_gutter,
			},
			warning_diagnostic_selected = {
				fg = theme.diag.warning,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			error = {
				fg = theme.diag.error,
				bg = theme.ui.bg_gutter,
			},
			error_visible = {
				fg = theme.diag.error,
				bg = theme.ui.bg_gutter,
			},
			error_selected = {
				fg = theme.diag.error,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			error_diagnostic = {
				fg = theme.diag.error,
				bg = theme.ui.bg_gutter,
			},
			error_diagnostic_visible = {
				fg = theme.diag.error,
				bg = theme.ui.bg_gutter,
			},
			error_diagnostic_selected = {
				fg = theme.diag.error,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			modified = {
				fg = theme.diag.warning,
				bg = theme.ui.bg_gutter,
			},
			modified_visible = {
				fg = theme.diag.warning,
				bg = theme.ui.bg_gutter,
			},
			modified_selected = {
				fg = theme.diag.warning,
				bg = theme.ui.bg,
			},
			duplicate = {
				fg = theme.syn.comment,
				bg = theme.ui.bg_gutter,
				italic = true,
			},
			duplicate_visible = {
				fg = theme.syn.comment,
				bg = theme.ui.bg_gutter,
				italic = true,
			},
			duplicate_selected = {
				fg = theme.ui.fg,
				bg = theme.ui.bg,
				italic = false,
			},
			separator = {
				fg = theme.ui.bg_p2,
				bg = theme.ui.bg,
			},
			separator_visible = {
				fg = theme.ui.bg_p2,
				bg = theme.ui.bg_gutter,
			},
			separator_selected = {
				fg = theme.ui.bg_p2,
				bg = theme.ui.bg,
			},
			indicator_selected = {
				fg = theme.syn.keyword,
				bg = theme.ui.bg,
			},
			pick_selected = {
				fg = theme.syn.special1,
				bg = theme.ui.bg,
				bold = true,
				italic = false,
			},
			pick_visible = {
				fg = theme.syn.special1,
				bg = theme.ui.bg_gutter,
				bold = true,
				italic = false,
			},
			pick = {
				fg = theme.syn.special1,
				bg = theme.ui.bg_gutter,
				bold = true,
				italic = false,
			},
		},
	}
end

M.kanso = kanso()

M.current_theme = kanso()

return M
