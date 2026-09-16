local M = {}

-- Build the full set of NvimTree highlight groups from a small semantic color
-- map, so each palette only has to name its accents once. nvim-tree applies the
-- `*FileHL`/`*FolderHL` groups (folder links to file by default) plus the legacy
-- status-icon groups; we set both so colors land regardless of which the
-- renderer reaches for.
local function make_nvim_tree(c)
	return {
		-- Window / chrome
		NvimTreeNormal = { fg = c.fg, bg = c.bg },
		NvimTreeNormalFloat = { fg = c.fg, bg = c.bg },
		NvimTreeNormalNC = { fg = c.fg, bg = c.bg },
		NvimTreeEndOfBuffer = { fg = c.bg, bg = c.bg },
		NvimTreeNormalFloatBorder = { fg = c.border, bg = c.bg },
		NvimTreeWinSeparator = { fg = c.border, bg = c.bg },
		NvimTreeCursorLine = { bg = c.sel_bg },
		NvimTreeLiveFilterPrefix = { fg = c.accent, bold = true },
		NvimTreeLiveFilterValue = { fg = c.fg },
		-- Files / folders
		NvimTreeRootFolder = { fg = c.accent, bold = true },
		NvimTreeFolderName = { fg = c.folder },
		NvimTreeOpenedFolderName = { fg = c.folder, bold = true, italic = true },
		NvimTreeEmptyFolderName = { fg = c.comment },
		NvimTreeFolderIcon = { fg = c.folder },
		NvimTreeIndentMarker = { fg = c.comment },
		NvimTreeSymlink = { fg = c.symlink },
		NvimTreeSpecialFile = { fg = c.special, bold = true },
		NvimTreeOpenedFile = { fg = c.fg, bold = true },
		NvimTreeOpenedHL = { fg = c.fg, bold = true },
		NvimTreeModifiedFile = { fg = c.modified },
		NvimTreeModifiedFileHL = { fg = c.modified },
		NvimTreeModifiedIcon = { fg = c.modified },
		NvimTreeWindowPicker = { fg = c.bg, bg = c.accent, bold = true },
		-- Git: new
		NvimTreeGitNew = { fg = c.git_new },
		NvimTreeGitNewIcon = { fg = c.git_new },
		NvimTreeGitFileNewHL = { fg = c.git_new },
		NvimTreeGitFolderNewHL = { fg = c.git_new },
		-- Git: dirty / unstaged
		NvimTreeGitDirty = { fg = c.git_dirty },
		NvimTreeGitDirtyIcon = { fg = c.git_dirty },
		NvimTreeGitFileDirtyHL = { fg = c.git_dirty },
		NvimTreeGitFolderDirtyHL = { fg = c.git_dirty },
		-- Git: staged
		NvimTreeGitStaged = { fg = c.git_staged },
		NvimTreeGitStagedIcon = { fg = c.git_staged },
		NvimTreeGitFileStagedHL = { fg = c.git_staged },
		NvimTreeGitFolderStagedHL = { fg = c.git_staged },
		-- Git: renamed
		NvimTreeGitRenamed = { fg = c.git_renamed },
		NvimTreeGitRenamedIcon = { fg = c.git_renamed },
		NvimTreeGitFileRenamedHL = { fg = c.git_renamed },
		NvimTreeGitFolderRenamedHL = { fg = c.git_renamed },
		-- Git: deleted
		NvimTreeGitDeleted = { fg = c.git_deleted },
		NvimTreeGitDeletedIcon = { fg = c.git_deleted },
		NvimTreeGitFileDeletedHL = { fg = c.git_deleted },
		NvimTreeGitFolderDeletedHL = { fg = c.git_deleted },
		-- Git: merge conflict
		NvimTreeGitMerge = { fg = c.git_merge },
		NvimTreeGitMergeIcon = { fg = c.git_merge },
		NvimTreeGitFileMergeHL = { fg = c.git_merge },
		NvimTreeGitFolderMergeHL = { fg = c.git_merge },
		-- Git: ignored
		NvimTreeGitIgnored = { fg = c.comment, italic = true },
		NvimTreeGitIgnoredIcon = { fg = c.comment, italic = true },
		NvimTreeGitFileIgnoredHL = { fg = c.comment, italic = true },
		NvimTreeGitFolderIgnoredHL = { fg = c.comment, italic = true },
	}
end

-- Rose Pine palette (main variant)
-- Rose Pine palette, transcribed from the plugin's lua/rose-pine/palette.lua.
--
-- Not required from the plugin: `rose-pine.palette` resolves to whichever
-- variant is CURRENTLY configured, but this runs from the ColorSchemePre hook,
-- i.e. before the incoming variant has loaded — so a live read would hand back
-- the outgoing one. Transcribing keeps the three variants addressable by name,
-- the same approach material() and evergarden() take below.
local ROSE_PINE_VARIANTS = {
	main = {
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
	},
	moon = {
		base = "#232136",
		surface = "#2a273f",
		overlay = "#393552",
		muted = "#6e6a86",
		subtle = "#908caa",
		text = "#e0def4",
		love = "#eb6f92",
		gold = "#f6c177",
		rose = "#ea9a97",
		pine = "#3e8fb0",
		foam = "#9ccfd8",
		iris = "#c4a7e7",
		highlight_low = "#2a283e",
		highlight_med = "#44415a",
		highlight_high = "#56526e",
	},
	dawn = {
		base = "#faf4ed",
		surface = "#fffaf3",
		overlay = "#f2e9e1",
		muted = "#9893a5",
		subtle = "#797593",
		text = "#464261",
		love = "#b4637a",
		gold = "#ea9d34",
		rose = "#d7827e",
		pine = "#286983",
		foam = "#56949f",
		iris = "#907aa9",
		highlight_low = "#f4ede8",
		highlight_med = "#dfdad9",
		highlight_high = "#cecacd",
	},
}

