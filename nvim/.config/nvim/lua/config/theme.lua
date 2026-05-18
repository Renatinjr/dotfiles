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

-- Serenity palette (Wansmer/serenity.nvim)
local serenity = function()
	-- Try the plugin's palette first; fall back to hardcoded so theme.lua
	-- still works before the plugin loads (mirrors rose_pine's pattern).
	local ok, plugin_palette = pcall(require, "serenity.palette")
	local p
	if ok and type(plugin_palette) == "table" then
		p = plugin_palette
	else
		p = {
			bg = "#1A1E25",
			bg_sec = "#212730",
			bg_float = "#1F252E",
			bg_gutter = "#252B35",
			bg_line = "#2A313C",
			fg = "#BCC2CD",
			fg_dim = "#A1A8B4",
			comment = "#6C7A89",
			separator = "#3A4250",
			blue = "#7DA9C1",
			cyan = "#86C1B9",
			teal = "#88B0A4",
			green = "#9AB87A",
			green_dark = "#7E9B5F",
			yellow = "#D8B98A",
			orange = "#C99F73",
			red = "#C57B6B",
			red_dark = "#9E5F53",
			pink = "#C68FA4",
			purple = "#A990C8",
			magenta = "#B080B0",
			amber = "#C7A364",
			warn = "#D9A86C",
			error_red = "#C57B6B",
			hint = "#A990C8",
			info = "#7DA9C1",
		}
	end

	-- Normalize: ensure all keys we use below exist even if the plugin's
	-- palette has a slightly different shape.
	p.bg = p.bg or "#1A1E25"
	p.bg_sec = p.bg_sec or p.bg_alt or "#212730"
	p.bg_float = p.bg_float or p.bg_sec
	p.bg_gutter = p.bg_gutter or p.bg_sec
	p.bg_line = p.bg_line or p.bg_sec
	p.fg = p.fg or "#BCC2CD"
	p.fg_dim = p.fg_dim or p.fg
	p.comment = p.comment or "#6C7A89"
	p.separator = p.separator or p.bg_line
	p.blue = p.blue or "#7DA9C1"
	p.cyan = p.cyan or p.blue
	p.teal = p.teal or p.cyan
	p.green = p.green or "#9AB87A"
	p.green_dark = p.green_dark or p.green
	p.yellow = p.yellow or "#D8B98A"
	p.orange = p.orange or p.yellow
	p.red = p.error_red or p.red or "#C57B6B"
	p.red_dark = p.red_dark or p.red
	p.pink = p.pink or p.red
	p.purple = p.purple or "#A990C8"
	p.magenta = p.magenta or p.purple
	p.amber = p.amber or p.yellow
	p.warn = p.warn or p.amber
	p.hint = p.hint or p.purple
	p.info = p.info or p.blue

	return {
		bg = p.bg,
		bg_sec = p.bg_sec,
		bg_notify = p.bg_float,
		text = p.fg,
		text_sec = p.comment,
		inlay_hint_bg = p.bg_gutter,
		inlay_hint_fg = p.comment,

		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.bg, fg = p.fg },
					FzfLuaBorder = { fg = p.separator },
					FzfLuaCursorLine = { bg = p.bg_line, fg = p.purple },
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
			normal = { bg = p.bg_sec, fg = p.fg },
			border = { bg = p.bg, fg = p.bg },
			normal_nc = { bg = p.bg_sec, fg = p.comment },
			focused = { one = p.bg_sec, two = p.bg_sec },
			file_name = { guifg = p.fg },
			modified = { guifg = p.amber },
		},

		bufferline = {
			fill = { fg = p.bg, bg = p.bg },
			background = { fg = p.comment, bg = p.bg },
			tab = { fg = p.comment, bg = p.bg_sec },
			tab_selected = { fg = p.fg, bg = p.bg, bold = true },
			tab_close = { fg = p.comment, bg = p.bg_sec },
			close_button = { fg = p.red, bg = p.bg_sec },
			close_button_visible = { fg = p.red, bg = p.bg_sec },
			close_button_selected = { fg = p.red, bg = p.bg },
			buffer_visible = { fg = p.comment, bg = p.bg_sec },
			buffer_selected = { fg = p.fg, bg = p.bg, bold = true, italic = false },
			numbers = { fg = p.teal, bg = p.bg_sec },
			numbers_visible = { fg = p.teal, bg = p.bg_sec },
			numbers_selected = { fg = p.teal, bg = p.bg, bold = true, italic = false },
			diagnostic = { fg = p.comment, bg = p.bg_sec },
			diagnostic_visible = { fg = p.comment, bg = p.bg_sec },
			diagnostic_selected = { fg = p.fg, bg = p.bg, bold = true, italic = false },
			hint = { fg = p.hint, bg = p.bg_sec },
			hint_visible = { fg = p.hint, bg = p.bg_sec },
			hint_selected = { fg = p.hint, bg = p.bg, bold = true, italic = false },
			hint_diagnostic = { fg = p.hint, bg = p.bg_sec },
			hint_diagnostic_visible = { fg = p.hint, bg = p.bg_sec },
			hint_diagnostic_selected = { fg = p.hint, bg = p.bg, bold = true, italic = false },
			info = { fg = p.info, bg = p.bg_sec },
			info_visible = { fg = p.info, bg = p.bg_sec },
			info_selected = { fg = p.info, bg = p.bg, bold = true, italic = false },
			info_diagnostic = { fg = p.info, bg = p.bg_sec },
			info_diagnostic_visible = { fg = p.info, bg = p.bg_sec },
			info_diagnostic_selected = { fg = p.info, bg = p.bg, bold = true, italic = false },
			warning = { fg = p.warn, bg = p.bg_sec },
			warning_visible = { fg = p.warn, bg = p.bg_sec },
			warning_selected = { fg = p.warn, bg = p.bg, bold = true, italic = false },
			warning_diagnostic = { fg = p.warn, bg = p.bg_sec },
			warning_diagnostic_visible = { fg = p.warn, bg = p.bg_sec },
			warning_diagnostic_selected = { fg = p.warn, bg = p.bg, bold = true, italic = false },
			error = { fg = p.red, bg = p.bg_sec },
			error_visible = { fg = p.red, bg = p.bg_sec },
			error_selected = { fg = p.red, bg = p.bg, bold = true, italic = false },
			error_diagnostic = { fg = p.red, bg = p.bg_sec },
			error_diagnostic_visible = { fg = p.red, bg = p.bg_sec },
			error_diagnostic_selected = { fg = p.red, bg = p.bg, bold = true, italic = false },
			modified = { fg = p.amber, bg = p.bg_sec },
			modified_visible = { fg = p.amber, bg = p.bg_sec },
			modified_selected = { fg = p.amber, bg = p.bg },
			duplicate = { fg = p.comment, bg = p.bg_sec, italic = true },
			duplicate_visible = { fg = p.comment, bg = p.bg_sec, italic = true },
			duplicate_selected = { fg = p.fg, bg = p.bg, italic = false },
			separator = { fg = p.separator, bg = p.bg },
			separator_visible = { fg = p.separator, bg = p.bg_sec },
			separator_selected = { fg = p.separator, bg = p.bg },
			indicator_selected = { fg = p.purple, bg = p.bg },
			pick_selected = { fg = p.orange, bg = p.bg, bold = true, italic = false },
			pick_visible = { fg = p.orange, bg = p.bg_sec, bold = true, italic = false },
			pick = { fg = p.orange, bg = p.bg_sec, bold = true, italic = false },
		},
	}
