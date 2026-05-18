local M = {}

-- Rose Pine palette (main variant)
local rose_pine = function()
	local ok, palette = pcall(require, "rose-pine.palette")
	if not ok then
		-- Hardcoded fallback so theme.lua works even before plugin loads
		palette = {
			base = "#191724",
			surface = "#1f1d2e",
			overlay = "#26233a",
			muted = "#6e6a86",
			subtle = "#908caa",
			text = "#e0def4",
			love = "#eb6f92",
			gold = "#f6c177",
			rose = "#ebbcba",
			pine = "#31748f",
			foam = "#9ccfd8",
			iris = "#c4a7e7",
			highlight_low = "#21202e",
			highlight_med = "#403d52",
			highlight_high = "#524f67",
		}
	end

	local p = palette

	return {
		bg = p.base,
		bg_sec = p.surface,
		bg_notify = p.overlay,
		text = p.text,
		text_sec = p.muted,
		inlay_hint_bg = p.surface,
		inlay_hint_fg = p.subtle,

		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.base, fg = p.text },
					FzfLuaBorder = { fg = p.highlight_high },
					FzfLuaCursorLine = { bg = p.overlay, fg = p.iris },
					FzfLuaTitle = { fg = p.rose, bold = true },
					FzfLuaPrompt = { fg = p.iris, bold = true },
					FzfLuaPointer = { fg = p.iris, bold = true },
					FzfLuaMarker = { fg = p.foam },
					FzfLuaSpinner = { fg = p.iris, bold = true },
					FzfLuaHeader = { fg = p.muted },
					FzfLuaPreviewTitle = { fg = p.iris, bold = true },
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
			heading = p.gold,
			button = p.iris,
			shortcut = p.rose,
		},

		incline = {
			normal = { bg = p.overlay, fg = p.text },
			border = { bg = p.base, fg = p.base },
			normal_nc = { bg = p.surface, fg = p.muted },
			focused = { one = p.overlay, two = p.overlay },
			file_name = { guifg = p.text },
			modified = { guifg = p.gold },
		},

		bufferline = {
			fill = { fg = p.base, bg = p.base },
			background = { fg = p.muted, bg = p.base },
			tab = { fg = p.muted, bg = p.surface },
			tab_selected = { fg = p.text, bg = p.base, bold = true },
			tab_close = { fg = p.muted, bg = p.surface },
			close_button = { fg = p.love, bg = p.surface },
			close_button_visible = { fg = p.love, bg = p.surface },
			close_button_selected = { fg = p.love, bg = p.base },
			buffer_visible = { fg = p.muted, bg = p.surface },
			buffer_selected = { fg = p.text, bg = p.base, bold = true, italic = false },
			numbers = { fg = p.foam, bg = p.surface },
			numbers_visible = { fg = p.foam, bg = p.surface },
			numbers_selected = { fg = p.foam, bg = p.base, bold = true, italic = false },
			diagnostic = { fg = p.muted, bg = p.surface },
			diagnostic_visible = { fg = p.muted, bg = p.surface },
			diagnostic_selected = { fg = p.text, bg = p.base, bold = true, italic = false },
			hint = { fg = p.iris, bg = p.surface },
			hint_visible = { fg = p.iris, bg = p.surface },
			hint_selected = { fg = p.iris, bg = p.base, bold = true, italic = false },
			hint_diagnostic = { fg = p.iris, bg = p.surface },
			hint_diagnostic_visible = { fg = p.iris, bg = p.surface },
			hint_diagnostic_selected = { fg = p.iris, bg = p.base, bold = true, italic = false },
			info = { fg = p.foam, bg = p.surface },
			info_visible = { fg = p.foam, bg = p.surface },
			info_selected = { fg = p.foam, bg = p.base, bold = true, italic = false },
			info_diagnostic = { fg = p.foam, bg = p.surface },
			info_diagnostic_visible = { fg = p.foam, bg = p.surface },
			info_diagnostic_selected = { fg = p.foam, bg = p.base, bold = true, italic = false },
			warning = { fg = p.gold, bg = p.surface },
			warning_visible = { fg = p.gold, bg = p.surface },
			warning_selected = { fg = p.gold, bg = p.base, bold = true, italic = false },
			warning_diagnostic = { fg = p.gold, bg = p.surface },
			warning_diagnostic_visible = { fg = p.gold, bg = p.surface },
			warning_diagnostic_selected = { fg = p.gold, bg = p.base, bold = true, italic = false },
			error = { fg = p.love, bg = p.surface },
			error_visible = { fg = p.love, bg = p.surface },
			error_selected = { fg = p.love, bg = p.base, bold = true, italic = false },
			error_diagnostic = { fg = p.love, bg = p.surface },
			error_diagnostic_visible = { fg = p.love, bg = p.surface },
			error_diagnostic_selected = { fg = p.love, bg = p.base, bold = true, italic = false },
			modified = { fg = p.gold, bg = p.surface },
			modified_visible = { fg = p.gold, bg = p.surface },
			modified_selected = { fg = p.gold, bg = p.base },
			duplicate = { fg = p.muted, bg = p.surface, italic = true },
			duplicate_visible = { fg = p.muted, bg = p.surface, italic = true },
			duplicate_selected = { fg = p.text, bg = p.base, italic = false },
			separator = { fg = p.highlight_med, bg = p.base },
			separator_visible = { fg = p.highlight_med, bg = p.surface },
			separator_selected = { fg = p.highlight_med, bg = p.base },
			indicator_selected = { fg = p.iris, bg = p.base },
			pick_selected = { fg = p.rose, bg = p.base, bold = true, italic = false },
			pick_visible = { fg = p.rose, bg = p.surface, bold = true, italic = false },
			pick = { fg = p.rose, bg = p.surface, bold = true, italic = false },
		},
	}
