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

function M.palette()
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

		nvim_tree = lib.make_nvim_tree({
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

function M.background()
	return EVERGARDEN_VARIANT == "summer" and "light" or "dark"
end

-- Evergarden (available via :colorscheme evergarden, or evergarden-<variant>)
--
-- Variant + accent are the EVERGARDEN_* constants above, so the plugin and
-- M.palette() agree. evergarden
-- ships broad coverage of its own — editor, syntax, treesitter, diagnostics
-- (incl. blended virtual text), semantic tokens and per-plugin groups — so the
-- `overrides` below only fill the gaps and the few places this config is
-- opinionated.
M.spec = {
	"everviolet/nvim",
	name = "evergarden",
	lazy = true,
	priority = 1000,
	config = function()
		require("evergarden").setup({
			theme = {
				variant = EVERGARDEN_VARIANT, -- winter | fall | spring | summer | lunar
				accent = EVERGARDEN_ACCENT,
				ansi = false,
			},

			editor = {
				transparent_background = false,
				override_terminal = true,
				cursor = { color = "accent" },
				sign = { color = "none" }, -- signcolumn keeps the editor bg
				float = {
					color = "mantle", -- floats/sidebars one step below the buffer
					solid_border = false,
				},
				completion = {
					color = "mantle",
					selected = { color = "surface0", style = { "bold" } },
				},
				statusline = {
					active = { fg = "subtext0", bg = "surface0" },
					inactive = { fg = "overlay1", bg = "mantle" },
				},
			},

			-- Style lists, not booleans: each entry is a gui attribute name.
			style = {
				tabline = { "reverse" },
				search = { "italic", "reverse" },
				incsearch = { "reverse" },
				diagnostics = { "undercurl" },
				types = { "italic" },
				keyword = { "italic" },
				comment = { "italic" },
				spell = { "undercurl" },
				notes = { "bold", "reverse" },
				disable_styles = {},
			},

			-- Every integration defaults to ON; switch off what isn't installed
			-- so startup isn't spent building highlight tables nothing reads.
			integrations = {
				artio = false,
				blink_cmp = true,
				bqf = false,
				cmp = false, -- blink.cmp is the engine here
				fzf_lua = true,
				gitsigns = true,
				indent_blankline = { enable = true, scope_color = "surface2" },
				lualine = false, -- statusline is heirline
				markit = false,
				mini = { enable = true, icons = true },
				neotree = false,
				nvimtree = true,
				rainbow_delimiters = true,
				semantic_tokens = true,
				symbols_outline = false,
				telescope = false,
				which_key = true,
			},

			color_overrides = {},

			-- Function form: evergarden hands us the resolved theme, so these
			-- track whichever variant is active.
			overrides = function(t)
				local blend = require("evergarden.utils").blend

				return {
					-- Accented, bold current line number (evergarden dims it to overlay2)
					CursorLineNr = { fg = t.accent, style = { "bold" } },
					EndOfBuffer = { fg = t.base },
					MatchParen = { fg = t.accent, bg = t.surface1, style = { "bold" } },

					-- Inlay hints get a chip background, matching config/options.lua
					LspInlayHint = { fg = t.overlay1, bg = t.surface0, style = { "italic" } },

					-- Word under cursor: evergarden links read/write to the plain
					-- reference group, and doesn't ship the illuminate groups.
					LspReferenceWrite = { bg = t.surface1, style = { "underline" } },
					IlluminatedWordText = { bg = t.surface0 },
					IlluminatedWordRead = { bg = t.surface0 },
					IlluminatedWordWrite = { bg = t.surface1, style = { "underline" } },

					-- treesitter-context (no integration upstream)
					TreesitterContext = { bg = t.surface0 },
					TreesitterContextLineNumber = { fg = t.overlay0, bg = t.surface0 },
					TreesitterContextBottom = { sp = t.surface2, style = { "underline" } },

					-- noice (no integration upstream)
					NoiceCmdlinePopupBorder = { fg = t.surface1 },
					NoiceCmdlineIcon = { fg = t.accent },
					NoiceConfirmBorder = { fg = t.surface1 },
					NoiceVirtualtextSearch = { fg = t.editor.incsearch },

					-- fzf-lua: upstream links these to the mini.pick groups. This
					-- config drives the picker through explicit FzfLua* colors
					-- (M.palette above), so state them here too and a reload keeps them.
					FzfLuaNormal = { fg = t.text, bg = t.mantle },
					FzfLuaBorder = { fg = t.surface1, bg = t.mantle },
					FzfLuaCursorLine = { fg = t.accent, bg = t.surface0 },
					FzfLuaTitle = { fg = t.blue, style = { "bold" } },
					FzfLuaPrompt = { fg = t.purple, style = { "bold" } },
					FzfLuaPointer = { fg = t.purple, style = { "bold" } },
					FzfLuaMarker = { fg = t.green },
					FzfLuaSpinner = { fg = t.accent, style = { "bold" } },
					FzfLuaHeader = { fg = t.overlay1 },
					FzfLuaPreviewTitle = { fg = t.purple, style = { "bold" } },

					-- Diff washes, a touch stronger than the default fills
					DiffAdd = { fg = t.diff.add, bg = blend(t.diff.add, t.base, 0.15) },
					DiffChange = { fg = t.diff.change, bg = blend(t.diff.change, t.base, 0.12) },
					DiffDelete = { fg = t.diff.delete, bg = blend(t.diff.delete, t.base, 0.15) },
					DiffText = { fg = t.diff.change, bg = blend(t.diff.change, t.base, 0.28) },
				}
			end,

			cache = true, -- compile the highlight table; cleared on config change
		})
	end,
}

return M
