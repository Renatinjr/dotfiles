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
	keyword = "#666f70", -- L*64 · 5.50:1 · subtle violet tint
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
function M.palette(variant)
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

		-- blink.cmp menu palette (consumed by plugins/coding/completion.lua). Previously
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

		nvim_tree = lib.make_nvim_tree({
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

-- Koda (available via :colorscheme koda-dark)
--
-- Palette overrides are KODA_DARK above, so the editor, nvim-tree, fzf-lua,
-- bufferline and the blink menu all read the same values. koda covers base/syntax/treesitter/LSP plus the plugins it detects
-- through lazy (`auto = true`); `on_highlights` below fills the gaps — the
-- plugins koda has no groups for, and the handful of defaults that are too
-- quiet to read at a glance.
M.spec = {
	"oskarnurm/koda.nvim",
	lazy = true,
	priority = 1000, -- ...and before every other start plugin, when it is the active one
	config = function()
		local koda = require("koda")
		koda.setup({
			transparent = true, -- Normal/StatusLine/Pmenu fall through to the terminal

			theme = {
				dark = "dark",
				light = "light",
			},

			auto = true, -- disable to load ALL available plugin highlights

			cache = true, -- caches the theme for better performance

			-- Attributes only. The constants color moved to KODA_DARK.const,
			-- which koda then applies everywhere `const` is used rather than to
			-- the constant syntax groups alone.
			styles = {
				functions = { bold = true },
				keywords = { italic = true },
				comments = { italic = true }, -- was bold, propping up a 2.56:1 comment color
				strings = { italic = true },
				constants = {}, -- includes numbers, booleans
			},

			-- Scoped to `dark`: koda's get_palette() applies a FLAT colors table to
			-- every variant, which would force this dark palette onto glade — koda's
			-- light one. moss and glade keep their own stock palettes.
			colors = { dark = KODA_DARK },

			-- (hl, c): `hl` is koda's finished highlight table, `c` the merged
			-- palette. This runs after the cache is read, so edits here take
			-- effect on the next :colorscheme without :KodaFetch.
			on_highlights = function(hl, c)
				local blend = koda.blend
				-- Muted grey between `fg` and the background, for the members and
				-- properties that would otherwise be as loud as plain variables.
				local muted = blend(c.fg, c.bg, 0.85)

				-- ── Editor chrome koda leaves at defaults ──────────────────
				hl.WinSeparator = { fg = c.line }
				hl.Folded = { fg = c.comment, bg = c.line }
				hl.FoldColumn = { fg = c.dim }
				hl.Conceal = { fg = c.dim }
				hl.Whitespace = { fg = c.line }
				hl.MsgSeparator = { fg = c.line }
				hl.FloatTitle = { fg = c.emphasis, bold = true }
				hl.TabLine = { fg = c.comment, bg = c.line }
				hl.TabLineFill = { bg = c.bg }
				-- koda links Search to Visual, i.e. the cursorline background —
				-- give matches their own contrast instead.
				hl.Search = { fg = c.emphasis, bg = c.dim }
				hl.CurSearch = { fg = c.bg, bg = c.const, bold = true }
				hl.IncSearch = { link = "CurSearch" }
				hl.MatchParen = { fg = c.special, bg = c.line, bold = true }
				-- koda aims CursorLineNr and Identifier at `special`. That key is now a
				-- bright NEUTRAL (it was pure white), which is right for MatchParen but
				-- leaves the cursor line number unaccented and renders plain identifiers
				-- brighter than body text in non-treesitter buffers. Split them out.
				hl.CursorLineNr = { fg = c.highlight, bold = true }
				hl.Identifier = { fg = c.fg }

				-- ── Syntax ─────────────────────────────────────────────────
				hl["@property"] = { fg = muted }
				hl["@variable.member"] = { fg = muted }
				hl["@variable.parameter"] = { fg = c.fg, italic = true }
				hl["@string.special.url"] = { fg = c.info, underline = true }
				hl["@markup.link.url"] = { fg = c.info, underline = true }
				-- Comment tags: koda tints todo but leaves the rest as comments.
				hl["@comment.todo"] = { fg = c.bg, bg = c.const, bold = true }
				hl["@comment.note"] = { fg = c.bg, bg = c.info, bold = true }
				hl["@comment.warning"] = { fg = c.bg, bg = c.warning, bold = true }
				hl["@comment.error"] = { fg = c.bg, bg = c.danger, bold = true }
				hl.Todo = { link = "@comment.todo" }

				-- ── Diagnostics ────────────────────────────────────────────
				-- koda gives Info the plain fg and Hint the info blue; split them
				-- so severity is readable at a glance.
				hl.DiagnosticInfo = { fg = c.info }
				hl.DiagnosticHint = { fg = c.cyan }
				for name, color in pairs({
					Error = c.danger,
					Warn = c.warning,
					Info = c.info,
					Hint = c.cyan,
				}) do
					hl["DiagnosticVirtualText" .. name] = { fg = color, bg = blend(color, c.bg, 0.12) }
					hl["DiagnosticUnderline" .. name] = { undercurl = true, sp = color }
				end
				hl.DiagnosticUnnecessary = { fg = c.dim, italic = true }
				hl.DiagnosticDeprecated = { fg = c.dim, strikethrough = true }

				-- ── LSP ────────────────────────────────────────────────────
				hl.LspInlayHint = { fg = c.comment, bg = c.line, italic = true }
				hl.LspSignatureActiveParameter = { fg = c.const, bold = true }
				hl.LspReferenceText = { bg = c.line }
				hl.LspReferenceRead = { bg = c.line }
				hl.LspReferenceWrite = { bg = c.line, underline = true }
				hl.IlluminatedWordText = { bg = c.line }
				hl.IlluminatedWordRead = { bg = c.line }
				hl.IlluminatedWordWrite = { bg = c.line, underline = true }

				-- ── Plugins koda has no groups for ─────────────────────────
				-- (nvim-tree, bufferline, incline and alpha are driven from
				-- M.palette() above; nvim-tree in particular has no koda support,
				-- only neo-tree.)
				hl.TreesitterContext = { bg = c.line }
				hl.TreesitterContextLineNumber = { fg = c.dim, bg = c.line }
				hl.TreesitterContextBottom = { sp = c.dim, underline = true }

				hl.IblIndent = { fg = c.line, nocombine = true }
				-- border, not dim: a scope guide is a meaningful UI line, so it wants
				-- the 3:1 floor (border 3.55:1) rather than dim's 2.98:1.
				hl.IblScope = { fg = c.border, nocombine = true }

				hl.NoiceCmdlinePopupBorder = { fg = c.border }
				hl.NoiceCmdlineIcon = { fg = c.highlight }
				hl.NoiceConfirmBorder = { fg = c.border }

				hl.WhichKey = { fg = c.highlight }
				hl.WhichKeyDesc = { fg = c.fg }
				hl.WhichKeyGroup = { fg = c.info }
				hl.WhichKeySeparator = { fg = c.comment }
				hl.WhichKeyBorder = { fg = c.border }
				hl.WhichKeyTitle = { fg = c.emphasis, bold = true }

				-- nvim-notify (koda only styles snacks.notifier)
				for name, color in pairs({
					ERROR = c.danger,
					WARN = c.warning,
					INFO = c.info,
					DEBUG = c.comment,
					TRACE = c.pink,
				}) do
					hl["Notify" .. name .. "Border"] = { fg = color }
					hl["Notify" .. name .. "Icon"] = { fg = color }
					hl["Notify" .. name .. "Title"] = { fg = color }
				end
			end,
		})
	end,
}

return M