end

-- Kanagawa Wave palette (matched to VSCode kanagawa-wave theme)
local kanagawa = function()
	local p = {
		bg = "#1F1F28",
		bg_dark = "#16161D",
		bg_gutter = "#2A2A37",
		bg_line = "#363646",
		bg_tab_inactive = "#1A1A22",
		bg_selection = "#223249",
		fg = "#DCD7BA",
		fg_dim = "#C8C093",
		comment = "#727169",
		blue = "#7E9CD8",
		cyan = "#7FB4CA",
		teal = "#7AA89F",
		green = "#98BB6C",
		green_dark = "#76946A",
		yellow = "#E6C384",
		orange = "#FFA066",
		red = "#E82424",
		red_dark = "#C34043",
		pink = "#D27E99",
		magenta = "#957FB8",
		magenta_dim = "#938AA9",
		amber = "#DCA561",
		warn = "#FF9E3B",
		separator = "#54546D",
	}

	return {
		bg = p.bg,
		bg_sec = p.bg_gutter,
		bg_notify = p.bg_gutter,
		text = p.fg,
		text_sec = p.comment,
		inlay_hint_bg = p.bg_gutter,
		inlay_hint_fg = p.comment,

		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.bg, fg = p.fg },
					FzfLuaBorder = { fg = p.separator },
					FzfLuaCursorLine = { bg = p.bg_line, fg = p.magenta },
					FzfLuaTitle = { fg = p.blue, bold = true },
					FzfLuaPrompt = { fg = p.magenta, bold = true },
					FzfLuaPointer = { fg = p.magenta, bold = true },
					FzfLuaMarker = { fg = p.green },
					FzfLuaSpinner = { fg = p.magenta, bold = true },
					FzfLuaHeader = { fg = p.comment },
					FzfLuaPreviewTitle = { fg = p.magenta, bold = true },
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
			heading = p.yellow,
			button = p.magenta,
			shortcut = p.blue,
		},

		incline = {
			normal = { bg = p.bg_gutter, fg = p.fg },
			border = { bg = p.bg, fg = p.bg },
			normal_nc = { bg = p.bg_gutter, fg = p.comment },
			focused = { one = p.bg_gutter, two = p.bg_gutter },
			file_name = { guifg = p.fg },
			modified = { guifg = p.amber },
		},

		bufferline = {
			fill = { fg = p.bg_tab_inactive, bg = p.bg_tab_inactive },
			background = { fg = p.comment, bg = p.bg_tab_inactive },
			tab = { fg = p.comment, bg = p.bg_tab_inactive },
			tab_selected = { fg = p.blue, bg = p.bg_gutter, bold = true },
			tab_close = { fg = p.comment, bg = p.bg_tab_inactive },
			close_button = { fg = p.red_dark, bg = p.bg_tab_inactive },
			close_button_visible = { fg = p.red_dark, bg = p.bg_tab_inactive },
			close_button_selected = { fg = p.red_dark, bg = p.bg_gutter },
			buffer_visible = { fg = p.comment, bg = p.bg_tab_inactive },
			buffer_selected = { fg = p.blue, bg = p.bg_gutter, bold = true, italic = false },
			numbers = { fg = p.teal, bg = p.bg_tab_inactive },
			numbers_visible = { fg = p.teal, bg = p.bg_tab_inactive },
			numbers_selected = { fg = p.teal, bg = p.bg_gutter, bold = true, italic = false },
			diagnostic = { fg = p.comment, bg = p.bg_tab_inactive },
			diagnostic_visible = { fg = p.comment, bg = p.bg_tab_inactive },
			diagnostic_selected = { fg = p.fg, bg = p.bg_gutter, bold = true, italic = false },
			hint = { fg = p.magenta, bg = p.bg_tab_inactive },
			hint_visible = { fg = p.magenta, bg = p.bg_tab_inactive },
			hint_selected = { fg = p.magenta, bg = p.bg_gutter, bold = true, italic = false },
			hint_diagnostic = { fg = p.magenta, bg = p.bg_tab_inactive },
			hint_diagnostic_visible = { fg = p.magenta, bg = p.bg_tab_inactive },
			hint_diagnostic_selected = { fg = p.magenta, bg = p.bg_gutter, bold = true, italic = false },
			info = { fg = p.cyan, bg = p.bg_tab_inactive },
			info_visible = { fg = p.cyan, bg = p.bg_tab_inactive },
			info_selected = { fg = p.cyan, bg = p.bg_gutter, bold = true, italic = false },
			info_diagnostic = { fg = p.cyan, bg = p.bg_tab_inactive },
			info_diagnostic_visible = { fg = p.cyan, bg = p.bg_tab_inactive },
			info_diagnostic_selected = { fg = p.cyan, bg = p.bg_gutter, bold = true, italic = false },
			warning = { fg = p.warn, bg = p.bg_tab_inactive },
			warning_visible = { fg = p.warn, bg = p.bg_tab_inactive },
			warning_selected = { fg = p.warn, bg = p.bg_gutter, bold = true, italic = false },
			warning_diagnostic = { fg = p.warn, bg = p.bg_tab_inactive },
			warning_diagnostic_visible = { fg = p.warn, bg = p.bg_tab_inactive },
			warning_diagnostic_selected = { fg = p.warn, bg = p.bg_gutter, bold = true, italic = false },
			error = { fg = p.red, bg = p.bg_tab_inactive },
			error_visible = { fg = p.red, bg = p.bg_tab_inactive },
			error_selected = { fg = p.red, bg = p.bg_gutter, bold = true, italic = false },
			error_diagnostic = { fg = p.red, bg = p.bg_tab_inactive },
			error_diagnostic_visible = { fg = p.red, bg = p.bg_tab_inactive },
			error_diagnostic_selected = { fg = p.red, bg = p.bg_gutter, bold = true, italic = false },
			modified = { fg = p.amber, bg = p.bg_tab_inactive },
			modified_visible = { fg = p.amber, bg = p.bg_tab_inactive },
			modified_selected = { fg = p.amber, bg = p.bg_gutter },
			duplicate = { fg = p.comment, bg = p.bg_tab_inactive, italic = true },
			duplicate_visible = { fg = p.comment, bg = p.bg_tab_inactive, italic = true },
			duplicate_selected = { fg = p.fg, bg = p.bg_gutter, italic = false },
			separator = { fg = p.bg_dark, bg = p.bg_tab_inactive },
			separator_visible = { fg = p.bg_dark, bg = p.bg_tab_inactive },
			separator_selected = { fg = p.bg_dark, bg = p.bg_gutter },
			indicator_selected = { fg = p.blue, bg = p.bg_gutter },
			pick_selected = { fg = p.orange, bg = p.bg_gutter, bold = true, italic = false },
			pick_visible = { fg = p.orange, bg = p.bg_tab_inactive, bold = true, italic = false },
			pick = { fg = p.orange, bg = p.bg_tab_inactive, bold = true, italic = false },
		},
	}
