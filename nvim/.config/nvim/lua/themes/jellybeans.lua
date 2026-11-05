-- Theme module contract (see config/theme/init.lua for the registry):
--   M.palette(variant)  -> consumer palette table (bg, bg_sec, bg_notify, text,
--                          text_sec, inlay_hint_*, fzf.setup_colors, alpha,
--                          nvim_tree, incline, bufferline, tags; optional indent, blink).
--                          Returns {} if the plugin it reads from is not loaded.
--   M.background()      -> "dark" | "light" (only when it depends on runtime state)
--   M.spec              -> the lazy.nvim spec for the colorscheme plugin
-- Only `themes.lib` may be required at the top level of a theme file.
local lib = require("themes.lib")

local M = {}

-- Jellybeans palette
function M.palette()
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

		tags = {
			builtin = p.teal,
			component = p.yellow,
			attribute = p.purple,
			delimiter = p.grey_three,
		},

		alpha = {
			heading = p.yellow,
			button = p.purple,
			shortcut = p.blue,
		},

		nvim_tree = lib.make_nvim_tree({
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

-- Jellybeans (available via :colorscheme jellybeans)
M.spec = {
	"wtfox/jellybeans.nvim",
	lazy = true,
	priority = 1000,
	opts = {
		transparent = false,
		italics = true,
		bold = true,
		flat_ui = true,
		plugins = {
			all = false,
			auto = true,
		},
		on_highlights = function(hl, c)
			-- Neo-tree
			hl.NeoTreeNormal = { bg = c.background }
			hl.NeoTreeNormalNC = { bg = c.background }
			hl.NeoTreeWinSeparator = { fg = c.background, bg = c.background }
			hl.NeoTreeCursorLine = { bg = c.grey_one }

			-- FzfLua
			hl.FzfLuaNormal = { bg = c.background, fg = c.foreground }
			hl.FzfLuaBorder = { fg = c.grey_three }
			hl.FzfLuaCursorLine = { bg = c.grey_one, fg = c.purple }
			hl.FzfLuaTitle = { fg = c.blue, bold = true }
			hl.FzfLuaPrompt = { fg = c.purple, bold = true }
			hl.FzfLuaPointer = { fg = c.purple, bold = true }
			hl.FzfLuaMarker = { fg = c.green }

			-- Completion
			hl.CmpItemAbbrMatch = { fg = c.blue, bold = true }
			hl.CmpItemAbbrMatchFuzzy = { fg = c.blue, bold = true }
			hl.CmpItemKindFunction = { fg = c.yellow }
			hl.CmpItemKindVariable = { fg = c.blue }
			hl.CmpItemKindClass = { fg = c.orange }
			hl.CmpItemKindKeyword = { fg = c.purple }
			hl.CmpItemKindSnippet = { fg = c.green }

			-- Indent blankline
			hl.IblIndent = { fg = c.grey_one }
			hl.IblScope = { fg = c.grey_three }
		end,
	},
}

return M
