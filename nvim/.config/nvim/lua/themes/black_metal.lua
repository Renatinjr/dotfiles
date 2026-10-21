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

-- Black Metal (metalelf0/black-metal-theme-neovim) — sixteen near-monochrome
-- bands, one per record.
--
-- Read live off the plugin, the way kanso() is: `black-metal.palette` is a pure
-- module whose `get(theme, variant)` hands back a deepcopy without any setup()
-- or colorscheme load, so there is nothing to transcribe and the sixteen bands
-- cost one builder. Returns {} when the plugin isn't in memory yet — M.build()
-- substitutes koda's palette for that, and config.theme.switcher rebuilds from
-- its ColorSchemePre hook once lazy has loaded the plugin.

-- ══════════════════════════════════════════════════════════════════════
-- Semantic ramp
--
-- One meaning, one color — in the buffer and in the chrome alike. Both the
-- tables below and the `highlights` overrides in M.spec are fed from here, so a
-- warning in the gutter, in the tabline, in the tree and in the completion menu
-- are the same color.
--
-- It has to be defined rather than read off the band palette, because upstream's
-- diagnostic colors cannot carry five meanings:
--
--   diag_red    #5f8787  ┐ the same teal, so Error and Warn are indistinguishable
--   diag_yellow #5f8787  ┘
--   diag_blue   #999999  ┐ the same grey, so Info and Hint are indistinguishable
--                        ┘ (DiagnosticHint and DiagnosticInfo both use it)
--   diag_green  #6e4c4c    a desaturated RED, and it is what GitSignsAdd uses
--
-- This file used to sidestep that by pointing the chrome at the two per-band
-- accents (error = `type`, warning = `string`) while the buffer kept the broken
-- diag_* colors. That left the two halves disagreeing, and the accent mapping
-- was itself arbitrary: `string` is the red one on impaled-nazarene (#DC2A22),
-- thyrfing and venom, so "error" rendered gold and "warning" red on those bands,
-- and on darkthrone both accents are #FFFFFF, which collapsed the pair entirely.
--
-- So the ramp is fixed across all sixteen bands — every grey and every diag_* in
-- this palette already is (only `string`, `type` and `alt_bg` vary), so this is
-- the one part of the theme that was never per-band to begin with. The bands go
-- on identifying themselves through their accents in the decorative slots below
-- (titles, prompts, the selected tab, the dashboard, rainbow delimiters, syntax).
--
-- Ratios are measured against the #000000 background; 4.5:1 is the WCAG AA floor
-- for text, and every pair is separated by either 60°+ of hue or 1.35x+ of
-- lightness so none of them reads as another.
local SEMANTIC = {
	error = "#BC554E", -- 4.55:1 · H4   S45 L52
	warn = "#B18B3E", -- 6.63:1 · H40  S48 L47
	info = "#999999", -- 7.37:1 · upstream `diag_blue`, the house grey
	hint = "#5F8787", -- 5.30:1 · upstream `alt`, the house teal
	ok = "#71A85D", -- 7.46:1 · H104 S30 L51
}

-- Chrome greys that are derived rather than named by the palette.
--
-- All sixteen bands share one very flat grey ramp — bg #000000, visual #222222,
-- comment #505050 and nothing in between — so these are literals, and this table
-- is the single source for both M.palette() and the `highlights` table in
-- M.spec, which used to repeat the same hex by hand in nine places.
--
-- `border` and `dim` are lifted to the floors the rest of this config is tuned
-- to (see lua/themes/koda.lua: a border is a meaningful UI line and wants the
-- 3:1 floor, dim sits just under it). Blending the comment grey DOWN toward the
-- background, as this file used to, put them at 1.79:1 and 2.16:1 — a float
-- border you cannot actually see.
local GREY = {
	border = "#656565", -- 3.60:1 · floats, separators, indent scope
	dim = "#5A5A5A", -- 3.05:1 · secondary text
	indent = "#242424", -- 1.35:1 · indent guide, deliberately below the text floor
	context = "#0E0E0E", -- treesitter-context, a fraction of `visual`
}

-- Tinted wash behind diagnostic virtual text, at the same 0.12 the other themes
-- in this config use (lua/themes/material.lua, kanagawa.lua).
local function wash(color)
	return lib.blend(color, "#000000", 0.12)
end

function M.palette(band)
	local ok, p = pcall(function()
		return require("black-metal.palette").get(band or "bathory", "dark")
	end)
	if not ok or type(p) ~= "table" or not p.bg then
		return {}
	end

	-- The two per-band accents. Decorative only: they are what tells the sixteen
	-- bands apart, so they carry titles, prompts, pointers, the dashboard and the
	-- loud end of the completion menu — never a diagnostic or a git state, which
	-- come from SEMANTIC above.
	local accent = p.string
	local accent2 = p.type

	-- Chrome surfaces. `line` is #000000 on every band, i.e. the buffer
	-- background, so `visual` is the only real second surface.
	local surface = p.visual
	-- Darkthrone is the one band whose alt_bg IS the background (#000000), so the
	-- selected tab falls back to the second surface rather than vanishing.
	local tab_bg = p.alt_bg ~= p.bg and p.alt_bg or surface

	return {
		bg = p.bg,
		bg_sec = surface,
		bg_notify = surface,
		text = p.fg,
		text_sec = GREY.dim,
		inlay_hint_bg = surface,
		inlay_hint_fg = p.comment,

		fzf = {
			setup_colors = function()
				local highlights = {
					-- bg "NONE" rather than the palette's background: the
					-- picker is a float over a transparent editor.
					FzfLuaNormal = { bg = "NONE", fg = p.fg },
					FzfLuaBorder = { fg = GREY.border, bg = "NONE" },
					FzfLuaCursorLine = { bg = surface, fg = accent },
					FzfLuaTitle = { fg = accent2, bold = true },
					FzfLuaPrompt = { fg = accent, bold = true },
					FzfLuaPointer = { fg = accent2, bold = true },
					FzfLuaMarker = { fg = SEMANTIC.hint },
					FzfLuaSpinner = { fg = accent, bold = true },
					FzfLuaHeader = { fg = GREY.dim },
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
			shortcut = SEMANTIC.hint,
		},

		indent = {
			line = GREY.indent,
			-- A scope guide is a meaningful UI line, so it takes the border floor
			-- rather than the sub-threshold grey above — same split as koda.
			scope = GREY.border,
		},

		-- blink.cmp menu palette (plugins/coding/completion.lua). The keys are
		-- generic hue slots that the kind table maps onto: `func` is
		-- methods/functions, `gold` the data members, `cyan` the types, `blue`
		-- modules, `info` variables and files, `pink` keywords and operators,
		-- `green` snippets, `orange` events.
		--
		-- With only two band accents the old mapping had each one doing three jobs
		-- (blue = gold = string, and red = orange = func), which left types and
		-- snippets, and data members and modules, sharing a color. The greys that
		-- every band carries — property, constant, operator — separate them, and
		-- the three slots with a meaning take it from SEMANTIC.
		blink = {
			fg = p.fg,
			func = accent2,
			gold = accent,
			string = accent,
			cyan = SEMANTIC.hint,
			blue = p.operator,
			info = p.constant,
			pink = p.property,
			green = SEMANTIC.ok,
			orange = SEMANTIC.warn,
			red = SEMANTIC.error,
			comment = p.comment,
			dim = GREY.dim,
			line = surface,
		},

		nvim_tree = lib.make_nvim_tree({
			-- The colorscheme runs `transparent = true`, so the tree's own window
			-- backgrounds fall through to the terminal like Normal does.
			transparent = true,
			bg = p.bg,
			fg = p.fg,
			comment = p.comment,
			border = GREY.border,
			sel_bg = surface,
			accent = accent2,
			-- Folders keep the palette's structure grey: this theme's `info` is
			-- itself a grey, and #aaaaaa reads better for a name you scan all day.
			folder = p.constant,
			special = accent,
			-- Same slot semantics as every other theme here (koda, kanagawa).
			symlink = SEMANTIC.hint,
			modified = SEMANTIC.warn,
			git_new = SEMANTIC.ok,
			git_dirty = SEMANTIC.warn,
			git_staged = SEMANTIC.ok,
			git_renamed = SEMANTIC.hint,
			git_deleted = SEMANTIC.error,
			-- A conflict wants the loudest thing on screen, and the band's own
			-- accent is it — this is the one git state with no slot in the ramp.
			git_merge = accent2,
		}),

		incline = {
			normal = { bg = surface, fg = p.fg },
			border = { bg = p.bg, fg = p.bg },
			normal_nc = { bg = surface, fg = GREY.dim },
			focused = { one = surface, two = surface },
			file_name = { guifg = p.fg },
			modified = { guifg = SEMANTIC.warn },
		},

		-- The selected tab is the one place the band's own tinted background
		-- (`alt_bg` — #3E2018 for bathory, #39121b for khold) earns its keep:
		-- it is the only color that tells the sixteen bands apart at a glance.
		bufferline = {
			fill = { fg = p.bg, bg = p.bg },
			background = { fg = GREY.dim, bg = p.bg },
			tab = { fg = GREY.dim, bg = p.bg },
			tab_selected = { fg = p.fg, bg = tab_bg, bold = true },
			tab_close = { fg = GREY.dim, bg = p.bg },
			close_button = { fg = SEMANTIC.error, bg = p.bg },
			close_button_visible = { fg = SEMANTIC.error, bg = p.bg },
			close_button_selected = { fg = SEMANTIC.error, bg = tab_bg },
			buffer_visible = { fg = GREY.dim, bg = p.bg },
			buffer_selected = { fg = p.fg, bg = tab_bg, bold = true, italic = false },
			numbers = { fg = SEMANTIC.hint, bg = p.bg },
			numbers_visible = { fg = SEMANTIC.hint, bg = p.bg },
			numbers_selected = { fg = SEMANTIC.hint, bg = tab_bg, bold = true, italic = false },
			diagnostic = { fg = GREY.dim, bg = p.bg },
			diagnostic_visible = { fg = GREY.dim, bg = p.bg },
			diagnostic_selected = { fg = p.fg, bg = tab_bg, bold = true, italic = false },
			hint = { fg = SEMANTIC.hint, bg = p.bg },
			hint_visible = { fg = SEMANTIC.hint, bg = p.bg },
			hint_selected = { fg = SEMANTIC.hint, bg = tab_bg, bold = true, italic = false },
			hint_diagnostic = { fg = SEMANTIC.hint, bg = p.bg },
			hint_diagnostic_visible = { fg = SEMANTIC.hint, bg = p.bg },
			hint_diagnostic_selected = { fg = SEMANTIC.hint, bg = tab_bg, bold = true, italic = false },
			info = { fg = SEMANTIC.info, bg = p.bg },
			info_visible = { fg = SEMANTIC.info, bg = p.bg },
			info_selected = { fg = SEMANTIC.info, bg = tab_bg, bold = true, italic = false },
			info_diagnostic = { fg = SEMANTIC.info, bg = p.bg },
			info_diagnostic_visible = { fg = SEMANTIC.info, bg = p.bg },
			info_diagnostic_selected = { fg = SEMANTIC.info, bg = tab_bg, bold = true, italic = false },
			warning = { fg = SEMANTIC.warn, bg = p.bg },
			warning_visible = { fg = SEMANTIC.warn, bg = p.bg },
			warning_selected = { fg = SEMANTIC.warn, bg = tab_bg, bold = true, italic = false },
			warning_diagnostic = { fg = SEMANTIC.warn, bg = p.bg },
			warning_diagnostic_visible = { fg = SEMANTIC.warn, bg = p.bg },
			warning_diagnostic_selected = { fg = SEMANTIC.warn, bg = tab_bg, bold = true, italic = false },
			error = { fg = SEMANTIC.error, bg = p.bg },
			error_visible = { fg = SEMANTIC.error, bg = p.bg },
			error_selected = { fg = SEMANTIC.error, bg = tab_bg, bold = true, italic = false },
			error_diagnostic = { fg = SEMANTIC.error, bg = p.bg },
			error_diagnostic_visible = { fg = SEMANTIC.error, bg = p.bg },
			error_diagnostic_selected = { fg = SEMANTIC.error, bg = tab_bg, bold = true, italic = false },
			modified = { fg = SEMANTIC.warn, bg = p.bg },
			modified_visible = { fg = SEMANTIC.warn, bg = p.bg },
			modified_selected = { fg = SEMANTIC.warn, bg = tab_bg },
			duplicate = { fg = p.comment, bg = p.bg, italic = true },
			duplicate_visible = { fg = p.comment, bg = p.bg, italic = true },
			duplicate_selected = { fg = p.fg, bg = tab_bg, italic = false },
			separator = { fg = GREY.border, bg = p.bg },
			separator_visible = { fg = GREY.border, bg = p.bg },
			separator_selected = { fg = GREY.border, bg = tab_bg },
			indicator_selected = { fg = accent2, bg = tab_bg },
			pick_selected = { fg = accent, bg = tab_bg, bold = true, italic = false },
			pick_visible = { fg = accent, bg = p.bg, bold = true, italic = false },
			pick = { fg = accent, bg = p.bg, bold = true, italic = false },
		},
	}
end

-- ══════════════════════════════════════════════════════════════════════
-- Black Metal (available via :colorscheme <band> — bathory, khold, mayhem…)
--
-- Sixteen bands, each a two-accent variation on one near-monochrome base.
-- M.palette() reads them live through `black-metal.palette`; the registry
-- (config/theme/init.lua) has one entry per band, so :Theme lists them all.
--
-- The colorscheme names are the BARE band name (`:colorscheme khold`); there
-- is no `black-metal-*` prefix and no `black-metal` scheme at all.
M.spec = {
	"metalelf0/black-metal-theme-neovim",
	lazy = true,
	priority = 1000,
	config = function()
		local opts = {
			-- ── Band + variant ──────────────────────────────────────────
			-- `theme` is only the fallback band: every registry entry loads
			-- its own through :colorscheme, which calls load(<band>) and
			-- overwrites this.
			theme = "bathory",
			variant = "dark",
			-- "there is no light in trve black metal" — leaving this true
			-- makes the plugin refuse the light palettes (and warn), which is
			-- why no `-light` entries are registered in config/theme/init.lua.
			trve = true,
			-- Each band's tinted background (bathory #3E2018, khold #39121b)
			-- instead of pure black. Off here: the tint is used for the
			-- selected tab in M.palette()'s bufferline table instead, where it
			-- distinguishes the bands without lifting the whole editor.
			alt_bg = false,

			-- ── Background ──────────────────────────────────────────────
			transparent = true, -- like koda / kanso / rose-pine
			-- Floats set no background of their own. Required alongside
			-- `transparent`: FloatBorder is NOT transparency-aware upstream,
			-- so without this every bordered float gets a black ring.
			plain_float = true,
			-- Both off for the same reason — they paint the cursor line's
			-- gutter cell and the whole signcolumn with an opaque `line`
			-- (#000000 on every band), which would punch a black column
			-- through the transparency.
			cursorline_gutter = false,
			dark_gutter = false,
			show_eob = false, -- hide the trailing `~` filler lines
			term_colors = true,

			-- Docstrings read as strings rather than comments.
			colored_docstrings = true,
			-- Leave the LSP's semantic tokens on top of treesitter, which is
			-- what every other theme here assumes.
			favor_treesitter_hl = false,
			-- Light is disabled by `trve`, so there is nothing to toggle.
			toggle_variant_key = nil,

			-- ── Diagnostics ─────────────────────────────────────────────
			-- `background` still applies to the plugin's own virtual-text
			-- groups; the overrides below restate them so the wash follows the
			-- ramp rather than diag_*.
			diagnostics = {
				darker = true,
				undercurl = true,
				background = true,
			},

			-- ── Syntax styles ───────────────────────────────────────────
			-- gui attribute strings, not booleans. `constants` is read by the
			-- plugin but missing from its defaults table, so it is spelled
			-- out here rather than left nil.
			code_style = {
				comments = "italic",
				conditionals = "bold",
				constants = "none",
				functions = "bold",
				headings = "bold",
				keyword_return = "bold,italic",
				keywords = "italic",
				operators = "none",
				strings = "none",
				variables = "none",
			},

			-- ── Plugin appearance ───────────────────────────────────────
			plugin = {
				-- Inert: the statusline here is heirline. (The plugin's own
				-- lualine theme module is broken upstream anyway — it
				-- requires a file that isn't in the repo.)
				lualine = { bold = true, plain = false },
				cmp = { plain = false, reverse = false },
			},

			-- Palette stays upstream; the highlights below reach into it
			-- with `$name` references so every band stays correct.
			colors = {},

			-- ── Custom highlights ───────────────────────────────────────
			-- Shape is `{ fg, bg, sp, fmt }` with `fmt` as a gui-attribute
			-- STRING and `$name` resolving against the band's palette — not
			-- the nvim_set_hl attribute tables the other specs in this file
			-- use. Applied last, after the theme's own groups.
			--
			-- Two kinds of entry here:
			--   * `$name` where the value must follow the band (its accents,
			--     and the greys the palette already names).
			--   * SEMANTIC/GREY where it must NOT — the ramp and the derived
			--     greys are the same on all sixteen bands, and sharing the
			--     tables with M.palette() above is what keeps the buffer and
			--     the chrome from drifting apart.
			highlights = {
				-- ── Diagnostics ─────────────────────────────────────
				-- Restated, not extended: upstream paints Error and Warn the
				-- same teal and Info and Hint the same grey (see the note on
				-- SEMANTIC), so four severities arrive as two colors.
				DiagnosticError = { fg = SEMANTIC.error },
				DiagnosticWarn = { fg = SEMANTIC.warn },
				DiagnosticInfo = { fg = SEMANTIC.info, fmt = "italic" },
				DiagnosticHint = { fg = SEMANTIC.hint },
				DiagnosticOk = { fg = SEMANTIC.ok },

				-- DiagnosticSign*/Floating* link to these by Neovim default,
				-- so the signcolumn (config/statuscolumn.lua) follows.
				DiagnosticVirtualTextError = { fg = SEMANTIC.error, bg = wash(SEMANTIC.error) },
				DiagnosticVirtualTextWarn = { fg = SEMANTIC.warn, bg = wash(SEMANTIC.warn) },
				DiagnosticVirtualTextInfo = { fg = SEMANTIC.info, bg = wash(SEMANTIC.info) },
				DiagnosticVirtualTextHint = { fg = SEMANTIC.hint, bg = wash(SEMANTIC.hint) },
				DiagnosticVirtualTextOk = { fg = SEMANTIC.ok, bg = wash(SEMANTIC.ok) },

				DiagnosticUnderlineError = { sp = SEMANTIC.error, fmt = "undercurl" },
				DiagnosticUnderlineWarn = { sp = SEMANTIC.warn, fmt = "undercurl" },
				DiagnosticUnderlineInfo = { sp = SEMANTIC.info, fmt = "undercurl" },
				DiagnosticUnderlineHint = { sp = SEMANTIC.hint, fmt = "undercurl" },
				DiagnosticUnderlineOk = { sp = SEMANTIC.ok, fmt = "undercurl" },

				DiagnosticUnnecessary = { fg = "$comment", fmt = "italic" },
				DiagnosticDeprecated = { fg = "$comment", fmt = "strikethrough" },

				-- ── Git ─────────────────────────────────────────────
				-- Upstream points GitSignsAdd at `diag_green`, which is
				-- #6e4c4c — a red — and GitSignsDelete at the teal. Same ramp
				-- as the tree and the tabline now.
				GitSignsAdd = { fg = SEMANTIC.ok },
				GitSignsAddLn = { fg = SEMANTIC.ok },
				GitSignsAddNr = { fg = SEMANTIC.ok },
				GitSignsAddCul = { fg = SEMANTIC.ok, bg = "$line" },
				GitSignsChange = { fg = SEMANTIC.warn },
				GitSignsChangeLn = { fg = SEMANTIC.warn },
				GitSignsChangeNr = { fg = SEMANTIC.warn },
				GitSignsChangeCul = { fg = SEMANTIC.warn, bg = "$line" },
				GitSignsDelete = { fg = SEMANTIC.error },
				GitSignsDeleteLn = { fg = SEMANTIC.error },
				GitSignsDeleteNr = { fg = SEMANTIC.error },
				GitSignsDeleteCul = { fg = SEMANTIC.error, bg = "$line" },

				-- Diff washes, from the same three colors.
				DiffAdd = { bg = wash(SEMANTIC.ok) },
				DiffChange = { bg = wash(SEMANTIC.warn) },
				DiffDelete = { bg = wash(SEMANTIC.error) },
				DiffText = { fg = "$fg", bg = lib.blend(SEMANTIC.warn, "#000000", 0.28) },

				-- ── Comment tags ────────────────────────────────────
				-- `Todo` is plain upstream and @comment.todo is absent
				-- entirely, so TODOs vanish into the comment grey. The four
				-- severities take the ramp so a NOTE/WARNING/ERROR in a
				-- comment matches the diagnostic of the same name.
				Todo = { fg = "$bg", bg = "$type", fmt = "bold" },
				["@comment.todo"] = { fg = "$bg", bg = "$type", fmt = "bold" },
				["@comment.note"] = { fg = "$bg", bg = SEMANTIC.info, fmt = "bold" },
				["@comment.warning"] = { fg = "$bg", bg = SEMANTIC.warn, fmt = "bold" },
				["@comment.error"] = { fg = "$bg", bg = SEMANTIC.error, fmt = "bold" },

				-- ── Chrome ──────────────────────────────────────────
				-- Inlay hints (config/options.lua and the theme switcher
				-- re-emit this one too, from the same palette).
				LspInlayHint = { fg = "$comment", bg = "$visual", fmt = "italic" },

				-- Word under cursor: the theme ships LspReference* but not
				-- vim-illuminate's groups.
				IlluminatedWordText = { bg = "$visual" },
				IlluminatedWordRead = { bg = "$visual" },
				IlluminatedWordWrite = { bg = "$visual", fmt = "underline" },

				-- Transparency. The theme runs `transparent = true`, but the
				-- plugin still paints these two with `line` (#000000 on every
				-- band), so Mason's and Lazy's windows came out as solid black
				-- panels over a see-through editor.
				MasonNormal = { bg = "none" },
				LazyNormal = { bg = "none" },

				-- fzf-lua. M.palette() feeds the picker the same values
				-- at setup time; repeating them here keeps it correct after a
				-- later :colorscheme reload.
				FzfLuaNormal = { fg = "$fg", bg = "none" },
				FzfLuaBorder = { fg = GREY.border, bg = "none" },
				FzfLuaCursorLine = { fg = "$string", bg = "$visual" },
				FzfLuaTitle = { fg = "$type", fmt = "bold" },
				FzfLuaPrompt = { fg = "$string", fmt = "bold" },
				FzfLuaPointer = { fg = "$type", fmt = "bold" },
				FzfLuaMarker = { fg = SEMANTIC.hint },
				FzfLuaSpinner = { fg = "$string", fmt = "bold" },
				FzfLuaHeader = { fg = GREY.dim },
				FzfLuaPreviewTitle = { fg = "$type", fmt = "bold" },

				-- treesitter-context
				TreesitterContext = { bg = GREY.context },
				TreesitterContextLineNumber = { fg = "$comment", bg = GREY.context },
				TreesitterContextBottom = { sp = GREY.border, fmt = "underline" },

				-- which-key
				WhichKey = { fg = "$type" },
				WhichKeyDesc = { fg = "$fg" },
				WhichKeyGroup = { fg = "$constant" },
				WhichKeySeparator = { fg = "$comment" },
				WhichKeyBorder = { fg = GREY.border },
				WhichKeyTitle = { fg = "$string", fmt = "bold" },

				-- noice
				NoiceCmdlinePopupBorder = { fg = GREY.border },
				NoiceCmdlineIcon = { fg = "$type" },
				NoiceConfirmBorder = { fg = GREY.border },

				-- nvim-notify: a notification's level is a severity, so it
				-- takes the ramp rather than the band accents.
				NotifyERRORBorder = { fg = SEMANTIC.error },
				NotifyERRORIcon = { fg = SEMANTIC.error },
				NotifyERRORTitle = { fg = SEMANTIC.error },
				NotifyWARNBorder = { fg = SEMANTIC.warn },
				NotifyWARNIcon = { fg = SEMANTIC.warn },
				NotifyWARNTitle = { fg = SEMANTIC.warn },
				NotifyINFOBorder = { fg = SEMANTIC.info },
				NotifyINFOIcon = { fg = SEMANTIC.info },
				NotifyINFOTitle = { fg = SEMANTIC.info },
				NotifyDEBUGBorder = { fg = "$comment" },
				NotifyDEBUGIcon = { fg = "$comment" },
				NotifyDEBUGTitle = { fg = "$comment" },
				NotifyTRACEBorder = { fg = SEMANTIC.hint },
				NotifyTRACEIcon = { fg = SEMANTIC.hint },
				NotifyTRACETitle = { fg = SEMANTIC.hint },

				-- rainbow-delimiters: six slots out of a palette with two
				-- accents, so the greys carry the rest of the cycle. Purely
				-- decorative — the names are slots, not meanings, which is why
				-- these keep pointing at the band rather than at the ramp.
				RainbowDelimiterRed = { fg = "$type" },
				RainbowDelimiterYellow = { fg = "$string" },
				RainbowDelimiterBlue = { fg = "$alt" },
				RainbowDelimiterOrange = { fg = "$constant" },
				RainbowDelimiterGreen = { fg = "$keyword" },
				RainbowDelimiterViolet = { fg = "$operator" },
			},
		}

		-- Every colors/<band>.lua is `setup({})` followed by `load(<band>)`,
		-- and setup() rebuilds its options from black-metal.config.default —
		-- so a plain :colorscheme, or one keystroke of the :Theme picker's
		-- live preview, would reset everything above to plugin defaults
		-- (only `trve` is sticky upstream). Folding the options into that
		-- defaults table makes the reset reproduce them instead. Guarded:
		-- if the module is ever reshaped the theme just loads with its own
		-- defaults rather than erroring.
		local ok, bm_config = pcall(require, "black-metal.config")
		if ok and type(bm_config.default) == "table" then
			bm_config.default = vim.tbl_deep_extend("force", bm_config.default, opts)
		end

		require("black-metal").setup(opts)
	end,
}

return M