end

-- Jellybeans palette
local jellybeans = function()
	-- Jellybeans color values (from the vibrant variant)
	local p = {
		bg = "#151515",
		bg_sec = "#1c1c1c",
		bg_float = "#1c1c1c",
		fg = "#e8e8d3",
		grey_one = "#1c1c1c",
		grey_two = "#2a2a2a",
		grey_three = "#3a3a3a",
		grey_four = "#4a4a4a",
		comment = "#888888",
		red = "#cf6a4c",
		green = "#99ad6a",
		yellow = "#fad07a",
		blue = "#8fbfdc",
		purple = "#c6b6ee",
		orange = "#ffb964",
		teal = "#8fbfdc",
		pink = "#f0a0c0",
		error = "#902020",
		warn = "#fad07a",
		hint = "#c6b6ee",
		info = "#8fbfdc",
		diff_add = "#99ad6a",
		diff_change = "#fad07a",
		diff_delete = "#cf6a4c",
	}

	return {
		bg = p.bg,
		bg_sec = p.bg_sec,
		bg_notify = p.bg_float,
		text = p.fg,
		text_sec = p.comment,
		inlay_hint_bg = p.grey_one,
		inlay_hint_fg = p.comment,

		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.bg, fg = p.fg },
					FzfLuaBorder = { fg = p.grey_three },
					FzfLuaCursorLine = { bg = p.grey_one, fg = p.purple },
					FzfLuaTitle = { fg = p.blue, bold = true },
					FzfLuaPrompt = { fg = p.purple, bold = true },
					FzfLuaPointer = { fg = p.purple, bold = true },
					FzfLuaMarker = { fg = p.green },
					FzfLuaSpinner = { fg = p.purple, bold = true },
					FzfLuaHeader = { fg = p.comment },
					FzfLuaPreviewTitle = { fg = p.purple, bold = true },
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
			heading = p.yellow,
			button = p.purple,
			shortcut = p.blue,
		},

		incline = {
			normal = { bg = p.grey_two, fg = p.fg },
			border = { bg = p.bg, fg = p.bg },
			normal_nc = { bg = p.grey_one, fg = p.comment },
			focused = { one = p.grey_two, two = p.grey_two },
			file_name = { guifg = p.fg },
			modified = { guifg = p.yellow },
		},

		bufferline = {
			fill = { fg = p.bg, bg = p.bg },
			background = { fg = p.comment, bg = p.bg },
			tab = { fg = p.comment, bg = p.grey_one },
			tab_selected = { fg = p.fg, bg = p.bg, bold = true },
			tab_close = { fg = p.comment, bg = p.grey_one },
			close_button = { fg = p.red, bg = p.grey_one },
			close_button_visible = { fg = p.red, bg = p.grey_one },
			close_button_selected = { fg = p.red, bg = p.bg },
			buffer_visible = { fg = p.comment, bg = p.grey_one },
			buffer_selected = { fg = p.fg, bg = p.bg, bold = true, italic = false },
			numbers = { fg = p.teal, bg = p.grey_one },
			numbers_visible = { fg = p.teal, bg = p.grey_one },
			numbers_selected = { fg = p.teal, bg = p.bg, bold = true, italic = false },
			diagnostic = { fg = p.comment, bg = p.grey_one },
			diagnostic_visible = { fg = p.comment, bg = p.grey_one },
			diagnostic_selected = { fg = p.fg, bg = p.bg, bold = true, italic = false },
			hint = { fg = p.hint, bg = p.grey_one },
			hint_visible = { fg = p.hint, bg = p.grey_one },
			hint_selected = { fg = p.hint, bg = p.bg, bold = true, italic = false },
			hint_diagnostic = { fg = p.hint, bg = p.grey_one },
			hint_diagnostic_visible = { fg = p.hint, bg = p.grey_one },
			hint_diagnostic_selected = { fg = p.hint, bg = p.bg, bold = true, italic = false },
			info = { fg = p.info, bg = p.grey_one },
			info_visible = { fg = p.info, bg = p.grey_one },
			info_selected = { fg = p.info, bg = p.bg, bold = true, italic = false },
			info_diagnostic = { fg = p.info, bg = p.grey_one },
			info_diagnostic_visible = { fg = p.info, bg = p.grey_one },
			info_diagnostic_selected = { fg = p.info, bg = p.bg, bold = true, italic = false },
			warning = { fg = p.warn, bg = p.grey_one },
			warning_visible = { fg = p.warn, bg = p.grey_one },
			warning_selected = { fg = p.warn, bg = p.bg, bold = true, italic = false },
			warning_diagnostic = { fg = p.warn, bg = p.grey_one },
			warning_diagnostic_visible = { fg = p.warn, bg = p.grey_one },
			warning_diagnostic_selected = { fg = p.warn, bg = p.bg, bold = true, italic = false },
			error = { fg = p.red, bg = p.grey_one },
			error_visible = { fg = p.red, bg = p.grey_one },
			error_selected = { fg = p.red, bg = p.bg, bold = true, italic = false },
			error_diagnostic = { fg = p.red, bg = p.grey_one },
			error_diagnostic_visible = { fg = p.red, bg = p.grey_one },
			error_diagnostic_selected = { fg = p.red, bg = p.bg, bold = true, italic = false },
			modified = { fg = p.yellow, bg = p.grey_one },
			modified_visible = { fg = p.yellow, bg = p.grey_one },
			modified_selected = { fg = p.yellow, bg = p.bg },
			duplicate = { fg = p.comment, bg = p.grey_one, italic = true },
			duplicate_visible = { fg = p.comment, bg = p.grey_one, italic = true },
			duplicate_selected = { fg = p.fg, bg = p.bg, italic = false },
			separator = { fg = p.grey_two, bg = p.bg },
			separator_visible = { fg = p.grey_two, bg = p.grey_one },
			separator_selected = { fg = p.grey_two, bg = p.bg },
			indicator_selected = { fg = p.purple, bg = p.bg },
			pick_selected = { fg = p.orange, bg = p.bg, bold = true, italic = false },
			pick_visible = { fg = p.orange, bg = p.grey_one, bold = true, italic = false },
			pick = { fg = p.orange, bg = p.grey_one, bold = true, italic = false },
		},
	}