end

-- Koda palette (oskarnurm/koda.nvim) — minimal dark, low-contrast.
-- Pulls the live palette from `koda.palette.dark`; mirrors the kanso() pattern
-- (read the plugin's source of truth, expose UI-shape consumed by FzfLua,
-- alpha, incline, bufferline). Koda's palette is FLAT (no theme.ui / syn /
-- diag tables like kanso), so the keys are read directly.
local koda = function()
	local ok, palette = pcall(require, "koda.palette.dark")
	if not ok or type(palette) ~= "table" then
		-- Fallback to the same hex values koda ships in palette/dark.lua so
		-- theme.lua still works before lazy clones the plugin.
		palette = {
			bg = "#101010",
			fg = "#b0b0b0",
			dim = "#474747",
			line = "#272727",
			keyword = "#777777",
			type = "#777777",
			operator = "#777777",
			comment = "#50585d",
			border = "#ffffff",
			emphasis = "#ffffff",
			func = "#ffffff",
			string = "#ffffff",
			char = "#ffffff",
			special = "#ffffff",
			const = "#d9ba73",
			highlight = "#458ee6",
			info = "#8ebeec",
			success = "#86cd82",
			warning = "#d9ba73",
			danger = "#ff7676",
			green = "#14ba19",
			orange = "#ff5733",
			red = "#701516",
			pink = "#f2a4db",
			cyan = "#5abfb5",
		}
	end

	local p = palette

	return {
		bg = p.bg,
		bg_sec = p.line,
		bg_notify = p.line,
		text = p.fg,
		text_sec = p.comment,
		inlay_hint_bg = p.line,
		inlay_hint_fg = p.dim,

		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.bg, fg = p.fg },
					FzfLuaBorder = { fg = p.dim },
					FzfLuaCursorLine = { bg = p.line, fg = p.highlight },
					FzfLuaTitle = { fg = p.info, bold = true },
					FzfLuaPrompt = { fg = p.highlight, bold = true },
					FzfLuaPointer = { fg = p.highlight, bold = true },
					FzfLuaMarker = { fg = p.success },
					FzfLuaSpinner = { fg = p.highlight, bold = true },
					FzfLuaHeader = { fg = p.comment },
					FzfLuaPreviewTitle = { fg = p.highlight, bold = true },
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
			heading = p.warning,
			button = p.highlight,
			shortcut = p.info,
		},

		incline = {
			normal = { bg = p.line, fg = p.fg },
			border = { bg = p.bg, fg = p.bg },
			normal_nc = { bg = p.line, fg = p.comment },
			focused = { one = p.line, two = p.line },
			file_name = { guifg = p.fg },
			modified = { guifg = p.warning },
		},

		bufferline = {
			fill = { fg = p.bg, bg = p.bg },
			background = { fg = p.comment, bg = p.bg },
			tab = { fg = p.comment, bg = p.line },
			tab_selected = { fg = p.emphasis, bg = p.bg, bold = true },
			tab_close = { fg = p.comment, bg = p.line },
			close_button = { fg = p.danger, bg = p.line },
			close_button_visible = { fg = p.danger, bg = p.line },
			close_button_selected = { fg = p.danger, bg = p.bg },
			buffer_visible = { fg = p.comment, bg = p.line },
			buffer_selected = { fg = p.emphasis, bg = p.bg, bold = true, italic = false },
			numbers = { fg = p.cyan, bg = p.line },
			numbers_visible = { fg = p.cyan, bg = p.line },
			numbers_selected = { fg = p.cyan, bg = p.bg, bold = true, italic = false },
			diagnostic = { fg = p.comment, bg = p.line },
			diagnostic_visible = { fg = p.comment, bg = p.line },
			diagnostic_selected = { fg = p.fg, bg = p.bg, bold = true, italic = false },
			hint = { fg = p.highlight, bg = p.line },
			hint_visible = { fg = p.highlight, bg = p.line },
			hint_selected = { fg = p.highlight, bg = p.bg, bold = true, italic = false },
			hint_diagnostic = { fg = p.highlight, bg = p.line },
			hint_diagnostic_visible = { fg = p.highlight, bg = p.line },
			hint_diagnostic_selected = { fg = p.highlight, bg = p.bg, bold = true, italic = false },
			info = { fg = p.info, bg = p.line },
			info_visible = { fg = p.info, bg = p.line },
			info_selected = { fg = p.info, bg = p.bg, bold = true, italic = false },
			info_diagnostic = { fg = p.info, bg = p.line },
			info_diagnostic_visible = { fg = p.info, bg = p.line },
			info_diagnostic_selected = { fg = p.info, bg = p.bg, bold = true, italic = false },
			warning = { fg = p.warning, bg = p.line },
			warning_visible = { fg = p.warning, bg = p.line },
			warning_selected = { fg = p.warning, bg = p.bg, bold = true, italic = false },
			warning_diagnostic = { fg = p.warning, bg = p.line },
			warning_diagnostic_visible = { fg = p.warning, bg = p.line },
			warning_diagnostic_selected = { fg = p.warning, bg = p.bg, bold = true, italic = false },
			error = { fg = p.danger, bg = p.line },
			error_visible = { fg = p.danger, bg = p.line },
			error_selected = { fg = p.danger, bg = p.bg, bold = true, italic = false },
			error_diagnostic = { fg = p.danger, bg = p.line },
			error_diagnostic_visible = { fg = p.danger, bg = p.line },
			error_diagnostic_selected = { fg = p.danger, bg = p.bg, bold = true, italic = false },
			modified = { fg = p.warning, bg = p.line },
			modified_visible = { fg = p.warning, bg = p.line },
			modified_selected = { fg = p.warning, bg = p.bg },
			duplicate = { fg = p.comment, bg = p.line, italic = true },
			duplicate_visible = { fg = p.comment, bg = p.line, italic = true },
			duplicate_selected = { fg = p.fg, bg = p.bg, italic = false },
			separator = { fg = p.dim, bg = p.bg },
			separator_visible = { fg = p.dim, bg = p.line },
			separator_selected = { fg = p.dim, bg = p.bg },
			indicator_selected = { fg = p.highlight, bg = p.bg },
			pick_selected = { fg = p.orange, bg = p.bg, bold = true, italic = false },
			pick_visible = { fg = p.orange, bg = p.line, bold = true, italic = false },
			pick = { fg = p.orange, bg = p.line, bold = true, italic = false },
		},
	}
end

-- Active theme: change this to switch themes
-- Options: rose_pine(), kanagawa(), jellybeans(), kanso(), serenity(), koda()
M.current_theme = koda()

-- Keep all available for reference
M.rose_pine = rose_pine
M.kanagawa = kanagawa
M.jellybeans = jellybeans
M.kanso = kanso
M.serenity = serenity
M.koda = koda

return M
