-- Theme module contract (see config/theme/init.lua for the registry):
--   M.palette(variant)  -> consumer palette table (bg, bg_sec, bg_notify, text,
--                          text_sec, inlay_hint_*, fzf.setup_colors, alpha,
--                          nvim_tree, incline, bufferline; optional indent, blink).
--                          Returns {} if the plugin it reads from is not loaded.
--   M.background()      -> "dark" | "light" (only when it depends on runtime state)
--   M.spec              -> the lazy.nvim spec for the colorscheme plugin
-- Only `themes.lib` may be required at the top level of a theme file.
local lib = require("themes.lib")

local M = {}

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

function M.palette(variant)
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
					-- bg "NONE" rather than the palette's background: the
					-- picker is a float over a transparent editor.
					FzfLuaNormal = { bg = "NONE", fg = p.text },
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

		nvim_tree = lib.make_nvim_tree({
			transparent = true, -- rose-pine runs `styles.transparency`; see M.spec
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

-- Rose Pine
M.spec = {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = true,
	priority = 1000,
	config = function()
		require("rose-pine").setup({
			variant = "auto", -- the colors/rose-pine-*.lua files pick the variant
			dark_variant = "main", -- plain `:colorscheme rose-pine` on a dark background
			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			styles = {
				bold = true,
				italic = true,
				-- rose-pine reads transparency from HERE. A top-level
				-- `transparent = true` is not one of its options, so it was
				-- silently ignored while this said false -- the theme never
				-- actually ran transparent.
				transparency = true,
			},

			palette = {},
			highlight_groups = {
				-- Treesitter
				["@keyword"] = { italic = true },
				["@type.qualifier"] = { italic = true },
				["@variable.builtin"] = { italic = true },
				["@string.special.url"] = { fg = "iris", underline = true },

				-- UI
				--
				-- bg "NONE" throughout, not the palette's `base`: `styles.transparency`
				-- above only stops rose-pine from painting its OWN backgrounds, and
				-- naming one here puts it straight back -- which is what kept the
				-- editor, the gutter and every float opaque.
				Normal = { bg = "NONE" },
				NormalFloat = { bg = "NONE" },
				NormalNC = { bg = "NONE" },
				SignColumn = { bg = "NONE" },
				LineNr = { bg = "NONE", fg = "muted" },
				CursorLineNr = { bg = "NONE", fg = "text", bold = true },
				FoldColumn = { bg = "NONE" },
				WinSeparator = { fg = "overlay", bg = "NONE" },
				StatusLine = { bg = "overlay", fg = "text" },
				StatusLineNC = { bg = "surface", fg = "muted" },

				-- Pmenu / Completion
				Pmenu = { bg = "NONE", fg = "text" },
				PmenuSel = { bg = "overlay", fg = "rose", bold = true },
				CmpItemAbbr = { fg = "text" },
				CmpItemAbbrMatch = { fg = "rose", bold = true },
				CmpItemAbbrMatchFuzzy = { fg = "rose", bold = true },
				CmpItemMenu = { fg = "muted" },
				CmpItemKindFunction = { fg = "rose" },
				CmpItemKindVariable = { fg = "foam" },
				CmpItemKindClass = { fg = "gold" },
				CmpItemKindInterface = { fg = "gold" },
				CmpItemKindModule = { fg = "iris" },
				CmpItemKindKeyword = { fg = "pine" },
				CmpItemKindSnippet = { fg = "iris" },

				-- Telescope / FzfLua
				FzfLuaPointer = { fg = "iris" },

				-- Neo-tree
				NeoTreeNormal = { bg = "base" },
				NeoTreeNormalNC = { bg = "base" },
				NeoTreeWinSeparator = { fg = "base", bg = "base" },
				NeoTreeCursorLine = { bg = "overlay" },
				NeoTreeGitAdded = { fg = "foam" },
				NeoTreeGitModified = { fg = "rose" },
				NeoTreeGitDeleted = { fg = "love" },
				NeoTreeGitUntracked = { fg = "iris" },

				-- Diagnostics
				DiagnosticVirtualTextError = { fg = "love", bg = "love", blend = 15 },
				DiagnosticVirtualTextWarn = { fg = "gold", bg = "gold", blend = 15 },
				DiagnosticVirtualTextInfo = { fg = "foam", bg = "foam", blend = 15 },
				DiagnosticVirtualTextHint = { fg = "iris", bg = "iris", blend = 15 },

				-- Git signs
				GitSignsAdd = { fg = "foam" },
				GitSignsChange = { fg = "rose" },
				GitSignsDelete = { fg = "love" },

				-- Indent blankline
				IblIndent = { fg = "overlay" },
				IblScope = { fg = "highlight_high" },
			},
		})
	end,
}

return M