end

-- Kanso palette (zen variant)
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
			normal = { bg = theme.ui.bg_p2, fg = theme.ui.fg },
			border = { bg = theme.ui.bg, fg = theme.ui.bg },
			normal_nc = { bg = theme.ui.bg_p2, fg = theme.ui.nontext },
			focused = { one = theme.ui.bg_p2, two = theme.ui.bg_p2 },
			file_name = { guifg = theme.ui.fg },
			modified = { guifg = theme.syn.constant },
		},

		bufferline = {
			fill = { fg = theme.ui.bg, bg = theme.ui.bg },
			background = { fg = theme.syn.comment, bg = theme.ui.bg },
			tab = { fg = theme.syn.comment, bg = theme.ui.bg_gutter },
			tab_selected = { fg = theme.ui.fg, bg = theme.ui.bg, bold = true },
			tab_close = { fg = theme.syn.comment, bg = theme.ui.bg_gutter },
			close_button = { fg = theme.diag.error, bg = theme.ui.bg_gutter },
			close_button_visible = { fg = theme.diag.error, bg = theme.ui.bg_gutter },
			close_button_selected = { fg = theme.diag.error, bg = theme.ui.bg },
			buffer_visible = { fg = theme.syn.comment, bg = theme.ui.bg_gutter },
			buffer_selected = { fg = theme.ui.fg, bg = theme.ui.bg, bold = true, italic = false },
			numbers = { fg = theme.syn.string, bg = theme.ui.bg_gutter },
			numbers_visible = { fg = theme.syn.string, bg = theme.ui.bg_gutter },
			numbers_selected = { fg = theme.syn.string, bg = theme.ui.bg, bold = true, italic = false },
			diagnostic = { fg = theme.syn.comment, bg = theme.ui.bg_gutter },
			diagnostic_visible = { fg = theme.syn.comment, bg = theme.ui.bg_gutter },
			diagnostic_selected = { fg = theme.ui.fg, bg = theme.ui.bg, bold = true, italic = false },
			hint = { fg = theme.syn.keyword, bg = theme.ui.bg_gutter },
			hint_visible = { fg = theme.syn.keyword, bg = theme.ui.bg_gutter },
			hint_selected = { fg = theme.syn.keyword, bg = theme.ui.bg, bold = true, italic = false },
			hint_diagnostic = { fg = theme.syn.keyword, bg = theme.ui.bg_gutter },
			hint_diagnostic_visible = { fg = theme.syn.keyword, bg = theme.ui.bg_gutter },
			hint_diagnostic_selected = { fg = theme.syn.keyword, bg = theme.ui.bg, bold = true, italic = false },
			info = { fg = theme.syn.fun, bg = theme.ui.bg_gutter },
			info_visible = { fg = theme.syn.fun, bg = theme.ui.bg_gutter },
			info_selected = { fg = theme.syn.fun, bg = theme.ui.bg, bold = true, italic = false },
			info_diagnostic = { fg = theme.syn.fun, bg = theme.ui.bg_gutter },
			info_diagnostic_visible = { fg = theme.syn.fun, bg = theme.ui.bg_gutter },
			info_diagnostic_selected = { fg = theme.syn.fun, bg = theme.ui.bg, bold = true, italic = false },
			warning = { fg = theme.diag.warning, bg = theme.ui.bg_gutter },
			warning_visible = { fg = theme.diag.warning, bg = theme.ui.bg_gutter },
			warning_selected = { fg = theme.diag.warning, bg = theme.ui.bg, bold = true, italic = false },
			warning_diagnostic = { fg = theme.diag.warning, bg = theme.ui.bg_gutter },
			warning_diagnostic_visible = { fg = theme.diag.warning, bg = theme.ui.bg_gutter },
			warning_diagnostic_selected = { fg = theme.diag.warning, bg = theme.ui.bg, bold = true, italic = false },
			error = { fg = theme.diag.error, bg = theme.ui.bg_gutter },
			error_visible = { fg = theme.diag.error, bg = theme.ui.bg_gutter },
			error_selected = { fg = theme.diag.error, bg = theme.ui.bg, bold = true, italic = false },
			error_diagnostic = { fg = theme.diag.error, bg = theme.ui.bg_gutter },
			error_diagnostic_visible = { fg = theme.diag.error, bg = theme.ui.bg_gutter },
			error_diagnostic_selected = { fg = theme.diag.error, bg = theme.ui.bg, bold = true, italic = false },
			modified = { fg = theme.diag.warning, bg = theme.ui.bg_gutter },
			modified_visible = { fg = theme.diag.warning, bg = theme.ui.bg_gutter },
			modified_selected = { fg = theme.diag.warning, bg = theme.ui.bg },
			duplicate = { fg = theme.syn.comment, bg = theme.ui.bg_gutter, italic = true },
			duplicate_visible = { fg = theme.syn.comment, bg = theme.ui.bg_gutter, italic = true },
			duplicate_selected = { fg = theme.ui.fg, bg = theme.ui.bg, italic = false },
			separator = { fg = theme.ui.bg_p2, bg = theme.ui.bg },
			separator_visible = { fg = theme.ui.bg_p2, bg = theme.ui.bg_gutter },
			separator_selected = { fg = theme.ui.bg_p2, bg = theme.ui.bg },
			indicator_selected = { fg = theme.syn.keyword, bg = theme.ui.bg },
			pick_selected = { fg = theme.syn.special1, bg = theme.ui.bg, bold = true, italic = false },
			pick_visible = { fg = theme.syn.special1, bg = theme.ui.bg_gutter, bold = true, italic = false },
			pick = { fg = theme.syn.special1, bg = theme.ui.bg_gutter, bold = true, italic = false },
		},
	}
end

-- Active theme: change this to switch themes
-- Options: rose_pine(), kanagawa(), jellybeans(), kanso()
M.current_theme = kanso()

-- Keep all available for reference
M.rose_pine = rose_pine
M.kanagawa = kanagawa
M.jellybeans = jellybeans
M.kanso = kanso

return M