local rose_pine = function(variant)
	local p = ROSE_PINE_VARIANTS[variant] or ROSE_PINE_VARIANTS.main

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

		nvim_tree = make_nvim_tree({
			bg = p.base,
			fg = p.text,
			comment = p.muted,
			border = p.highlight_high,
			sel_bg = p.overlay,
			accent = p.iris,
			folder = p.foam,
			special = p.gold,
			symlink = p.foam,
			modified = p.gold,
			git_new = p.foam,
			git_dirty = p.gold,
			git_staged = p.pine,
			git_renamed = p.iris,
			git_deleted = p.love,
			git_merge = p.rose,
		}),

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

		nvim_tree = make_nvim_tree({
			bg = p.bg,
			fg = p.fg,
			comment = p.comment,
			border = p.separator,
			sel_bg = p.bg_line,
			accent = p.blue,
			folder = p.blue,
			special = p.yellow,
			symlink = p.cyan,
			modified = p.amber,
			git_new = p.green,
			git_dirty = p.yellow,
			git_staged = p.green,
			git_renamed = p.magenta,
			git_deleted = p.red,
			git_merge = p.pink,
		}),

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

		nvim_tree = make_nvim_tree({
			bg = p.bg,
			fg = p.fg,
			comment = p.comment,
			border = p.grey_three,
			sel_bg = p.grey_two,
			accent = p.blue,
			folder = p.blue,
			special = p.yellow,
			symlink = p.teal,
			modified = p.yellow,
			git_new = p.green,
			git_dirty = p.yellow,
			git_staged = p.green,
			git_renamed = p.purple,
			git_deleted = p.red,
			git_merge = p.pink,
		}),

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
-- Kanso reads straight off the plugin, which is safe here because
-- kanso.colors.setup() takes the theme explicitly — it does not depend on which
-- variant happens to be loaded. Returns {} when the plugin isn't in memory yet;
-- M.build() catches that.
local kanso = function(variant)
	local ok, kanso_colors = pcall(require, "kanso.colors")
	if not ok then
		return {}
	end

	local colors = kanso_colors.setup({ theme = variant or "zen" })
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

		nvim_tree = make_nvim_tree({
			bg = theme.ui.bg,
			fg = theme.ui.fg,
			comment = theme.syn.comment,
			border = theme.ui.bg_p2,
			sel_bg = theme.ui.bg_gutter,
			accent = theme.syn.fun,
			folder = theme.syn.fun,
			special = theme.syn.constant,
			symlink = theme.syn.special1,
			modified = theme.diag.warning,
			git_new = theme.syn.string,
			git_dirty = theme.diag.warning,
			git_staged = theme.syn.string,
			git_renamed = theme.syn.keyword,
			git_deleted = theme.diag.error,
			git_merge = theme.syn.special1,
		}),

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

		nvim_tree = make_nvim_tree({
			bg = p.bg,
			fg = p.fg,
			comment = p.comment,
			border = p.separator,
			sel_bg = p.bg_line,
			accent = p.blue,
			folder = p.blue,
			special = p.yellow,
			symlink = p.cyan,
			modified = p.amber,
			git_new = p.green,
			git_dirty = p.yellow,
			git_staged = p.green,
			git_renamed = p.purple,
			git_deleted = p.red,
			git_merge = p.pink,
		}),

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
--
-- KODA_DARK is the single source of truth for koda's dark palette: the plugin
-- spec passes it into `require("koda").setup{ colors = { dark = ... } }`, and
-- koda's own `get_palette()` deep-extends it over the stock table — so because
-- every one of koda's 25 keys is spelled out here, the merge yields exactly this
-- and the editor, the tree, the picker and the tabline cannot drift apart.
--
-- ── How these values were chosen ──────────────────────────────────────────
-- koda runs `transparent = true`, so what the eye actually sees is the kitty
-- background, #0e1415 — the same value as `bg`. Every ratio below is measured
-- against it, in OKLCH (perceptually uniform; HSL is not). Five rules:
--
--  1. One material. Surfaces and greys all carry the background's own hue
--     (209°) at low chroma, rather than pure neutral grey on a teal-black
--     ground — koda's stock greys are chroma 0.000, which never quite belonged.
--  2. An even lightness ladder, each rung a distinct role. Every rung that
--     carries TEXT clears 4.5:1; every rung that draws a LINE clears 3:1
--     (WCAG 1.4.11). Stock `comment` was 2.56:1 and `border` 2.00:1.
--  3. Equal energy. All fourteen accents sit in one lightness/chroma band, so
--     none grabs the eye first: the contrast spread is 1.4×, where koda's stock
--     accents ranged 1.60:1 (`red`, invisible) to 18.59:1 — 11.6×.
--  4. Chroma encodes meaning. Syntax accents get C 0.095; semantic/state colors
--     get C 0.125, so state stands out against code by being more SATURATED
--     rather than brighter.
--  5. Hue-adjacent colors separate on lightness. `func` (82°) and `string`
--     (100°) are only 18° apart, so they are staggered L* 74/84 — keeping the
--     original relationship where strings read lighter than functions. The
--     spec's `styles` adds bold functions and italic strings as a second,
--     non-color cue (which is what carries for color-vision deficiency).
--
-- koda's minimalism is deliberate and preserved: keyword/type/operator stay
-- tinted greys, not colors. Only const/func/string carry hue in code.
local KODA_DARK = {
	-- Surfaces and greys — hue 209, on an even L* ladder.
	bg = "#0E1415", -- L*18 · matches the kitty background
	line = "#1F282A", -- L*27 · filled surface: CursorLine/Visual/Pmenu/float
	dim = "#596668", -- L*50 · 3.12:1 · decorative: NonText/Conceal/FoldColumn
	border = "#606F71", -- L*53 · 3.55:1 · structural: FloatBorder/WinSeparator
	comment = "#6F8184", -- L*59 · 4.56:1 · comments/LineNr/inlay hints — TEXT
	operator = "#7B8587", -- L*61 · 4.91:1 · near-neutral
	keyword = "#898AA1", -- L*64 · 5.50:1 · subtle violet tint
	type = "#819B9F", -- L*67 · 6.31:1 · subtle cool tint
	fg = "#ACB3B4", -- L*76 · 8.73:1 · body text
	emphasis = "#DADFE0", -- L*90 · 13.8:1 · brightest; stock was #ffffff at 18.6:1
	special = "#DADFE0", -- = emphasis, so koda's `Identifier` stays neutral

	-- Syntax accents — C 0.095, hues 52/82/100 kept, lightness staggered.
	const = "#E8A67E", -- 9.02:1 · numbers / booleans / constants
	func = "#C9A562", -- 8.00:1 · functions (bold)
	string = "#D6CC8F", -- 11.4:1 · strings (italic); was #ffffb8 at 17.9:1
	char = "#D6CC8F", -- = string, so chars read as the strings they are

	-- Semantic accents — C 0.125, one lightness band.
	danger = "#FD9693", -- 8.82:1 · errors / deletions
	warning = "#ECA758", -- 9.06:1 · warnings / changes; koda links CurSearch here
	success = "#7DCD89", -- 9.71:1 · adds / ok
	cyan = "#30D0CC", -- 9.76:1 · hints
	info = "#61C2FE", -- 9.43:1 · info / links / folders
	highlight = "#99B5FE", -- 9.20:1 · UI accent: prompt/root/indicator; was 5.55:1
	pink = "#E499DD", -- 8.76:1 · merge / trace
	green = "#73C480", -- 8.80:1 · secondary green
	orange = "#EC9660", -- 8.05:1 · untracked
	red = "#F38C8A", -- 7.90:1 · conflict; stock #701516 was 1.60:1, invisible
}

-- The three koda variants this config registers. moss and glade are koda's stock
-- palettes, untouched — the tuning above is scoped to `dark` (the plugin spec
-- passes `colors = { dark = ... }`), because glade is a LIGHT palette and a flat
-- override table would force the dark background onto it.
--
-- Transcribed rather than required: lazy.nvim loads a plugin the moment one of
-- its modules is required, and since this runs while config.theme itself is
-- still loading, that pulls koda's `config` in mid-load — which requires
-- config.theme right back and dies on the circular require.
local KODA_VARIANTS = {
	dark = KODA_DARK,
	-- koda's stock moss, from lua/koda/palette/moss.lua
	moss = {
		bg = "#0e1415",
		fg = "#cecece",
		dim = "#30464a",
		line = "#182325",
		keyword = "#999999",
		type = "#708b8d",
		operator = "#708b8d",
		comment = "#707070",
		border = "#cecece",
		emphasis = "#71ade7",
		func = "#71ade7",
		string = "#95cb82",
		char = "#dfdf8e",
		special = "#dfdf8e",
		const = "#dfdf8e",
		highlight = "#cd974b",
		info = "#8ebeec",
		success = "#6abf40",
		warning = "#ec8013",
		danger = "#d2322d",
		green = "#95cb82",
		orange = "#ec8013",
		red = "#c33c33",
		pink = "#cc8bc9",
		cyan = "#47bea9",
	},
	-- koda's stock glade, from lua/koda/palette/glade.lua — the light one
	glade = {
		bg = "#f7f7f7",
		fg = "#000000",
		dim = "#bfd9d9",
		line = "#e2eeee",
		keyword = "#525252",
		type = "#708b8d",
		operator = "#708b8d",
		comment = "#696969",
		border = "#999999",
		emphasis = "#325cc0",
		func = "#325cc0",
		string = "#448c27",
		char = "#7a3e9d",
		special = "#7a3e9d",
		const = "#7a3e9d",
		highlight = "#BC7500",
		info = "#007acc",
		success = "#448c27",
		warning = "#BC7500",
		danger = "#d13e23",
		green = "#448c27",
		orange = "#ec8013",
		red = "#aa3731",
		pink = "#7a3e9d",
		cyan = "#0083b2",
	},
}

