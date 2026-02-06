local M = {}

local kanso = function()
	local colors = require("kanso.colors").setup({ theme = "ink" })
	return {
		bg = colors.background,
		bg_sec = colors.background_dark,
		bg_notify = colors.background,
		text = colors.foreground,
		text_sec = colors.comment,
		inlay_hint_bg = colors.background_dark,
		inlay_hint_fg = "#818890",
		fzf = {
			setup_colors = function()
				local fzf_colors = {
					bg = colors.background,
					fg = colors.foreground,
					border = colors.background_light,
					cursor_line_bg = colors.background_dark,
					blue = colors.blue,
					light_blue = colors.cyan,
					purple = colors.purple,
					red = colors.red,
					green = colors.green,
					orange = colors.orange,
					comment = colors.comment,
				}

				local highlights = {
					FzfLuaNormal = { bg = fzf_colors.bg, fg = fzf_colors.fg },
					FzfLuaBorder = { fg = "#a4a7a4" },
					FzfLuaCursorLine = { bg = fzf_colors.cursor_line_bg, fg = fzf_colors.purple },
					FzfLuaTitle = { fg = fzf_colors.blue, bold = true },
					FzfLuaPrompt = { fg = fzf_colors.purple, bold = true },
					FzfLuaPointer = { fg = fzf_colors.purple, bold = true }, -- Pointer color set to purple
					FzfLuaMarker = { fg = fzf_colors.green },
					FzfLuaSpinner = { fg = fzf_colors.purple, bold = true },
					FzfLuaHeader = { fg = fzf_colors.comment },
					FzfLuaPreviewTitle = { fg = fzf_colors.purple, bold = true },
				}

				for group, opts in pairs(highlights) do
					vim.api.nvim_set_hl(0, group, opts)
					vim.cmd([[highlight FzfLuaPointer guifg=#828a9e]]) -- Pink color example
				end

				return {
					normal = "FzfLuaNormal",
					border = "FzfLuaBorder",
					cursor = "FzfLuaPointer", -- This controls the pointer color
					cursorline = "FzfLuaCursorLine",
					title = "FzfLuaTitle",
					prompt = "FzfLuaPrompt",
					pointer = "FzfLuaPointer", -- Pointer color reference
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
			heading = colors.yellow,
			button = colors.purple,
			shortcut = colors.blue,
		},
		incline = {
			normal = { bg = colors.background_light, fg = colors.foreground },
			border = { bg = colors.background, fg = colors.background },
			normal_nc = { bg = colors.background_light, fg = colors.comment },
			focused = { one = colors.background_light, two = colors.background_light },
			file_name = { guifg = colors.foreground },
			modified = { guifg = colors.orange },
		},
		bufferline = {
			fill = {
				fg = colors.background,
				bg = colors.background,
			},
			background = {
				fg = colors.comment,
				bg = colors.background,
			},
			tab = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			tab_selected = {
				fg = colors.foreground,
				bg = colors.background,
				bold = true,
			},
			tab_close = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			close_button = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			close_button_visible = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			close_button_selected = {
				fg = colors.red,
				bg = colors.background,
			},
			buffer_visible = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			buffer_selected = {
				fg = colors.foreground,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			numbers = {
				fg = colors.green,
				bg = colors.background_dark,
			},
			numbers_visible = {
				fg = colors.green,
				bg = colors.background_dark,
			},
			numbers_selected = {
				fg = colors.green,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			diagnostic = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			diagnostic_visible = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			diagnostic_selected = {
				fg = colors.foreground,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			hint = {
				fg = colors.purple,
				bg = colors.background_dark,
			},
			hint_visible = {
				fg = colors.purple,
				bg = colors.background_dark,
			},
			hint_selected = {
				fg = colors.purple,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			hint_diagnostic = {
				fg = colors.purple,
				bg = colors.background_dark,
			},
			hint_diagnostic_visible = {
				fg = colors.purple,
				bg = colors.background_dark,
			},
			hint_diagnostic_selected = {
				fg = colors.purple,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			info = {
				fg = colors.blue,
				bg = colors.background_dark,
			},
			info_visible = {
				fg = colors.blue,
				bg = colors.background_dark,
			},
			info_selected = {
				fg = colors.blue,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			info_diagnostic = {
				fg = colors.blue,
				bg = colors.background_dark,
			},
			info_diagnostic_visible = {
				fg = colors.blue,
				bg = colors.background_dark,
			},
			info_diagnostic_selected = {
				fg = colors.blue,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			warning = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			warning_visible = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			warning_selected = {
				fg = colors.orange,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			warning_diagnostic = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			warning_diagnostic_visible = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			warning_diagnostic_selected = {
				fg = colors.orange,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			error = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			error_visible = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			error_selected = {
				fg = colors.red,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			error_diagnostic = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			error_diagnostic_visible = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			error_diagnostic_selected = {
				fg = colors.red,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			modified = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			modified_visible = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			modified_selected = {
				fg = colors.orange,
				bg = colors.background,
			},
			duplicate = {
				fg = colors.comment,
				bg = colors.background_dark,
				italic = true,
			},
			duplicate_visible = {
				fg = colors.comment,
				bg = colors.background_dark,
				italic = true,
			},
			duplicate_selected = {
				fg = colors.foreground,
				bg = colors.background,
				italic = false,
			},
			separator = {
				fg = colors.background_light,
				bg = colors.background,
			},
			separator_visible = {
				fg = colors.background_light,
				bg = colors.background_dark,
			},
			separator_selected = {
				fg = colors.background_light,
				bg = colors.background,
			},
			indicator_selected = {
				fg = colors.purple,
				bg = colors.background,
			},
			pick_selected = {
				fg = colors.pink,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			pick_visible = {
				fg = colors.pink,
				bg = colors.background_dark,
				bold = true,
				italic = false,
			},
			pick = {
				fg = colors.pink,
				bg = colors.background_dark,
				bold = true,
				italic = false,
			},
		},
	}
end

local kanagawa = function()
	local colors = require("kanagawa.colors").setup({ theme = "dragon" })
	local palette = colors.palette

	return {
		bg = colors.bg or palette.bg_dark or "#0A0E14",
		bg_sec = colors.bg_dark or palette.bg_darker or "#090e13",
		bg_notify = colors.bg or palette.bg_dark or "#0A0E14",
		text = colors.fujiWhite or palette.fujiWhite or "#DCD7BA",
		text_sec = colors.fujiGray or palette.fujiGray or "#727169",
		inlay_hint_bg = colors.bg_dark or palette.bg_darker or "#090e13",
		inlay_hint_fg = "#818890",

		fzf = {
			setup_colors = function()
				local fzf_colors = {
					bg = colors.bg or palette.bg_dark or "#0A0E14",
					fg = colors.fujiWhite or palette.fujiWhite or "#DCD7BA",
					border = colors.bg_highlight or palette.bg_highlight or "#1F1F28",
					cursor_line_bg = colors.bg_dark or palette.bg_darker or "#090e13",
					blue = colors.crystalBlue or palette.crystalBlue or "#7E9CD8",
					light_blue = colors.waveAqua2 or palette.waveAqua2 or "#7FB4CA",
					purple = colors.lotusPurple2 or palette.lotusPurple2 or "#957FB8",
					red = colors.peachRed or palette.peachRed or "#E46876",
					green = colors.springGreen or palette.springGreen or "#98BB6C",
					orange = colors.autumnYellow or palette.autumnYellow or "#FFA066",
					comment = colors.fujiGray or palette.fujiGray or "#727169",
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
					vim.cmd([[highlight FzfLuaPointer guifg=#828a9e]])
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
			heading = colors.carpYellow or palette.carpYellow or "#E6C384",
			button = colors.lotusPurple2 or palette.lotusPurple2 or "#957FB8",
			shortcut = colors.crystalBlue or palette.crystalBlue or "#7E9CD8",
		},

		incline = {
			normal = {
				bg = colors.bg_highlight or palette.bg_highlight or "#1F1F28",
				fg = colors.fujiWhite or palette.fujiWhite or "#DCD7BA",
			},
			border = {
				bg = colors.bg or palette.bg_dark or "#0A0E14",
				fg = colors.bg or palette.bg_dark or "#0A0E14",
			},
			normal_nc = {
				bg = colors.bg_highlight or palette.bg_highlight or "#1F1F28",
				fg = colors.fujiGray or palette.fujiGray or "#727169",
			},
			focused = {
				one = colors.bg_highlight or palette.bg_highlight or "#1F1F28",
				two = colors.bg_highlight or palette.bg_highlight or "#1F1F28",
			},
			file_name = { guifg = colors.fujiWhite or palette.fujiWhite or "#DCD7BA" },
			modified = { guifg = colors.autumnYellow or palette.autumnYellow or "#FFA066" },
		},

		bufferline = {

			fill = {
				fg = colors.background,
				bg = colors.background,
			},
			background = {
				fg = colors.comment,
				bg = colors.background,
			},
			tab = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			tab_selected = {
				fg = colors.foreground,
				bg = colors.background,
				bold = true,
			},
			tab_close = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			close_button = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			close_button_visible = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			close_button_selected = {
				fg = colors.red,
				bg = colors.background,
			},
			buffer_visible = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			buffer_selected = {
				fg = colors.foreground,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			numbers = {
				fg = colors.green,
				bg = colors.background_dark,
			},
			numbers_visible = {
				fg = colors.green,
				bg = colors.background_dark,
			},
			numbers_selected = {
				fg = colors.green,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			diagnostic = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			diagnostic_visible = {
				fg = colors.comment,
				bg = colors.background_dark,
			},
			diagnostic_selected = {
				fg = colors.foreground,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			hint = {
				fg = colors.purple,
				bg = colors.background_dark,
			},
			hint_visible = {
				fg = colors.purple,
				bg = colors.background_dark,
			},
			hint_selected = {
				fg = colors.purple,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			hint_diagnostic = {
				fg = colors.purple,
				bg = colors.background_dark,
			},
			hint_diagnostic_visible = {
				fg = colors.purple,
				bg = colors.background_dark,
			},
			hint_diagnostic_selected = {
				fg = colors.purple,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			info = {
				fg = colors.blue,
				bg = colors.background_dark,
			},
			info_visible = {
				fg = colors.blue,
				bg = colors.background_dark,
			},
			info_selected = {
				fg = colors.blue,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			info_diagnostic = {
				fg = colors.blue,
				bg = colors.background_dark,
			},
			info_diagnostic_visible = {
				fg = colors.blue,
				bg = colors.background_dark,
			},
			info_diagnostic_selected = {
				fg = colors.blue,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			warning = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			warning_visible = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			warning_selected = {
				fg = colors.orange,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			warning_diagnostic = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			warning_diagnostic_visible = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			warning_diagnostic_selected = {
				fg = colors.orange,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			error = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			error_visible = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			error_selected = {
				fg = colors.red,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			error_diagnostic = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			error_diagnostic_visible = {
				fg = colors.red,
				bg = colors.background_dark,
			},
			error_diagnostic_selected = {
				fg = colors.red,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			modified = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			modified_visible = {
				fg = colors.orange,
				bg = colors.background_dark,
			},
			modified_selected = {
				fg = colors.orange,
				bg = colors.background,
			},
			duplicate = {
				fg = colors.comment,
				bg = colors.background_dark,
				italic = true,
			},
			duplicate_visible = {
				fg = colors.comment,
				bg = colors.background_dark,
				italic = true,
			},
			duplicate_selected = {
				fg = colors.foreground,
				bg = colors.background,
				italic = false,
			},
			separator = {
				fg = colors.background_light,
				bg = colors.background,
			},
			separator_visible = {
				fg = colors.background_light,
				bg = colors.background_dark,
			},
			separator_selected = {
				fg = colors.background_light,
				bg = colors.background,
			},
			indicator_selected = {
				fg = colors.purple,
				bg = colors.background,
			},
			pick_selected = {
				fg = colors.pink,
				bg = colors.background,
				bold = true,
				italic = false,
			},
			pick_visible = {
				fg = colors.pink,
				bg = colors.background_dark,
				bold = true,
				italic = false,
			},
			pick = {
				fg = colors.pink,
				bg = colors.background_dark,
				bold = true,
				italic = false,
			},
		},
	}
end

-- M.kanagawa = kanagawa()
-- M.rose_pine = rose_pine()
-- M.rose_pine_dark = rose_pine_dark()
-- M.kanagawa_dark = kanagawa_dark()
-- M.catppuccin_dark = catppuccin_dark()
-- M.kanagawa_paper = kanagawa_paper()
M.kanso = kanso()

M.current_theme = kanagawa()

return M
