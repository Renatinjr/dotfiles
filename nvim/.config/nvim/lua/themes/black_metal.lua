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
function M.palette(band)
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
	local border = lib.blend(p.comment, p.bg, 0.7)
	local dim = lib.blend(p.comment, p.bg, 0.85)

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
			line = lib.blend(p.comment, p.bg, 0.45),
			scope = p.comment,
		},

		-- blink.cmp menu palette (plugins/coding/completion.lua). The keys are generic
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

		nvim_tree = lib.make_nvim_tree({
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
			diagnostics = {
				darker = true,
				undercurl = true,
				background = true, -- tinted wash behind virtual text
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
			-- Only gaps are filled here. The plugin already ships nvim-tree,
			-- gitsigns, diffview, blink/cmp kinds, indent-blankline,
			-- treesitter, LSP semantic tokens and diagnostics.
			--
			-- The greys are identical across all sixteen bands (bg #000000,
			-- visual #222222, comment #505050), so chrome can be literal hex
			-- and only the accents need `$string` / `$type` / `$alt`.
			highlights = {
				-- Diagnostics the plugin leaves undefined
				DiagnosticOk = { fg = "$diag_green" },
				DiagnosticUnnecessary = { fg = "$comment", fmt = "italic" },
				DiagnosticDeprecated = { fg = "$comment", fmt = "strikethrough" },

				-- Comment tags: `Todo` is plain, and @comment.todo is absent
				-- entirely, so TODOs vanish into the comment grey.
				Todo = { fg = "$bg", bg = "$type", fmt = "bold" },
				["@comment.todo"] = { fg = "$bg", bg = "$type", fmt = "bold" },
				["@comment.note"] = { fg = "$bg", bg = "$alt", fmt = "bold" },
				["@comment.warning"] = { fg = "$bg", bg = "$string", fmt = "bold" },
				["@comment.error"] = { fg = "$bg", bg = "$diag_red", fmt = "bold" },

				-- Inlay hints (config/options.lua and the theme switcher
				-- re-emit this one too, from the same palette).
				LspInlayHint = { fg = "$comment", bg = "#222222", fmt = "italic" },

				-- Word under cursor: the theme ships LspReference* but not
				-- vim-illuminate's groups.
				IlluminatedWordText = { bg = "#222222" },
				IlluminatedWordRead = { bg = "#222222" },
				IlluminatedWordWrite = { bg = "#222222", fmt = "underline" },

				-- fzf-lua. M.palette() feeds the picker the same values
				-- at setup time; repeating them here keeps it correct after a
				-- later :colorscheme reload.
				FzfLuaNormal = { fg = "$fg", bg = "$bg" },
				FzfLuaBorder = { fg = "#383838", bg = "$bg" },
				FzfLuaCursorLine = { fg = "$string", bg = "#222222" },
				FzfLuaTitle = { fg = "$type", fmt = "bold" },
				FzfLuaPrompt = { fg = "$string", fmt = "bold" },
				FzfLuaPointer = { fg = "$type", fmt = "bold" },
				FzfLuaMarker = { fg = "$alt" },
				FzfLuaSpinner = { fg = "$string", fmt = "bold" },
				FzfLuaHeader = { fg = "$comment" },
				FzfLuaPreviewTitle = { fg = "$type", fmt = "bold" },

				-- treesitter-context
				TreesitterContext = { bg = "#0D0D0D" },
				TreesitterContextLineNumber = { fg = "$comment", bg = "#0D0D0D" },
				TreesitterContextBottom = { sp = "#383838", fmt = "underline" },

				-- which-key
				WhichKey = { fg = "$type" },
				WhichKeyDesc = { fg = "$fg" },
				WhichKeyGroup = { fg = "$constant" },
				WhichKeySeparator = { fg = "$comment" },
				WhichKeyBorder = { fg = "#383838" },
				WhichKeyTitle = { fg = "$string", fmt = "bold" },

				-- noice
				NoiceCmdlinePopupBorder = { fg = "#383838" },
				NoiceCmdlineIcon = { fg = "$type" },
				NoiceConfirmBorder = { fg = "#383838" },

				-- nvim-notify
				NotifyERRORBorder = { fg = "$type" },
				NotifyERRORIcon = { fg = "$type" },
				NotifyERRORTitle = { fg = "$type" },
				NotifyWARNBorder = { fg = "$string" },
				NotifyWARNIcon = { fg = "$string" },
				NotifyWARNTitle = { fg = "$string" },
				NotifyINFOBorder = { fg = "$constant" },
				NotifyINFOIcon = { fg = "$constant" },
				NotifyINFOTitle = { fg = "$constant" },
				NotifyDEBUGBorder = { fg = "$comment" },
				NotifyDEBUGIcon = { fg = "$comment" },
				NotifyDEBUGTitle = { fg = "$comment" },
				NotifyTRACEBorder = { fg = "$alt" },
				NotifyTRACEIcon = { fg = "$alt" },
				NotifyTRACETitle = { fg = "$alt" },

				-- rainbow-delimiters: six slots out of a palette with two
				-- accents, so the greys carry the rest of the cycle.
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