-- koda's palette is FLAT (no theme.ui / syn / diag sub-tables like kanso), so
-- the keys are read directly.
local koda = function(variant)
	local p = KODA_VARIANTS[variant] or KODA_VARIANTS.dark

	return {
		bg = p.bg,
		bg_sec = p.line,
		bg_notify = p.line,
		text = p.fg,
		text_sec = p.comment,
		inlay_hint_bg = p.line,
		-- comment, not dim: inlay hints are text, and `dim` sits at 2.98:1 on the
		-- buffer background — worse still on the `line` chip behind them.
		inlay_hint_fg = p.comment,

		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.bg, fg = p.fg },
					FzfLuaBorder = { fg = p.border, bg = p.bg },
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
			heading = p.func,
			button = p.highlight,
			shortcut = p.info,
		},

		indent = {
			line = p.line,
			-- border, not dim — matches the IblScope override in the plugin spec:
			-- a scope guide is a meaningful line and wants the 3:1 floor.
			scope = p.border,
		},

		-- blink.cmp menu palette (consumed by plugins/completion.lua). Previously
		-- that file re-derived koda's palette itself and hardcoded the gold/pale
		-- yellow; it now reads these, which come from KODA_DARK.
		blink = {
			fg = p.fg,
			blue = p.highlight,
			info = p.info,
			gold = p.const,
			green = p.success,
			red = p.danger,
			cyan = p.cyan,
			pink = p.pink,
			orange = p.orange,
			comment = p.comment,
			dim = p.dim,
			line = p.line,
			func = p.func,
			string = p.string,
		},

		nvim_tree = make_nvim_tree({
			bg = p.bg,
			fg = p.fg,
			comment = p.comment,
			-- KODA_DARK re-tints `border` (koda ships pure white), so the tree
			-- chrome can just use it now.
			border = p.border,
			sel_bg = p.line,
			accent = p.highlight,
			folder = p.info,
			special = p.const,
			symlink = p.cyan,
			modified = p.warning,
			git_new = p.success,
			git_dirty = p.warning,
			git_staged = p.success,
			git_renamed = p.highlight,
			git_deleted = p.danger,
			git_merge = p.pink,
		}),

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
			close_button = { fg = p.danger, bg = p.bg },
			close_button_visible = { fg = p.danger, bg = p.line },
			close_button_selected = { fg = p.danger, bg = p.bg },
			buffer_visible = { fg = p.comment, bg = p.line },
			buffer_selected = { fg = p.emphasis, bg = p.bg, bold = true, italic = false },
			numbers = { fg = p.cyan, bg = p.bg },
			numbers_visible = { fg = p.cyan, bg = p.line },
			numbers_selected = { fg = p.cyan, bg = p.bg, bold = true, italic = false },
			diagnostic = { fg = p.comment, bg = p.bg },
			diagnostic_visible = { fg = p.comment, bg = p.line },
			diagnostic_selected = { fg = p.fg, bg = p.bg, bold = true, italic = false },
			hint = { fg = p.highlight, bg = p.bg },
			hint_visible = { fg = p.highlight, bg = p.line },
			hint_selected = { fg = p.highlight, bg = p.bg, bold = true, italic = false },
			hint_diagnostic = { fg = p.highlight, bg = p.bg },
			hint_diagnostic_visible = { fg = p.highlight, bg = p.line },
			hint_diagnostic_selected = { fg = p.highlight, bg = p.bg, bold = true, italic = false },
			info = { fg = p.info, bg = p.bg },
			info_visible = { fg = p.info, bg = p.line },
			info_selected = { fg = p.info, bg = p.bg, bold = true, italic = false },
			info_diagnostic = { fg = p.info, bg = p.bg },
			info_diagnostic_visible = { fg = p.info, bg = p.line },
			info_diagnostic_selected = { fg = p.info, bg = p.bg, bold = true, italic = false },
			warning = { fg = p.warning, bg = p.bg },
			warning_visible = { fg = p.warning, bg = p.line },
			warning_selected = { fg = p.warning, bg = p.bg, bold = true, italic = false },
			warning_diagnostic = { fg = p.warning, bg = p.bg },
			warning_diagnostic_visible = { fg = p.warning, bg = p.line },
			warning_diagnostic_selected = { fg = p.warning, bg = p.bg, bold = true, italic = false },
			error = { fg = p.danger, bg = p.bg },
			error_visible = { fg = p.danger, bg = p.line },
			error_selected = { fg = p.danger, bg = p.bg, bold = true, italic = false },
			error_diagnostic = { fg = p.danger, bg = p.bg },
			error_diagnostic_visible = { fg = p.danger, bg = p.line },
			error_diagnostic_selected = { fg = p.danger, bg = p.bg, bold = true, italic = false },
			modified = { fg = p.warning, bg = p.bg },
			modified_visible = { fg = p.warning, bg = p.line },
			modified_selected = { fg = p.warning, bg = p.bg },
			duplicate = { fg = p.comment, bg = p.bg, italic = true },
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

-- Black Metal (metalelf0/black-metal-theme-neovim) — sixteen near-monochrome
-- bands, one per record.
--
-- Read live off the plugin, the way kanso() is: `black-metal.palette` is a pure
-- module whose `get(theme, variant)` hands back a deepcopy without any setup()
-- or colorscheme load, so there is nothing to transcribe and the sixteen bands
-- cost one builder. Returns {} when the plugin isn't in memory yet — M.build()
-- substitutes koda's palette for that, and config.theme_switcher rebuilds from
-- its ColorSchemePre hook once lazy has loaded the plugin.
local BLACK_METAL_BANDS = {
	"bathory",
	"burzum",
	"dark-funeral",
	"darkthrone",
	"emperor",
	"gorgoroth",
	"immortal",
	"impaled-nazarene",
	"khold",
	"marduk",
	"mayhem",
	"nile",
	"taake",
	"thyrfing",
	"venom",
	"windir",
}

-- Mix two hex colors. The bands share one very flat ramp — bg #000000, visual
-- #222222, comment #505050 and nothing in between — so the chrome has to derive
-- its middle greys rather than name them.
local function blend(fg, bg, alpha)
	local function mix(i)
		local a = tonumber(fg:sub(i, i + 1), 16) * alpha
		local b = tonumber(bg:sub(i, i + 1), 16) * (1 - alpha)
		return math.floor(math.min(math.max(a + b, 0), 255) + 0.5)
	end
	return string.format("#%02X%02X%02X", mix(2), mix(4), mix(6))
end

local black_metal = function(band)
	local ok, p = pcall(function()
		return require("black-metal.palette").get(band or "bathory", "dark")
	end)
	if not ok or type(p) ~= "table" or not p.bg then
		return {}
	end

	-- Only `string` (accent 1), `type` (accent 2) and `alt_bg` differ between the
	-- sixteen dark bands; everything else — the greys AND the diagnostics — is
	-- shared, and `diag_red` and `diag_yellow` are literally the same teal. So
	-- mirroring diag_* in the chrome would leave error, warning and hint
	-- indistinguishable in the tree, the tabline and the picker. The two per-band
	-- accents carry the spread instead: `type` (the loudest color a band owns)
	-- reads as error/deleted, `string` as warning/modified, `alt` (teal) as
	-- hint/staged, `constant` (light grey) as info/added.
	local accent = p.string
	local accent2 = p.type
	local err = p.type
	local warn = p.string
	local info = p.constant
	local hint = p.alt

	-- Chrome surfaces. `line` is #000000 on every band, i.e. the buffer
	-- background, so `visual` is the only real second surface; `border` and
	-- `dim` are blended out of the comment grey.
	local surface = p.visual
	-- Darkthrone is the one band whose alt_bg IS the background (#000000), so the
	-- selected tab falls back to the second surface rather than vanishing.
	local tab_bg = p.alt_bg ~= p.bg and p.alt_bg or surface
	local border = blend(p.comment, p.bg, 0.7)
	local dim = blend(p.comment, p.bg, 0.85)

	return {
		bg = p.bg,
		bg_sec = surface,
		bg_notify = surface,
		text = p.fg,
		text_sec = p.comment,
		inlay_hint_bg = surface,
		inlay_hint_fg = p.comment,

		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.bg, fg = p.fg },
					FzfLuaBorder = { fg = border, bg = p.bg },
					FzfLuaCursorLine = { bg = surface, fg = accent },
					FzfLuaTitle = { fg = accent2, bold = true },
					FzfLuaPrompt = { fg = accent, bold = true },
					FzfLuaPointer = { fg = accent2, bold = true },
					FzfLuaMarker = { fg = hint },
					FzfLuaSpinner = { fg = accent, bold = true },
					FzfLuaHeader = { fg = p.comment },
					FzfLuaPreviewTitle = { fg = accent2, bold = true },
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
			heading = accent2,
			button = accent,
			shortcut = hint,
		},

		indent = {
			line = blend(p.comment, p.bg, 0.45),
			scope = p.comment,
		},

		-- blink.cmp menu palette (plugins/completion.lua). The keys are generic
		-- hue slots, not literal colors, so the band's two accents take the
		-- prominent ones and the greys fill the rest.
		blink = {
			fg = p.fg,
			blue = accent,
			info = p.constant,
			gold = accent,
			green = hint,
			red = err,
			cyan = p.alt,
			pink = p.operator,
			orange = accent2,
			comment = p.comment,
			dim = dim,
			line = surface,
			func = accent2,
			string = accent,
		},

		nvim_tree = make_nvim_tree({
			bg = p.bg,
			fg = p.fg,
			comment = p.comment,
			border = border,
			sel_bg = surface,
			accent = accent2,
			folder = p.constant,
			special = accent,
			symlink = p.alt,
			modified = warn,
			git_new = info,
			git_dirty = warn,
			git_staged = hint,
			git_renamed = p.keyword,
			git_deleted = err,
			git_merge = p.operator,
		}),

		incline = {
			normal = { bg = surface, fg = p.fg },
			border = { bg = p.bg, fg = p.bg },
			normal_nc = { bg = surface, fg = p.comment },
			focused = { one = surface, two = surface },
			file_name = { guifg = p.fg },
			modified = { guifg = warn },
		},

		-- The selected tab is the one place the band's own tinted background
		-- (`alt_bg` — #3E2018 for bathory, #39121b for khold) earns its keep:
		-- it is the only color that tells the sixteen bands apart at a glance.
		bufferline = {
			fill = { fg = p.bg, bg = p.bg },
			background = { fg = p.comment, bg = p.bg },
			tab = { fg = p.comment, bg = p.bg },
			tab_selected = { fg = p.fg, bg = tab_bg, bold = true },
			tab_close = { fg = p.comment, bg = p.bg },
			close_button = { fg = err, bg = p.bg },
			close_button_visible = { fg = err, bg = p.bg },
			close_button_selected = { fg = err, bg = tab_bg },
			buffer_visible = { fg = p.comment, bg = p.bg },
			buffer_selected = { fg = p.fg, bg = tab_bg, bold = true, italic = false },
			numbers = { fg = p.alt, bg = p.bg },
			numbers_visible = { fg = p.alt, bg = p.bg },
			numbers_selected = { fg = p.alt, bg = tab_bg, bold = true, italic = false },
			diagnostic = { fg = p.comment, bg = p.bg },
			diagnostic_visible = { fg = p.comment, bg = p.bg },
			diagnostic_selected = { fg = p.fg, bg = tab_bg, bold = true, italic = false },
			hint = { fg = hint, bg = p.bg },
			hint_visible = { fg = hint, bg = p.bg },
			hint_selected = { fg = hint, bg = tab_bg, bold = true, italic = false },
			hint_diagnostic = { fg = hint, bg = p.bg },
			hint_diagnostic_visible = { fg = hint, bg = p.bg },
			hint_diagnostic_selected = { fg = hint, bg = tab_bg, bold = true, italic = false },
			info = { fg = info, bg = p.bg },
			info_visible = { fg = info, bg = p.bg },
			info_selected = { fg = info, bg = tab_bg, bold = true, italic = false },
			info_diagnostic = { fg = info, bg = p.bg },
			info_diagnostic_visible = { fg = info, bg = p.bg },
			info_diagnostic_selected = { fg = info, bg = tab_bg, bold = true, italic = false },
			warning = { fg = warn, bg = p.bg },
			warning_visible = { fg = warn, bg = p.bg },
			warning_selected = { fg = warn, bg = tab_bg, bold = true, italic = false },
			warning_diagnostic = { fg = warn, bg = p.bg },
			warning_diagnostic_visible = { fg = warn, bg = p.bg },
			warning_diagnostic_selected = { fg = warn, bg = tab_bg, bold = true, italic = false },
			error = { fg = err, bg = p.bg },
			error_visible = { fg = err, bg = p.bg },
			error_selected = { fg = err, bg = tab_bg, bold = true, italic = false },
			error_diagnostic = { fg = err, bg = p.bg },
			error_diagnostic_visible = { fg = err, bg = p.bg },
			error_diagnostic_selected = { fg = err, bg = tab_bg, bold = true, italic = false },
			modified = { fg = warn, bg = p.bg },
			modified_visible = { fg = warn, bg = p.bg },
			modified_selected = { fg = warn, bg = tab_bg },
			duplicate = { fg = p.comment, bg = p.bg, italic = true },
			duplicate_visible = { fg = p.comment, bg = p.bg, italic = true },
			duplicate_selected = { fg = p.fg, bg = tab_bg, italic = false },
			separator = { fg = border, bg = p.bg },
			separator_visible = { fg = border, bg = p.bg },
			separator_selected = { fg = border, bg = tab_bg },
			indicator_selected = { fg = accent2, bg = tab_bg },
			pick_selected = { fg = accent, bg = tab_bg, bold = true, italic = false },
			pick_visible = { fg = accent, bg = p.bg, bold = true, italic = false },
			pick = { fg = accent, bg = p.bg, bold = true, italic = false },
		},
	}
end

-- Material palette (marko-cerovac/material.nvim)
--
-- material.nvim picks its palette from `vim.g.material_style` and bakes it into
-- `material.colors` at require time, which is too late for us: options.lua pulls
-- theme.lua in before lazy has even cloned the plugin, and every :colorscheme
-- material wipes `package.loaded["material.colors"]`. So the five styles are
-- transcribed here from the plugin's lua/material/colors/init.lua and selected
-- by that same global. MATERIAL_STYLE below is the default the plugin spec
-- pushes into `vim.g.material_style`, so this file stays the single place to
-- change the style: "deep ocean" | "darker" | "palenight" | "oceanic" | "lighter".
local MATERIAL_STYLE = "darker"

local material = function()
	-- "main" colors — shared by every style except lighter, which overrides them
	local main = {
		white = "#EEFFFF",
		gray = "#717CB4",
		red = "#F07178",
		green = "#C3E88D",
		yellow = "#FFCB6B",
		blue = "#82AAFF",
		paleblue = "#B0C9FF",
		cyan = "#89DDFF",
		purple = "#C792EA",
		orange = "#F78C6C",
		pink = "#FF9CAC",
		error_red = "#FF5370", -- colors.lsp.error
		link = "#80CBC4", -- colors.editor.link
	}

	local styles = {
		["deep ocean"] = {
			editor = {
				bg = "#0F111A",
				bg_alt = "#090B10",
				fg = "#A6ACCD",
				fg_dark = "#717CB4",
				selection = "#1F2233",
				contrast = "#090B10",
				active = "#1A1C25",
				border = "#232637",
				line_numbers = "#3B3F51",
				highlight = "#1F2233",
				disabled = "#464B5D",
				accent = "#84FFFF",
				comments = "#464B5D",
			},
		},
		darker = {
			editor = {
				bg = "#212121",
				bg_alt = "#1A1A1A",
				fg = "#B0BEC5",
				fg_dark = "#8C8B8B",
				selection = "#404040",
				contrast = "#1A1A1A",
				active = "#323232",
				border = "#343434",
				line_numbers = "#424242",
				highlight = "#3F3F3F",
				disabled = "#474747",
				accent = "#FF9800",
				comments = "#515151",
			},
		},
		palenight = {
			editor = {
				bg = "#292D3E",
				bg_alt = "#1B1E2B",
				fg = "#A6ACCD",
				fg_dark = "#717CB4",
				selection = "#444267",
				contrast = "#202331",
				active = "#414863",
				border = "#364367",
				line_numbers = "#3A3F58",
				highlight = "#444267",
				disabled = "#515772",
				accent = "#AB47BC",
				comments = "#676E95",
			},
		},
		oceanic = {
			editor = {
				bg = "#25363B",
				bg_alt = "#1C2C30",
				fg = "#B0BEC5",
				fg_dark = "#7C9EAD",
				selection = "#395B65",
				contrast = "#1E272C",
				active = "#314549",
				border = "#355058",
				line_numbers = "#426367",
				highlight = "#354A51",
				disabled = "#3E5F64",
				accent = "#11BBA3",
				comments = "#546E7A",
			},
		},
		lighter = {
			editor = {
				bg = "#FAFAFA",
				bg_alt = "#FFFFFF",
				fg = "#546E7A",
				fg_dark = "#94A7B0",
				selection = "#80CBC4",
				contrast = "#EEEEEE",
				active = "#E7E7E8",
				border = "#D3E1E8",
				line_numbers = "#CFD8DC",
				highlight = "#E7E7E8",
				disabled = "#D2D4D5",
				accent = "#00BCD4",
				comments = "#AABFC9",
			},
			-- lighter re-tints the whole "main" table for contrast on white
			main = {
				red = "#E53935",
				green = "#91B859",
				yellow = "#F6A434",
				blue = "#6182B8",
				paleblue = "#8796B0",
				cyan = "#39ADB5",
				purple = "#7C4DFF",
				orange = "#F76D47",
				pink = "#FF5370",
			},
		},
	}

	local style = styles[vim.g.material_style] or styles[MATERIAL_STYLE] or styles["deep ocean"]
	local p = vim.tbl_extend("force", main, style.main or {}, style.editor)

	return {
		bg = p.bg,
		bg_sec = p.active,
		bg_notify = p.active,
		text = p.fg,
		text_sec = p.comments,
		inlay_hint_bg = p.active,
		inlay_hint_fg = p.disabled,

		-- Floats and sidebars sit on `bg_alt` to match `contrast.floating_windows`
		-- / `contrast.sidebars` in the plugin spec.
		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.bg_alt, fg = p.fg },
					FzfLuaBorder = { fg = p.border, bg = p.bg_alt },
					FzfLuaCursorLine = { bg = p.selection, fg = p.accent },
					FzfLuaTitle = { fg = p.blue, bold = true },
					FzfLuaPrompt = { fg = p.purple, bold = true },
					FzfLuaPointer = { fg = p.purple, bold = true },
					FzfLuaMarker = { fg = p.green },
					FzfLuaSpinner = { fg = p.accent, bold = true },
					FzfLuaHeader = { fg = p.comments },
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
			heading = p.accent,
			button = p.purple,
			shortcut = p.blue,
		},

		-- indent-blankline guides (consumed by plugins/editor.lua)
		indent = {
			line = p.border,
			scope = p.disabled,
		},

		-- blink.cmp menu palette (consumed by plugins/completion.lua)
		blink = {
			fg = p.fg,
			blue = p.blue,
			info = p.paleblue,
			gold = p.yellow,
			green = p.green,
			red = p.error_red,
			cyan = p.cyan,
			pink = p.pink,
			orange = p.orange,
			comment = p.comments,
			dim = p.border,
			line = p.selection,
			func = p.blue,
			string = p.green,
		},

		nvim_tree = make_nvim_tree({
			bg = p.bg_alt,
			fg = p.fg,
			comment = p.comments,
			border = p.border,
			sel_bg = p.selection,
			accent = p.accent,
			folder = p.blue,
			special = p.yellow,
			symlink = p.link,
			modified = p.yellow,
			git_new = p.green,
			git_dirty = p.yellow,
			git_staged = p.green,
			git_renamed = p.purple,
			git_deleted = p.red,
			git_merge = p.pink,
		}),

		incline = {
			normal = { bg = p.active, fg = p.fg },
			border = { bg = p.bg, fg = p.bg },
			normal_nc = { bg = p.active, fg = p.comments },
			focused = { one = p.active, two = p.active },
			file_name = { guifg = p.fg },
			modified = { guifg = p.yellow },
		},

		bufferline = {
			fill = { fg = p.bg_alt, bg = p.bg_alt },
			background = { fg = p.comments, bg = p.bg_alt },
			tab = { fg = p.comments, bg = p.bg_alt },
			tab_selected = { fg = p.accent, bg = p.bg, bold = true },
			tab_close = { fg = p.comments, bg = p.bg_alt },
			close_button = { fg = p.red, bg = p.bg_alt },
			close_button_visible = { fg = p.red, bg = p.bg_alt },
			close_button_selected = { fg = p.red, bg = p.bg },
			buffer_visible = { fg = p.comments, bg = p.bg_alt },
			buffer_selected = { fg = p.fg, bg = p.bg, bold = true, italic = false },
			numbers = { fg = p.cyan, bg = p.bg_alt },
			numbers_visible = { fg = p.cyan, bg = p.bg_alt },
			numbers_selected = { fg = p.cyan, bg = p.bg, bold = true, italic = false },
			diagnostic = { fg = p.comments, bg = p.bg_alt },
			diagnostic_visible = { fg = p.comments, bg = p.bg_alt },
			diagnostic_selected = { fg = p.fg, bg = p.bg, bold = true, italic = false },
			hint = { fg = p.purple, bg = p.bg_alt },
			hint_visible = { fg = p.purple, bg = p.bg_alt },
			hint_selected = { fg = p.purple, bg = p.bg, bold = true, italic = false },
			hint_diagnostic = { fg = p.purple, bg = p.bg_alt },
			hint_diagnostic_visible = { fg = p.purple, bg = p.bg_alt },
			hint_diagnostic_selected = { fg = p.purple, bg = p.bg, bold = true, italic = false },
			info = { fg = p.paleblue, bg = p.bg_alt },
			info_visible = { fg = p.paleblue, bg = p.bg_alt },
			info_selected = { fg = p.paleblue, bg = p.bg, bold = true, italic = false },
			info_diagnostic = { fg = p.paleblue, bg = p.bg_alt },
			info_diagnostic_visible = { fg = p.paleblue, bg = p.bg_alt },
			info_diagnostic_selected = { fg = p.paleblue, bg = p.bg, bold = true, italic = false },
			warning = { fg = p.yellow, bg = p.bg_alt },
			warning_visible = { fg = p.yellow, bg = p.bg_alt },
			warning_selected = { fg = p.yellow, bg = p.bg, bold = true, italic = false },
			warning_diagnostic = { fg = p.yellow, bg = p.bg_alt },
			warning_diagnostic_visible = { fg = p.yellow, bg = p.bg_alt },
			warning_diagnostic_selected = { fg = p.yellow, bg = p.bg, bold = true, italic = false },
			error = { fg = p.error_red, bg = p.bg_alt },
			error_visible = { fg = p.error_red, bg = p.bg_alt },
			error_selected = { fg = p.error_red, bg = p.bg, bold = true, italic = false },
			error_diagnostic = { fg = p.error_red, bg = p.bg_alt },
			error_diagnostic_visible = { fg = p.error_red, bg = p.bg_alt },
			error_diagnostic_selected = { fg = p.error_red, bg = p.bg, bold = true, italic = false },
			modified = { fg = p.yellow, bg = p.bg_alt },
			modified_visible = { fg = p.yellow, bg = p.bg_alt },
			modified_selected = { fg = p.yellow, bg = p.bg },
			duplicate = { fg = p.comments, bg = p.bg_alt, italic = true },
			duplicate_visible = { fg = p.comments, bg = p.bg_alt, italic = true },
			duplicate_selected = { fg = p.fg, bg = p.bg, italic = false },
			separator = { fg = p.bg_alt, bg = p.bg_alt },
			separator_visible = { fg = p.bg_alt, bg = p.bg_alt },
			separator_selected = { fg = p.bg_alt, bg = p.bg },
			indicator_selected = { fg = p.accent, bg = p.bg },
			pick_selected = { fg = p.orange, bg = p.bg, bold = true, italic = false },
			pick_visible = { fg = p.orange, bg = p.bg_alt, bold = true, italic = false },
			pick = { fg = p.orange, bg = p.bg_alt, bold = true, italic = false },
		},
	}
end

-- Evergarden palette (everviolet/nvim)
--
-- Catppuccin-shaped palette: a base/mantle/crust background ramp, surface*/
-- overlay* for chrome, and named accents. The plugin reads the variant from its
-- own stored config rather than a global, and `evergarden.colors` isn't
-- requireable before lazy clones the plugin, so the five palettes are
-- transcribed here from lua/evergarden/palettes/ and picked by EVERGARDEN_VARIANT.
-- The plugin spec reads the same constant, so both sides always agree.
local EVERGARDEN_VARIANT = "winter" -- winter | fall | spring | summer | lunar
local EVERGARDEN_ACCENT = "winter" -- any palette color name

local evergarden = function()
	-- Every dark variant shares the accent colors and differs only in the
	-- background ramp; summer is the light one and lunar re-tints everything.
	local accents = {
		red = "#f57f82",
		orange = "#f7a182",
		yellow = "#f5d098",
		lime = "#dbe6af",
		green = "#cbe3b3",
		aqua = "#b3e3ca",
		skye = "#b3e6db",
		snow = "#afd9e6",
		blue = "#b2caed",
		purple = "#d2bdf3",
		pink = "#f3c0e5",
		cherry = "#fae6ef",
		text = "#f8f9e8",
		subtext1 = "#adc9bc",
		subtext0 = "#96b4aa",
		overlay2 = "#839e9a",
		overlay1 = "#6f8788",
		overlay0 = "#58686d",
		surface2 = "#4a585c",
	}

	local variants = {
		winter = { surface1 = "#374145", surface0 = "#262f33", base = "#1e2528", mantle = "#191e21", crust = "#171c1f" },
		fall = { surface1 = "#374145", surface0 = "#2b3337", base = "#232a2e", mantle = "#1c2225", crust = "#171c1f" },
		spring = { surface1 = "#3e4a4f", surface0 = "#343e43", base = "#2b3438", mantle = "#232a2e", crust = "#1c2225" },
		summer = {
			red = "#c58687",
			orange = "#c69883",
			yellow = "#c4aa80",
			lime = "#abb182",
			green = "#91a77a",
			aqua = "#74a48b",
			skye = "#719f96",
			snow = "#7799a3",
			blue = "#8294ad",
			purple = "#a897b8",
			pink = "#c499b8",
			cherry = "#c29fb2",
			text = "#2b3034",
			subtext1 = "#455355",
			subtext0 = "#576869",
			overlay2 = "#707d76",
			overlay1 = "#829084",
			overlay0 = "#acb5a4",
			surface2 = "#ceccbd",
			surface1 = "#e6e1d3",
			surface0 = "#ede8dd",
			base = "#f5efe6",
			mantle = "#f2eae1",
			crust = "#e8ded5",
		},
		lunar = {
			red = "#EB7F86",
			orange = "#F5A58D",
			yellow = "#F7DDAF",
			lime = "#DBE3C7",
			green = "#C5D9B5",
			aqua = "#ACD1B6",
			skye = "#AAD0C9",
			snow = "#ADD1D8",
			blue = "#99B3D5",
			purple = "#A69FD5",
			pink = "#D6ABC3",
			cherry = "#E0C5D0",
			text = "#F7F1E6",
			subtext1 = "#CBD7F2",
			subtext0 = "#B4C0DB",
			overlay2 = "#9EA5C1",
			overlay1 = "#9096B1",
			overlay0 = "#757A93",
			surface2 = "#4C4F61",
			surface1 = "#353847",
			surface0 = "#21232E",
			base = "#1C1D29",
			mantle = "#171923",
			crust = "#11121A",
		},
	}

	local p = vim.tbl_extend("force", accents, variants[EVERGARDEN_VARIANT] or variants.winter)
	local accent = p[EVERGARDEN_ACCENT] or p.green
	-- Mirrors evergarden's own theme.lua: comments are overlay2, floats and the
	-- completion menu sit on mantle, and the syntax roles are fixed accents.
	local comment = p.overlay2
	local syn = { func = p.green, string = p.lime, keyword = p.red, type = p.yellow, property = p.skye }

	return {
		bg = p.base,
		bg_sec = p.surface0,
		bg_notify = p.mantle,
		text = p.text,
		text_sec = comment,
		inlay_hint_bg = p.surface0,
		inlay_hint_fg = p.overlay1,

		-- Floats/sidebars sit on `mantle`, matching editor.float.color in the spec.
		fzf = {
			setup_colors = function()
				local highlights = {
					FzfLuaNormal = { bg = p.mantle, fg = p.text },
					FzfLuaBorder = { fg = p.surface1, bg = p.mantle },
					FzfLuaCursorLine = { bg = p.surface0, fg = accent },
					FzfLuaTitle = { fg = p.blue, bold = true },
					FzfLuaPrompt = { fg = p.purple, bold = true },
					FzfLuaPointer = { fg = p.purple, bold = true },
					FzfLuaMarker = { fg = p.green },
					FzfLuaSpinner = { fg = accent, bold = true },
					FzfLuaHeader = { fg = p.overlay1 },
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
			heading = accent,
			button = p.purple,
			shortcut = p.blue,
		},

		indent = {
			line = p.surface0,
			scope = p.surface2,
		},

		blink = {
			fg = p.text,
			blue = p.blue,
			info = p.aqua,
			gold = syn.type,
			green = syn.func,
			red = p.red,
			cyan = p.skye,
			pink = p.pink,
			orange = p.orange,
			comment = comment,
			dim = p.surface1,
			line = p.surface0,
			func = syn.func,
			string = syn.string,
		},

		nvim_tree = make_nvim_tree({
			bg = p.mantle,
			fg = p.text,
			comment = p.overlay1,
			border = p.surface1,
			sel_bg = p.surface0,
			accent = accent,
			folder = p.blue,
			special = p.yellow,
			symlink = p.skye,
			modified = p.yellow,
			-- git colors follow evergarden's theme.git mapping
			git_new = p.subtext1,
			git_dirty = p.skye,
			git_staged = p.green,
			git_renamed = p.purple,
			git_deleted = p.red,
			git_merge = p.orange,
		}),

		incline = {
			normal = { bg = p.surface0, fg = p.text },
			border = { bg = p.base, fg = p.base },
			normal_nc = { bg = p.surface0, fg = p.overlay1 },
			focused = { one = p.surface0, two = p.surface0 },
			file_name = { guifg = p.text },
			modified = { guifg = p.yellow },
		},

		bufferline = {
			fill = { fg = p.mantle, bg = p.mantle },
			background = { fg = p.overlay1, bg = p.mantle },
			tab = { fg = p.overlay1, bg = p.mantle },
			tab_selected = { fg = accent, bg = p.base, bold = true },
			tab_close = { fg = p.overlay1, bg = p.mantle },
			close_button = { fg = p.red, bg = p.mantle },
			close_button_visible = { fg = p.red, bg = p.mantle },
			close_button_selected = { fg = p.red, bg = p.base },
			buffer_visible = { fg = p.overlay1, bg = p.mantle },
			buffer_selected = { fg = p.text, bg = p.base, bold = true, italic = false },
			numbers = { fg = p.skye, bg = p.mantle },
			numbers_visible = { fg = p.skye, bg = p.mantle },
			numbers_selected = { fg = p.skye, bg = p.base, bold = true, italic = false },
			diagnostic = { fg = p.overlay1, bg = p.mantle },
			diagnostic_visible = { fg = p.overlay1, bg = p.mantle },
			diagnostic_selected = { fg = p.text, bg = p.base, bold = true, italic = false },
			hint = { fg = p.skye, bg = p.mantle },
			hint_visible = { fg = p.skye, bg = p.mantle },
			hint_selected = { fg = p.skye, bg = p.base, bold = true, italic = false },
			hint_diagnostic = { fg = p.skye, bg = p.mantle },
			hint_diagnostic_visible = { fg = p.skye, bg = p.mantle },
			hint_diagnostic_selected = { fg = p.skye, bg = p.base, bold = true, italic = false },
			info = { fg = p.aqua, bg = p.mantle },
			info_visible = { fg = p.aqua, bg = p.mantle },
			info_selected = { fg = p.aqua, bg = p.base, bold = true, italic = false },
			info_diagnostic = { fg = p.aqua, bg = p.mantle },
			info_diagnostic_visible = { fg = p.aqua, bg = p.mantle },
			info_diagnostic_selected = { fg = p.aqua, bg = p.base, bold = true, italic = false },
			warning = { fg = p.yellow, bg = p.mantle },
			warning_visible = { fg = p.yellow, bg = p.mantle },
			warning_selected = { fg = p.yellow, bg = p.base, bold = true, italic = false },
			warning_diagnostic = { fg = p.yellow, bg = p.mantle },
			warning_diagnostic_visible = { fg = p.yellow, bg = p.mantle },
			warning_diagnostic_selected = { fg = p.yellow, bg = p.base, bold = true, italic = false },
			error = { fg = p.red, bg = p.mantle },
			error_visible = { fg = p.red, bg = p.mantle },
			error_selected = { fg = p.red, bg = p.base, bold = true, italic = false },
			error_diagnostic = { fg = p.red, bg = p.mantle },
			error_diagnostic_visible = { fg = p.red, bg = p.mantle },
			error_diagnostic_selected = { fg = p.red, bg = p.base, bold = true, italic = false },
			modified = { fg = p.yellow, bg = p.mantle },
			modified_visible = { fg = p.yellow, bg = p.mantle },
			modified_selected = { fg = p.yellow, bg = p.base },
			duplicate = { fg = p.overlay1, bg = p.mantle, italic = true },
			duplicate_visible = { fg = p.overlay1, bg = p.mantle, italic = true },
			duplicate_selected = { fg = p.text, bg = p.base, italic = false },
			separator = { fg = p.crust, bg = p.mantle },
			separator_visible = { fg = p.crust, bg = p.mantle },
			separator_selected = { fg = p.crust, bg = p.base },
			indicator_selected = { fg = accent, bg = p.base },
			pick_selected = { fg = p.orange, bg = p.base, bold = true, italic = false },
			pick_visible = { fg = p.orange, bg = p.mantle, bold = true, italic = false },
			pick = { fg = p.orange, bg = p.mantle, bold = true, italic = false },
		},
	}
end

-- ══════════════════════════════════════════════════════════════════════
-- Theme registry
--
-- One entry per INSTALLED colorscheme, in picker order. `palette` is the
-- builder above, `colorscheme` the name handed to :colorscheme, and `plugin`
-- the lazy spec name so config.theme_switcher can load it BEFORE building the
-- palette — kanso() in particular reads its colors straight off the plugin.
-- `background` is either a string or a function, for the two themes whose
-- light/dark answer depends on a variant constant.
--
-- serenity() is exported below but absent here: no plugin is installed for it.
-- ══════════════════════════════════════════════════════════════════════
M.themes = {
	{
		key = "koda",
		label = "Koda",
		plugin = "koda.nvim",
		colorscheme = "koda-dark",
		palette = koda,
		background = "dark",
	},
	{
		key = "koda-moss",
		label = "Koda Moss",
		plugin = "koda.nvim",
		colorscheme = "koda-moss",
		palette = koda,
		variant = "moss",
		background = "dark",
	},
	{
		key = "koda-glade",
		label = "Koda Glade",
		plugin = "koda.nvim",
		colorscheme = "koda-glade",
		palette = koda,
		variant = "glade",
		background = "light", -- glade is koda's light palette
	},

	{
		key = "material",
		label = "Material",
		plugin = "material.nvim",
		colorscheme = "material",
		palette = material,
		background = function()
			return (vim.g.material_style or MATERIAL_STYLE) == "lighter" and "light" or "dark"
		end,
	},
	{
		key = "evergarden",
		label = "Evergarden",
		plugin = "evergarden",
		colorscheme = "evergarden",
		palette = evergarden,
		background = EVERGARDEN_VARIANT == "summer" and "light" or "dark",
	},
	{
		key = "kanso-zen",
		label = "Kanso Zen",
		plugin = "kanso.nvim",
		colorscheme = "kanso-zen",
		alias = "kanso", -- what colors/kanso-zen reports as vim.g.colors_name
		palette = kanso,
		variant = "zen",
		background = "dark",
	},
	{
		key = "kanso-ink",
		label = "Kanso Ink",
		plugin = "kanso.nvim",
		colorscheme = "kanso-ink",
		palette = kanso,
		variant = "ink",
		background = "dark",
	},
	{
		key = "kanso-mist",
		label = "Kanso Mist",
		plugin = "kanso.nvim",
		colorscheme = "kanso-mist",
		palette = kanso,
		variant = "mist",
		background = "dark",
	},
	{
		key = "kanso-pearl",
		label = "Kanso Pearl",
		plugin = "kanso.nvim",
		colorscheme = "kanso-pearl",
		palette = kanso,
		variant = "pearl",
		background = "light",
	},
	{
		key = "rose-pine",
		label = "Rose Pine",
		plugin = "rose-pine",
		colorscheme = "rose-pine",
		palette = rose_pine,
		variant = "main",
		background = "dark",
	},
	{
		key = "rose-pine-moon",
		label = "Rose Pine Moon",
		plugin = "rose-pine",
		colorscheme = "rose-pine-moon",
		palette = rose_pine,
		variant = "moon",
		background = "dark",
	},
	{
		key = "rose-pine-dawn",
		label = "Rose Pine Dawn",
		plugin = "rose-pine",
		colorscheme = "rose-pine-dawn",
		palette = rose_pine,
		variant = "dawn",
		background = "light",
	},
	{
		key = "kanagawa",
		label = "Kanagawa",
		plugin = "kanagawa.nvim",
		colorscheme = "kanagawa-wave",
		alias = "kanagawa",
		palette = kanagawa,
		background = "dark",
	},
	{
		key = "jellybeans",
		label = "Jellybeans",
		plugin = "jellybeans.nvim",
		colorscheme = "jellybeans",
		palette = jellybeans,
		background = "dark",
	},
}

-- Black Metal's sixteen bands. Generated rather than written out: the entries
-- differ only in the band name, and the palette builder takes it as its
-- `variant` (M.build passes entry.variant as the sole argument). `colorscheme`
-- is the bare band name — the plugin registers `colors/<band>.lua`, there is no
-- `black-metal-` prefix — and no `alias` is needed because its load() reports
-- that same name as vim.g.colors_name.
for _, band in ipairs(BLACK_METAL_BANDS) do
	table.insert(M.themes, {
		key = "black-metal-" .. band,
		label = "Black Metal · " .. (band:gsub("(%a)([%w]*)", function(first, rest)
			return first:upper() .. rest
		end):gsub("%-", " ")),
		plugin = "black-metal-theme-neovim",
		colorscheme = band,
		palette = black_metal,
		variant = band,
		background = "dark", -- light variants are disabled by `trve` in the spec
	})
end

-- Fallback whenever nothing is persisted, the saved name is unknown, or a
-- palette fails to build. koda is the only builder with no external dependency.
M.DEFAULT_THEME = "koda"

-- Where the chosen theme is remembered across restarts. Written only on an
-- explicit switch (:Theme / the picker's <CR>), never from the ColorScheme
-- autocmds — the picker's live preview fires one :colorscheme per cursor move.
M.state_file = vim.fn.stdpath("state") .. "/theme.json"

function M.by_key(key)
	for _, entry in ipairs(M.themes) do
		if entry.key == key then
			return entry
		end
	end
end

-- Resolve a :colorscheme name to its registry entry. Also matches `alias`: two
-- of these schemes set vim.g.colors_name to their family name rather than the
-- variant they were loaded as ("kanso-zen" reports "kanso"), and fzf-lua's
-- picker restores THAT string when you abort a live preview — so without the
-- alias an <Esc> would leave current_theme pointing at the previewed palette.
function M.by_colorscheme(name)
	for _, entry in ipairs(M.themes) do
		if entry.colorscheme == name or entry.alias == name then
			return entry
		end
	end
end

-- Read the persisted choice. Returns nil — never throws — on a missing,
-- unreadable, malformed or unrecognized file, so a corrupt state file costs a
-- fallback to DEFAULT_THEME rather than a broken startup.
function M.read_saved()
	local file = io.open(M.state_file, "r")
	if not file then
		return nil
	end
	local contents = file:read("*a")
	file:close()

	local ok, decoded = pcall(vim.json.decode, contents)
	if not ok or type(decoded) ~= "table" then
		return nil
	end
	return M.by_key(decoded.theme) and decoded.theme or nil
end

-- Build a palette defensively. kanso() returns {} when its plugin isn't loaded
-- yet (see its pcall above — unlike rose_pine() it has no hardcoded fallback),
-- and this module is required from config.options before lazy has loaded
-- anything, so a bare call can hand back a table with no `fzf` key that every
-- consumer then indexes into. Callers get koda's palette instead of a crash;
-- config.theme_switcher rebuilds properly once the plugin is in memory.
function M.build(key)
	local entry = M.by_key(key)
	if not entry then
		return koda()
	end
	local ok, palette = pcall(entry.palette, entry.variant)
	if ok and type(palette) == "table" and palette.fzf then
		return palette
	end
	return koda()
end

-- Active theme. Persisted by config.theme_switcher; edit theme.json or use
-- :Theme / <leader>uc rather than hardcoding a builder here.
M.active = M.read_saved() or M.DEFAULT_THEME
M.current_theme = M.build(M.active)

-- Keep all available for reference
M.rose_pine = rose_pine
M.kanagawa = kanagawa
M.jellybeans = jellybeans
M.kanso = kanso
M.serenity = serenity
M.koda = koda
M.material = material
M.evergarden = evergarden
M.black_metal = black_metal

-- The sixteen black-metal bands, in registry order; exported so the plugin spec
-- and anything else that needs the list reads the same table this file loops over.
M.black_metal_bands = BLACK_METAL_BANDS

-- koda's tuned dark palette. The plugin spec feeds it to require("koda").setup()
-- as `colors = { dark = ... }` — scoped to that variant, because a flat table is
-- applied to EVERY variant by koda's get_palette(), which would force this dark
-- background onto glade, koda's light palette.
M.koda_colors = KODA_DARK

-- Default material.nvim style; the plugin spec reads this and pushes it into
-- `vim.g.material_style` before the colorscheme loads. `:MaterialStyle <style>`
-- (defined in plugins/colorscheme.lua) swaps it at runtime and refreshes
-- M.current_theme so every consumer above follows along.
M.material_style = MATERIAL_STYLE

-- Default evergarden variant + accent; the plugin spec passes both straight into
-- `require("evergarden").setup()`, so this file stays the only place to change them.
M.evergarden_variant = EVERGARDEN_VARIANT
M.evergarden_accent = EVERGARDEN_ACCENT

return M
