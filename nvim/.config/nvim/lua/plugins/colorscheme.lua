-- Colorschemes: koda, material, evergarden, kanso-zen, rose-pine, kanagawa,
-- jellybeans & black-metal (sixteen bands).
--
-- None of these specs picks the active scheme any more: config.theme holds the
-- registry and the persisted choice, and config.theme_switcher applies it (and
-- owns `background`). Switch with :Theme, <leader>uc, or plain :colorscheme.
return {
	-- ══════════════════════════════════════════════════════════════════════
	-- Material (available via :colorscheme material)
	--
	-- The style ("deep ocean" by default) lives in lua/config/theme.lua as
	-- `M.material_style`; it is pushed into `vim.g.material_style` here, before
	-- the colorscheme loads, so the plugin and theme.lua's palette agree. Use
	-- `:MaterialStyle <style>` (defined at the bottom of this block) to switch
	-- at runtime — it refreshes theme.current_theme too, so nvim-tree, fzf-lua,
	-- bufferline, incline and blink follow along.
	-- ══════════════════════════════════════════════════════════════════════
	{
		"marko-cerovac/material.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			local theme = require("config.theme")

			-- Must be set BEFORE material.colors is required: the palette module
			-- reads this global once and caches the result.
			vim.g.material_style = theme.material_style

			-- Mix two hex colors — used for the diagnostic virtual-text washes so
			-- they stay tinted against whichever style is active.
			local function blend(fg, bg, alpha)
				local function mix(i)
					local a = tonumber(fg:sub(i, i + 1), 16) * alpha
					local b = tonumber(bg:sub(i, i + 1), 16) * (1 - alpha)
					return math.floor(math.min(math.max(a + b, 0), 255) + 0.5)
				end
				return string.format("#%02X%02X%02X", mix(2), mix(4), mix(6))
			end

			require("material").setup({
				-- ── Contrast ────────────────────────────────────────────────
				-- Give the chrome (sidebars, floats, terminal) the darker
				-- `bg_alt` so panels read as separate surfaces from the buffer.
				contrast = {
					terminal = true,
					sidebars = true,
					floating_windows = true,
					cursor_line = false, -- keep CursorLine on `active`, not bg_alt
					lsp_virtual_text = true,
					non_current_windows = false,
					filetypes = { "NvimTree", "fzf", "qf", "help", "alpha", "dap-repl" },
				},

				-- ── Syntax styles ───────────────────────────────────────────
				styles = {
					comments = { italic = true },
					strings = {},
					keywords = { italic = true },
					functions = { bold = true },
					variables = {},
					operators = {},
					types = {},
				},

				-- ── Plugin integrations ─────────────────────────────────────
				-- Only the ones actually installed in this config; material warns
				-- loudly about unknown names, and every extra module is work at
				-- startup. nvim-tree is included for the groups theme.lua doesn't
				-- define (plugins/explorer.lua re-applies its own on ColorScheme).
				plugins = {
					"blink",
					"dap",
					"gitsigns",
					"indent-blankline",
					"mini",
					"noice",
					"nvim-notify",
					"nvim-tree",
					"nvim-web-devicons",
					"rainbow-delimiters",
					"which-key",
				},

				disable = {
					colored_cursor = false,
					borders = false,
					background = false, -- flip to true for a transparent editor
					term_colors = false,
					eob_lines = true, -- hide the trailing `~` filler lines
				},

				-- Only affects the "darker" / "lighter" styles.
				high_visibility = {
					lighter = false,
					darker = true,
				},

				lualine_style = "default",

				-- Synchronous: plugin + custom highlights must land BEFORE the
				-- ColorScheme autocmds in explorer.lua / completion.lua / fzf.lua
				-- run, otherwise the async pass would clobber them afterwards.
				async_loading = false,

				custom_colors = nil,

				-- ── Custom highlights ───────────────────────────────────────
				-- Function form: material hands us the resolved palette, so this
				-- table tracks whichever style is active.
				custom_highlights = function(c)
					local m, e, s, l, g = c.main, c.editor, c.syntax, c.lsp, c.git

					return {
						-- ══════════════════════════════════════════════
						-- EDITOR UI
						-- ══════════════════════════════════════════════
						CursorLineNr = { fg = e.accent, bold = true },
						LineNrAbove = { fg = e.line_numbers },
						LineNrBelow = { fg = e.line_numbers },
						SignColumn = { bg = e.bg },
						FoldColumn = { fg = e.line_numbers, bg = e.bg },
						Folded = { fg = s.comments, bg = e.active, italic = true },
						WinSeparator = { fg = e.border, bg = e.bg },
						StatusLine = { fg = e.fg, bg = e.active },
						StatusLineNC = { fg = e.disabled, bg = e.bg },
						ColorColumn = { bg = e.active },
						Conceal = { fg = e.disabled },
						Title = { fg = m.blue, bold = true },
						Directory = { fg = m.blue },
						ModeMsg = { fg = e.fg, bold = true },
						MoreMsg = { fg = m.cyan },
						Question = { fg = m.cyan },
						ErrorMsg = { fg = l.error, bold = true },
						WarningMsg = { fg = m.yellow },
						NonText = { fg = e.line_numbers },
						Whitespace = { fg = e.border },
						EndOfBuffer = { fg = e.bg },

						-- Tabs
						TabLine = { fg = s.comments, bg = e.bg_alt },
						TabLineSel = { fg = e.accent, bg = e.bg, bold = true },
						TabLineFill = { bg = e.bg_alt },

						-- Floats
						FloatBorder = { fg = e.border, bg = e.bg_alt },
						FloatTitle = { fg = m.blue, bg = e.bg_alt, bold = true },

						-- Popup menu
						Pmenu = { fg = e.fg, bg = e.bg_alt },
						PmenuSel = { fg = e.bg, bg = e.accent, bold = true },
						PmenuSbar = { bg = e.bg_alt },
						PmenuThumb = { bg = e.border },

						-- Selection / search / matching
						Visual = { bg = e.selection },
						VisualNOS = { bg = e.selection },
						Search = { fg = e.bg, bg = m.paleblue },
						IncSearch = { fg = e.bg, bg = m.yellow, bold = true },
						CurSearch = { fg = e.bg, bg = m.yellow, bold = true },
						Substitute = { fg = e.bg, bg = m.red },
						MatchParen = { fg = e.accent, bg = e.selection, bold = true },

						-- Word under cursor (LSP document highlight / illuminate)
						LspReferenceText = { bg = e.selection },
						LspReferenceRead = { bg = e.selection },
						LspReferenceWrite = { bg = e.selection, underline = true },
						IlluminatedWordText = { bg = e.selection },
						IlluminatedWordRead = { bg = e.selection },
						IlluminatedWordWrite = { bg = e.selection, underline = true },

						-- Inlay hints (config/options.lua also sets this on startup)
						LspInlayHint = { fg = e.disabled, bg = e.active, italic = true },

						-- ══════════════════════════════════════════════
						-- SYNTAX — material keeps most of this; these are
						-- the gaps and the deliberate deviations.
						-- ══════════════════════════════════════════════
						Comment = { fg = s.comments, italic = true },
						Operator = { fg = m.cyan },
						Delimiter = { fg = m.cyan },
						Underlined = { fg = e.link, underline = true },
						Todo = { fg = e.bg, bg = m.orange, bold = true },

						-- Parameters: material resolves a color for these but
						-- links them to Identifier, so set it explicitly.
						["@variable.parameter"] = { fg = s.parameter, italic = true },
						["@variable.builtin"] = { fg = m.red, italic = true },
						["@constructor"] = { fg = m.blue, bold = true },
						["@type.qualifier"] = { fg = m.cyan, italic = true },
						["@keyword.return"] = { fg = m.purple, italic = true, bold = true },
						["@keyword.exception"] = { fg = m.red, italic = true },
						["@string.special.url"] = { fg = e.link, underline = true },
						["@string.regexp"] = { fg = m.orange },
						["@character.special"] = { fg = m.cyan },

						-- Comments: material links todo straight to Comment, which
						-- makes TODOs disappear. Give the tags their own weight.
						["@comment.todo"] = { fg = e.bg, bg = m.orange, bold = true },
						["@comment.note"] = { fg = e.bg, bg = m.paleblue, bold = true },
						["@comment.warning"] = { fg = e.bg, bg = m.yellow, bold = true },
						["@comment.error"] = { fg = e.bg, bg = l.error, bold = true },
						["@comment.documentation"] = { fg = s.comments, italic = true },

						-- Markup (markdown, help)
						["@markup.heading.1"] = { fg = m.purple, bold = true },
						["@markup.heading.2"] = { fg = m.blue, bold = true },
						["@markup.heading.3"] = { fg = m.cyan, bold = true },
						["@markup.heading.4"] = { fg = m.green, bold = true },
						["@markup.heading.5"] = { fg = m.yellow, bold = true },
						["@markup.heading.6"] = { fg = m.orange, bold = true },
						["@markup.quote"] = { fg = s.comments, italic = true },
						["@markup.strikethrough"] = { strikethrough = true },
						["@markup.link.url"] = { fg = e.link, underline = true },

						-- ══════════════════════════════════════════════
						-- LSP SEMANTIC TOKENS
						-- ══════════════════════════════════════════════
						["@lsp.type.parameter"] = { fg = s.parameter, italic = true },
						["@lsp.type.variable"] = { fg = s.variable },
						["@lsp.type.property"] = { fg = e.fg_dark },
						["@lsp.type.function"] = { fg = s.fn, bold = true },
						["@lsp.type.method"] = { fg = s.fn, bold = true },
						["@lsp.type.macro"] = { fg = m.cyan },
						["@lsp.type.class"] = { fg = s.type },
						["@lsp.type.interface"] = { fg = s.type },
						["@lsp.type.struct"] = { fg = s.type },
						["@lsp.type.enum"] = { fg = s.type },
						["@lsp.type.enumMember"] = { fg = m.yellow },
						["@lsp.type.namespace"] = { fg = m.yellow },
						["@lsp.type.type"] = { fg = s.type },
						["@lsp.type.typeParameter"] = { fg = s.type, italic = true },
						["@lsp.type.keyword"] = { fg = s.keyword, italic = true },
						["@lsp.type.operator"] = { fg = s.operator },
						["@lsp.type.decorator"] = { fg = m.cyan },
						["@lsp.typemod.variable.readonly"] = { fg = m.yellow },
						["@lsp.typemod.variable.defaultLibrary"] = { fg = m.orange },
						["@lsp.typemod.function.defaultLibrary"] = { fg = s.fn, bold = true },
						["@lsp.typemod.keyword.controlFlow"] = { fg = s.keyword, italic = true, bold = true },
						-- Let treesitter keep these; the LSP versions are noisy.
						["@lsp.mod.readonly"] = {},
						["@lsp.mod.defaultLibrary"] = {},

						-- ══════════════════════════════════════════════
						-- DIAGNOSTICS
						-- material only defines the deprecated
						-- `DiagnosticInformation`, so DiagnosticInfo (and every
						-- group linking to it) is filled in here.
						-- ══════════════════════════════════════════════
						DiagnosticError = { fg = l.error },
						DiagnosticWarn = { fg = l.warning },
						DiagnosticInfo = { fg = l.info },
						DiagnosticHint = { fg = l.hint },
						DiagnosticOk = { fg = m.green },
						DiagnosticSignError = { fg = l.error, bg = e.bg },
						DiagnosticSignWarn = { fg = l.warning, bg = e.bg },
						DiagnosticSignInfo = { fg = l.info, bg = e.bg },
						DiagnosticSignHint = { fg = l.hint, bg = e.bg },
						DiagnosticVirtualTextError = { fg = l.error, bg = blend(l.error, e.bg, 0.12) },
						DiagnosticVirtualTextWarn = { fg = l.warning, bg = blend(l.warning, e.bg, 0.12) },
						DiagnosticVirtualTextInfo = { fg = l.info, bg = blend(l.info, e.bg, 0.12) },
						DiagnosticVirtualTextHint = { fg = l.hint, bg = blend(l.hint, e.bg, 0.12) },
						DiagnosticUnnecessary = { fg = e.disabled, italic = true },
						DiagnosticDeprecated = { fg = e.disabled, strikethrough = true },

						-- ══════════════════════════════════════════════
						-- GIT / DIFF
						-- ══════════════════════════════════════════════
						DiffAdd = { fg = g.added, bg = blend(g.added, e.bg, 0.15) },
						DiffChange = { fg = g.modified, bg = blend(g.modified, e.bg, 0.12) },
						DiffDelete = { fg = g.removed, bg = blend(g.removed, e.bg, 0.15) },
						DiffText = { fg = g.modified, bg = blend(g.modified, e.bg, 0.28) },
						GitSignsCurrentLineBlame = { fg = e.disabled, italic = true },

						-- ══════════════════════════════════════════════
						-- FZF-LUA
						-- config/theme.lua feeds fzf-lua the same values at
						-- setup time; repeating them here keeps the picker
						-- correct after a later :colorscheme reload.
						-- ══════════════════════════════════════════════
						FzfLuaNormal = { fg = e.fg, bg = e.bg_alt },
						FzfLuaBorder = { fg = e.border, bg = e.bg_alt },
						FzfLuaCursorLine = { fg = e.accent, bg = e.selection },
						FzfLuaTitle = { fg = m.blue, bold = true },
						FzfLuaPrompt = { fg = m.purple, bold = true },
						FzfLuaPointer = { fg = m.purple, bold = true },
						FzfLuaMarker = { fg = m.green },
						FzfLuaSpinner = { fg = e.accent, bold = true },
						FzfLuaHeader = { fg = s.comments },
						FzfLuaPreviewTitle = { fg = m.purple, bold = true },

						-- ══════════════════════════════════════════════
						-- MISC PLUGINS
						-- ══════════════════════════════════════════════
						TreesitterContext = { bg = e.active },
						TreesitterContextLineNumber = { fg = e.disabled, bg = e.active },
						NoiceCmdlinePopupBorder = { fg = e.border },
						NoiceCmdlineIcon = { fg = e.accent },
						NoiceConfirmBorder = { fg = e.border },
					}
				end,
			})

			-- :MaterialStyle darker | lighter | oceanic | palenight | deep ocean
			--
			-- Routed through config.theme_switcher so a style change takes exactly the
			-- same path as a theme switch: its ColorSchemePre hook rebuilds
			-- theme.current_theme from the new style and sets `background`, and its
			-- ColorScheme hook re-emits bufferline, alpha, fzf-lua and notify.
			vim.api.nvim_create_user_command("MaterialStyle", function(opts)
				vim.g.material_style = opts.args ~= "" and opts.args or theme.material_style
				require("config.theme_switcher").apply("material", { persist = true, notify = false })
			end, {
				nargs = "?",
				desc = "Switch the material.nvim style",
				complete = function()
					return { "deep ocean", "darker", "lighter", "oceanic", "palenight" }
				end,
			})
		end,
	},
	-- Evergarden (available via :colorscheme evergarden, or evergarden-<variant>)
	--
	-- Variant + accent live in lua/config/theme.lua (M.evergarden_variant /
	-- M.evergarden_accent) so the plugin and theme.lua's palette agree. evergarden
	-- ships broad coverage of its own — editor, syntax, treesitter, diagnostics
	-- (incl. blended virtual text), semantic tokens and per-plugin groups — so the
	-- `overrides` below only fill the gaps and the few places this config is
	-- opinionated.
	{
		"everviolet/nvim",
		name = "evergarden",
		lazy = true,
		priority = 1000,
		config = function()
			local theme = require("config.theme")

			require("evergarden").setup({
				theme = {
					variant = theme.evergarden_variant, -- winter | fall | spring | summer | lunar
					accent = theme.evergarden_accent,
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
						-- (config/theme.lua), so state them here too and a reload keeps them.
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
	},
	-- Koda (available via :colorscheme koda-dark)
	--
	-- Palette overrides live in lua/config/theme.lua as KODA_COLORS, so the
	-- editor, nvim-tree, fzf-lua, bufferline and the blink menu all read the same
	-- values. koda covers base/syntax/treesitter/LSP plus the plugins it detects
	-- through lazy (`auto = true`); `on_highlights` below fills the gaps — the
	-- plugins koda has no groups for, and the handful of defaults that are too
	-- quiet to read at a glance.
	{
		"oskarnurm/koda.nvim",
		lazy = true,
		priority = 1000, -- ...and before every other start plugin, when it is the active one
		config = function()
			local koda = require("koda")
			local theme = require("config.theme")

			koda.setup({
				transparent = true, -- Normal/StatusLine/Pmenu fall through to the terminal

				theme = {
					dark = "dark",
					light = "light",
				},

				auto = true, -- disable to load ALL available plugin highlights

				cache = true, -- caches the theme for better performance

				-- Attributes only. The constants color moved to KODA_COLORS.const,
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
				colors = { dark = theme.koda_colors },

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
					-- config/theme.lua; nvim-tree in particular has no koda support,
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
	},
	-- Rose Pine
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "auto", -- the colors/rose-pine-*.lua files pick the variant
				transparent = true,
				dark_variant = "main", -- plain `:colorscheme rose-pine` on a dark background
				dim_inactive_windows = false,
				extend_background_behind_borders = true,

				styles = {
					bold = true,
					italic = true,
					transparency = false,
				},

				palette = {},
				highlight_groups = {
					-- Treesitter
					["@keyword"] = { italic = true },
					["@type.qualifier"] = { italic = true },
					["@variable.builtin"] = { italic = true },
					["@string.special.url"] = { fg = "iris", underline = true },

					-- UI
					Normal = { bg = "base" },
					NormalFloat = { bg = "surface" },
					NormalNC = { bg = "base" },
					SignColumn = { bg = "base" },
					LineNr = { bg = "base", fg = "muted" },
					CursorLineNr = { bg = "base", fg = "text", bold = true },
					FoldColumn = { bg = "base" },
					WinSeparator = { fg = "overlay", bg = "base" },
					StatusLine = { bg = "overlay", fg = "text" },
					StatusLineNC = { bg = "surface", fg = "muted" },

					-- Pmenu / Completion
					Pmenu = { bg = "surface", fg = "text" },
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
	},
	-- Kanagawa Wave (available via :colorscheme kanagawa-wave)
	-- Colors matched to the VSCode Kanagawa theme by metapho-re
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		priority = 1000,
		compile = true,
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true, bold = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				theme = "dragon",
				background = { dark = "wave", light = "lotus" },
				colors = {
					theme = {
						wave = {
							ui = { bg = "#1F1F28" },
						},
					},
				},
				overrides = function(colors)
					local theme = colors.theme
					local palette = colors.palette
					return {
						-- ══════════════════════════════════════════════
						-- EDITOR UI — matched to VSCode kanagawa-wave
						-- ══════════════════════════════════════════════
						Normal = { bg = "#1F1F28", fg = "#DCD7BA" },
						NormalFloat = { bg = "#1F1F28", fg = "#DCD7BA" },
						NormalNC = { bg = "#1F1F28", fg = "#DCD7BA" },
						SignColumn = { bg = "#1F1F28" },
						LineNr = { bg = "#1F1F28", fg = "#54546D" },
						LineNrAbove = { fg = "#54546D" },
						LineNrBelow = { fg = "#54546D" },
						CursorLineNr = { bg = "#1F1F28", fg = "#FFA066", bold = true },
						CursorLine = { bg = "#363646" },
						FoldColumn = { bg = "#1F1F28", fg = "#54546D" },
						Folded = { bg = "#363646", fg = "#727169" },
						WinSeparator = { fg = "#16161D", bg = "#1F1F28" },
						StatusLine = { bg = "#16161D", fg = "#C8C093" },
						StatusLineNC = { bg = "#16161D", fg = "#727169" },
						Visual = { bg = "#223249" },
						VisualNOS = { bg = "#223249" },
						NonText = { fg = "#1F1F28" },
						Whitespace = { fg = "#1F1F28" },
						VertSplit = { fg = "#16161D" },
						ColorColumn = { bg = "#363646" },
						Conceal = { fg = "#727169" },
						Directory = { fg = "#7E9CD8" },
						EndOfBuffer = { fg = "#1F1F28" },
						ErrorMsg = { fg = "#E82424" },
						WarningMsg = { fg = "#FF9E3B" },
						ModeMsg = { fg = "#DCD7BA", bold = true },
						MoreMsg = { fg = "#7FB4CA" },
						Question = { fg = "#7FB4CA" },
						Title = { fg = "#7E9CD8", bold = true },
						WildMenu = { bg = "#363646" },

						-- Cursor
						Cursor = { fg = "#1F1F28", bg = "#DCD7BA" },
						lCursor = { fg = "#1F1F28", bg = "#DCD7BA" },
						CursorIM = { fg = "#1F1F28", bg = "#DCD7BA" },
						TermCursor = { fg = "#1F1F28", bg = "#DCD7BA" },

						-- Tabs
						TabLine = { bg = "#1A1A22", fg = "#727169" },
						TabLineSel = { bg = "#2A2A37", fg = "#7E9CD8" },
						TabLineFill = { bg = "#16161D" },

						-- Floating windows / Hover
						FloatBorder = { fg = "#2A2A37", bg = "#1F1F28" },
						FloatTitle = { fg = "#7E9CD8", bg = "#1F1F28", bold = true },

						-- Pmenu / Completion
						Pmenu = { bg = "#223249", fg = "#DCD7BA" },
						PmenuSel = { bg = "#2D4F67", fg = "#DCD7BA" },
						PmenuSbar = { bg = "#223249" },
						PmenuThumb = { bg = "#54546D" },
						CmpItemAbbr = { fg = "#DCD7BA" },
						CmpItemAbbrMatch = { fg = "#7E9CD8", bold = true },
						CmpItemAbbrMatchFuzzy = { fg = "#7E9CD8", bold = true },
						CmpItemAbbrDeprecated = { fg = "#727169", strikethrough = true },
						CmpItemMenu = { fg = "#727169" },
						CmpItemKindFunction = { fg = "#7E9CD8" },
						CmpItemKindMethod = { fg = "#7FB4CA" },
						CmpItemKindVariable = { fg = "#DCD7BA" },
						CmpItemKindClass = { fg = "#7AA89F" },
						CmpItemKindInterface = { fg = "#7AA89F" },
						CmpItemKindModule = { fg = "#E6C384" },
						CmpItemKindKeyword = { fg = "#957FB8" },
						CmpItemKindSnippet = { fg = "#FFA066" },
						CmpItemKindText = { fg = "#DCD7BA" },
						CmpItemKindProperty = { fg = "#E6C384" },
						CmpItemKindConstant = { fg = "#FFA066" },
						CmpItemKindEnum = { fg = "#7AA89F" },
						CmpItemKindEnumMember = { fg = "#FFA066" },
						CmpItemKindStruct = { fg = "#7AA89F" },
						CmpItemKindField = { fg = "#E6C384" },
						CmpItemKindOperator = { fg = "#C0A36E" },
						CmpItemKindTypeParameter = { fg = "#7AA89F" },
						CmpBorder = { fg = "#223249", bg = "#223249" },
						CmpDocBorder = { fg = "#223249", bg = "#223249" },

						-- ══════════════════════════════════════════════
						-- SYNTAX — all VSCode tokenColors mapped
						-- ══════════════════════════════════════════════

						-- Comments
						Comment = { fg = "#727169", italic = true },

						-- Strings
						String = { fg = "#98BB6C" },
						Character = { fg = "#98BB6C" },

						-- Numbers
						Number = { fg = "#D27E99" },
						Float = { fg = "#D27E99" },

						-- Booleans & Constants
						Boolean = { fg = "#FFA066" },
						Constant = { fg = "#FFA066" },

						-- Functions
						Function = { fg = "#7E9CD8" },

						-- Keywords & Storage
						Keyword = { fg = "#957FB8" },
						Statement = { fg = "#957FB8", bold = true },
						Conditional = { fg = "#957FB8", bold = true },
						Repeat = { fg = "#957FB8", bold = true },
						Exception = { fg = "#FF5D62", bold = true },
						StorageClass = { fg = "#957FB8" },
						Structure = { fg = "#957FB8" },
						Typedef = { fg = "#957FB8" },

						-- Types
						Type = { fg = "#7AA89F" },

						-- Operators
						Operator = { fg = "#C0A36E" },

						-- Identifiers
						Identifier = { fg = "#DCD7BA" },

						-- Preprocessor / Includes
						PreProc = { fg = "#FFA066" },
						Include = { fg = "#FFA066" },
						Define = { fg = "#957FB8" },
						Macro = { fg = "#E46876" },
						PreCondit = { fg = "#957FB8" },

						-- Special
						Special = { fg = "#7FB4CA" },
						SpecialChar = { fg = "#7FB4CA" },
						SpecialComment = { fg = "#727169", italic = true },
						Tag = { fg = "#E6C384" },
						Delimiter = { fg = "#9CABCA" },
						Debug = { fg = "#E82424" },

						-- Labels
						Label = { fg = "#E6C384" },

						-- Underlined (links)
						Underlined = { fg = "#6A9589", underline = true },

						-- ══════════════════════════════════════════════
						-- TREESITTER — precise VSCode token mapping
						-- ══════════════════════════════════════════════

						-- Keywords
						["@keyword"] = { fg = "#957FB8" },
						["@keyword.function"] = { fg = "#957FB8" },
						["@keyword.operator"] = { fg = "#E6C384" },
						["@keyword.import"] = { fg = "#FFA066" },
						["@keyword.export"] = { fg = "#957FB8" },
						["@keyword.return"] = { fg = "#957FB8", bold = true },
						["@keyword.exception"] = { fg = "#FF5D62", bold = true },
						["@keyword.conditional"] = { fg = "#957FB8", bold = true },
						["@keyword.repeat"] = { fg = "#957FB8", bold = true },
						["@keyword.storage"] = { fg = "#957FB8" },
						["@keyword.directive"] = { fg = "#957FB8" },
						["@keyword.modifier"] = { fg = "#957FB8" },

						-- Functions
						["@function"] = { fg = "#7E9CD8" },
						["@function.call"] = { fg = "#7E9CD8" },
						["@function.builtin"] = { fg = "#7E9CD8" },
						["@function.method"] = { fg = "#7FB4CA" },
						["@function.method.call"] = { fg = "#7FB4CA" },
						["@function.macro"] = { fg = "#E46876" },
						["@constructor"] = { fg = "#7FB4CA" },

						-- Variables
						["@variable"] = { fg = "#DCD7BA" },
						["@variable.builtin"] = { fg = "#FF5D62" },
						["@variable.parameter"] = { fg = "#B8B4D0" },
						["@variable.member"] = { fg = "#E6C384" },

						-- Types
						["@type"] = { fg = "#7AA89F" },
						["@type.builtin"] = { fg = "#7AA89F" },
						["@type.definition"] = { fg = "#7AA89F" },
						["@type.qualifier"] = { fg = "#957FB8" },

						-- Constants
						["@constant"] = { fg = "#FFA066" },
						["@constant.builtin"] = { fg = "#FFA066" },
						["@constant.macro"] = { fg = "#FFA066" },

						-- Strings
						["@string"] = { fg = "#98BB6C" },
						["@string.escape"] = { fg = "#7FB4CA" },
						["@string.regex"] = { fg = "#C0A36E" },
						["@string.special"] = { fg = "#7FB4CA" },
						["@string.special.url"] = { fg = "#6A9589", underline = true },
						["@string.special.symbol"] = { fg = "#98BB6C" },

						-- Numbers
						["@number"] = { fg = "#D27E99" },
						["@number.float"] = { fg = "#D27E99" },
						["@boolean"] = { fg = "#FFA066" },

						-- Operators & Punctuation
						["@operator"] = { fg = "#C0A36E" },
						["@punctuation.bracket"] = { fg = "#9CABCA" },
						["@punctuation.delimiter"] = { fg = "#9CABCA" },
						["@punctuation.special"] = { fg = "#9CABCA" },

						-- Tags (HTML/JSX)
						["@tag"] = { fg = "#E6C384" },
						["@tag.builtin"] = { fg = "#E6C384" },
						["@tag.attribute"] = { fg = "#957FB8" },
						["@tag.delimiter"] = { fg = "#9CABCA" },

						-- Properties & Fields
						["@property"] = { fg = "#E6C384" },
						["@field"] = { fg = "#E6C384" },

						-- Labels & Attributes
						["@label"] = { fg = "#E6C384" },
						["@attribute"] = { fg = "#957FB8" },
						["@attribute.builtin"] = { fg = "#957FB8" },

						-- Modules / Namespaces
						["@module"] = { fg = "#E6C384" },
						["@module.builtin"] = { fg = "#E6C384" },

						-- Comments
						["@comment"] = { fg = "#727169", italic = true },
						["@comment.documentation"] = { fg = "#727169", italic = true },
						["@comment.todo"] = { fg = "#7FB4CA", bold = true },
						["@comment.note"] = { fg = "#7FB4CA", bold = true },
						["@comment.warning"] = { fg = "#FF9E3B", bold = true },
						["@comment.error"] = { fg = "#E82424", bold = true },

						-- Markup (Markdown)
						["@markup.heading"] = { fg = "#7E9CD8", bold = true },
						["@markup.heading.1"] = { fg = "#7E9CD8", bold = true },
						["@markup.heading.2"] = { fg = "#7E9CD8", bold = true },
						["@markup.heading.3"] = { fg = "#7E9CD8", bold = true },
						["@markup.italic"] = { fg = "#E46876", italic = true },
						["@markup.strong"] = { bold = true },
						["@markup.strikethrough"] = { strikethrough = true },
						["@markup.underline"] = { fg = "#7FB4CA", underline = true },
						["@markup.quote"] = { italic = true },
						["@markup.link"] = { fg = "#FFA066" },
						["@markup.link.url"] = { fg = "#6A9589", underline = true },
						["@markup.link.label"] = { fg = "#957FB8" },
						["@markup.raw"] = { fg = "#957FB8" },
						["@markup.raw.block"] = { fg = "#957FB8" },
						["@markup.list"] = { fg = "#DCD7BA" },
						["@markup.list.checked"] = { fg = "#98BB6C" },
						["@markup.list.unchecked"] = { fg = "#727169" },

						-- Diff
						["@diff.plus"] = { fg = "#76946A" },
						["@diff.minus"] = { fg = "#C34043" },
						["@diff.delta"] = { fg = "#DCA561" },

						-- ══════════════════════════════════════════════
						-- LSP SEMANTIC TOKENS — from VSCode semanticTokenColors
						-- ══════════════════════════════════════════════
						["@lsp.type.parameter"] = { fg = "#B8B4D0" },
						["@lsp.type.variable"] = { fg = "#DCD7BA" },
						["@lsp.type.property"] = { fg = "#E6C384" },
						["@lsp.type.function"] = { fg = "#7E9CD8" },
						["@lsp.type.method"] = { fg = "#7FB4CA" },
						["@lsp.type.macro"] = { fg = "#E46876" },
						["@lsp.type.enum"] = { fg = "#7AA89F" },
						["@lsp.type.enumMember"] = { fg = "#FFA066" },
						["@lsp.type.struct"] = { fg = "#7AA89F" },
						["@lsp.type.class"] = { fg = "#7AA89F" },
						["@lsp.type.interface"] = { fg = "#7AA89F" },
						["@lsp.type.namespace"] = { fg = "#E6C384" },
						["@lsp.type.type"] = { fg = "#7AA89F" },
						["@lsp.type.typeParameter"] = { fg = "#7AA89F" },
						["@lsp.type.keyword"] = { fg = "#957FB8" },
						["@lsp.type.operator"] = { fg = "#C0A36E" },
						["@lsp.mod.readonly"] = {},
						["@lsp.mod.defaultLibrary"] = {},
						["@lsp.typemod.function.declaration"] = { fg = "#7E9CD8" },
						["@lsp.typemod.function.defaultLibrary"] = { fg = "#7E9CD8" },
						["@lsp.typemod.variable.readonly"] = { fg = "#DCD7BA" },
						["@lsp.typemod.variable.defaultLibrary"] = { fg = "#DCD7BA" },
						["@lsp.typemod.keyword.controlFlow"] = { fg = "#957FB8", bold = true },

						-- ══════════════════════════════════════════════
						-- BRACKET PAIR COLORIZATION — from VSCode
						-- ══════════════════════════════════════════════
						RainbowDelimiterRed = { fg = "#957FB8" },
						RainbowDelimiterYellow = { fg = "#FFA066" },
						RainbowDelimiterBlue = { fg = "#7E9CD8" },
						RainbowDelimiterOrange = { fg = "#D27E99" },
						RainbowDelimiterGreen = { fg = "#E6C384" },
						RainbowDelimiterViolet = { fg = "#7AA89F" },

						-- ══════════════════════════════════════════════
						-- LANGUAGE-SPECIFIC — from VSCode scope overrides
						-- ══════════════════════════════════════════════

						-- JSON key levels
						["@property.json"] = { fg = "#D27E99" },
						jsonKeyword = { fg = "#D27E99" },

						-- CSS/SCSS
						["@property.css"] = { fg = "#7AA89F" },
						["@property.scss"] = { fg = "#7AA89F" },

						-- YAML
						["@field.yaml"] = { fg = "#E6C384" },

						-- TOML
						["@property.toml"] = { fg = "#E6C384" },

						-- ══════════════════════════════════════════════
						-- PLUGIN HIGHLIGHTS
						-- ══════════════════════════════════════════════

						-- FzfLua
						FzfLuaNormal = { bg = "#1F1F28", fg = "#DCD7BA" },
						FzfLuaBorder = { fg = "#54546D" },
						FzfLuaCursorLine = { bg = "#363646", fg = "#957FB8" },
						FzfLuaTitle = { fg = "#7E9CD8", bold = true },
						FzfLuaPrompt = { fg = "#957FB8", bold = true },
						FzfLuaPointer = { fg = "#957FB8", bold = true },
						FzfLuaMarker = { fg = "#98BB6C" },
						FzfLuaSpinner = { fg = "#957FB8", bold = true },
						FzfLuaHeader = { fg = "#727169" },
						FzfLuaPreviewTitle = { fg = "#957FB8", bold = true },

						-- Neo-tree
						NeoTreeNormal = { bg = "#1F1F28", fg = "#DCD7BA" },
						NeoTreeNormalNC = { bg = "#1F1F28", fg = "#DCD7BA" },
						NeoTreeWinSeparator = { fg = "#16161D", bg = "#1F1F28" },
						NeoTreeCursorLine = { bg = "#363646" },
						NeoTreeIndentMarker = { fg = "#2A2A37" },
						NeoTreeGitAdded = { fg = "#76946A" },
						NeoTreeGitModified = { fg = "#DCA561" },
						NeoTreeGitDeleted = { fg = "#C34043" },
						NeoTreeGitUntracked = { fg = "#957FB8" },
						NeoTreeGitIgnored = { fg = "#727169" },
						NeoTreeFileName = { fg = "#DCD7BA" },
						NeoTreeDirectoryName = { fg = "#7E9CD8" },
						NeoTreeDirectoryIcon = { fg = "#7E9CD8" },
						NeoTreeRootName = { fg = "#957FB8", bold = true },
						NeoTreeDotfile = { fg = "#727169" },

						-- Diagnostics
						DiagnosticError = { fg = "#E82424" },
						DiagnosticWarn = { fg = "#FF9E3B" },
						DiagnosticInfo = { fg = "#7FB4CA" },
						DiagnosticHint = { fg = "#957FB8" },
						DiagnosticVirtualTextError = { fg = "#E82424", bg = "#2D1B1E" },
						DiagnosticVirtualTextWarn = { fg = "#FF9E3B", bg = "#2D2618" },
						DiagnosticVirtualTextInfo = { fg = "#7FB4CA", bg = "#1C2530" },
						DiagnosticVirtualTextHint = { fg = "#957FB8", bg = "#252030" },
						DiagnosticUnderlineError = { undercurl = true, sp = "#E82424" },
						DiagnosticUnderlineWarn = { undercurl = true, sp = "#FF9E3B" },
						DiagnosticUnderlineInfo = { undercurl = true, sp = "#7FB4CA" },
						DiagnosticUnderlineHint = { undercurl = true, sp = "#957FB8" },

						-- Git signs
						GitSignsAdd = { fg = "#76946A" },
						GitSignsChange = { fg = "#DCA561" },
						GitSignsDelete = { fg = "#C34043" },
						GitSignsCurrentLineBlame = { fg = "#727169" },

						-- Diff
						DiffAdd = { bg = "#2B3328" },
						DiffChange = { bg = "#2D2618" },
						DiffDelete = { bg = "#3D1B20" },
						DiffText = { bg = "#2D4F67" },

						-- Indent blankline
						IblIndent = { fg = "#2A2A37" },
						IblScope = { fg = "#363646" },

						-- Inlay hints (from VSCode editorInlayHint)
						LspInlayHint = { fg = "#727169", bg = "#1F1F28", italic = true },

						-- Bracket match
						MatchParen = { bg = "#16161D", fg = "#DCD7BA", bold = true },

						-- Search
						Search = { bg = "#2D4F67", fg = "#DCD7BA" },
						IncSearch = { bg = "#FF9E3B", fg = "#1F1F28" },
						CurSearch = { bg = "#FF9E3B", fg = "#1F1F28" },
						Substitute = { bg = "#FF5D62", fg = "#1F1F28" },

						-- Word highlight (from VSCode editor.wordHighlight)
						LspReferenceText = { bg = "#2A2A33" },
						LspReferenceRead = { bg = "#2A2A33" },
						LspReferenceWrite = { bg = "#2A2A33", underline = true },
						IlluminatedWordText = { bg = "#2A2A33" },
						IlluminatedWordRead = { bg = "#2A2A33" },
						IlluminatedWordWrite = { bg = "#2A2A33", underline = true },

						-- Which-key
						WhichKey = { fg = "#957FB8" },
						WhichKeyDesc = { fg = "#DCD7BA" },
						WhichKeyGroup = { fg = "#7E9CD8" },
						WhichKeySeparator = { fg = "#727169" },

						-- Noice / Notify
						NotifyERRORBorder = { fg = "#E82424" },
						NotifyWARNBorder = { fg = "#FF9E3B" },
						NotifyINFOBorder = { fg = "#7FB4CA" },
						NotifyDEBUGBorder = { fg = "#727169" },
						NotifyTRACEBorder = { fg = "#957FB8" },
						NotifyERRORIcon = { fg = "#E82424" },
						NotifyWARNIcon = { fg = "#FF9E3B" },
						NotifyINFOIcon = { fg = "#7FB4CA" },
						NotifyDEBUGIcon = { fg = "#727169" },
						NotifyTRACEIcon = { fg = "#957FB8" },
						NotifyERRORTitle = { fg = "#E82424" },
						NotifyWARNTitle = { fg = "#FF9E3B" },
						NotifyINFOTitle = { fg = "#7FB4CA" },
						NotifyDEBUGTitle = { fg = "#727169" },
						NotifyTRACETitle = { fg = "#957FB8" },
					}
				end,
			})
		end,
	},
	-- Jellybeans (available via :colorscheme jellybeans)
	{
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
	},
	-- Kanso Zen — minimal, muted palette for deep focus
	{
		"webhooked/kanso.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			require("kanso").setup({
				theme = "zen",
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = {},
				typeStyle = {},
				transparent = true,
				dimInactive = true,
				terminalColors = true,
				background = { dark = "zen", light = "pearl" },
				overrides = function(colors)
					local p = colors.palette
					local t = colors.theme
					-- Theme-relative, so these follow whichever variant loaded
					-- (zen | ink | mist | pearl) instead of pinning zen's ramp.
					local bg = t.ui.bg
					local bg1 = t.ui.bg_p1
					local bg2 = t.ui.bg_p2
					local bg3 = t.ui.bg_visual
					-- The warm foreground and near-white accent are deliberate overrides
					-- (kanso's own fg is #C5C9C7), but they only read against a dark
					-- background — pearl gets what the theme itself specifies.
					local light = vim.o.background == "light"
					local fg = light and t.ui.fg or "#DCD7BA"
					local fg2 = light and t.ui.fg or p.fg2

					-- Mix two hex colors, matching the material spec above — the
					-- diagnostic washes have to sit on the active variant's background.
					local function blend(a, b, alpha)
						local function mix(i)
							local x = tonumber(a:sub(i, i + 1), 16) * alpha
							local y = tonumber(b:sub(i, i + 1), 16) * (1 - alpha)
							return math.floor(math.min(math.max(x + y, 0), 255) + 0.5)
						end
						return string.format("#%02X%02X%02X", mix(2), mix(4), mix(6))
					end
					return {
						-- ══════════════════════════════════════════════
						-- EDITOR UI — deep dark, minimal chrome
						-- ══════════════════════════════════════════════
						Normal = { bg = bg, fg = fg },
						NormalFloat = { bg = bg, fg = fg },
						NormalNC = { bg = bg, fg = p.gray2 },
						SignColumn = { bg = bg },
						LineNr = { bg = bg, fg = p.gray5 },
						CursorLineNr = { bg = bg, fg = fg2, bold = true },
						CursorLine = { bg = bg1 },
						FoldColumn = { bg = bg, fg = p.gray5 },
						Folded = { bg = bg1, fg = p.gray4 },
						WinSeparator = { fg = bg, bg = bg },
						StatusLine = { bg = bg1, fg = p.gray2 },
						StatusLineNC = { bg = bg, fg = p.gray5 },
						Visual = { bg = bg3 },
						VisualNOS = { bg = bg3 },
						NonText = { fg = bg2 },
						Whitespace = { fg = bg2 },
						VertSplit = { fg = bg1 },
						ColorColumn = { bg = bg1 },
						Conceal = { fg = p.gray4 },
						Directory = { fg = p.blue3 },
						EndOfBuffer = { fg = bg },
						ErrorMsg = { fg = p.red },
						WarningMsg = { fg = p.yellow },
						ModeMsg = { fg = fg, bold = true },
						MoreMsg = { fg = p.blue },
						Question = { fg = p.blue },
						Title = { fg = p.blue3, bold = true },
						WildMenu = { bg = bg3 },

						-- Cursor
						Cursor = { fg = bg, bg = fg },
						lCursor = { fg = bg, bg = fg },
						CursorIM = { fg = bg, bg = fg },
						TermCursor = { fg = bg, bg = fg },

						-- Tabs
						TabLine = { bg = bg, fg = p.gray4 },
						TabLineSel = { bg = bg2, fg = p.blue3 },
						TabLineFill = { bg = bg },

						-- Floating windows
						FloatBorder = { fg = bg2, bg = bg },
						FloatTitle = { fg = p.blue3, bg = bg, bold = true },

						-- Pmenu / Completion
						Pmenu = { bg = bg1, fg = fg },
						PmenuSel = { bg = bg3, fg = t.syn.fun, bold = true },
						PmenuSbar = { bg = bg1 },
						PmenuThumb = { bg = bg3 },
						CmpItemAbbr = { fg = fg },
						CmpItemAbbrMatch = { fg = p.blue3, bold = true },
						CmpItemAbbrMatchFuzzy = { fg = p.blue3, bold = true },
						CmpItemAbbrDeprecated = { fg = p.gray4, strikethrough = true },
						CmpItemMenu = { fg = p.gray4 },
						CmpItemKindFunction = { fg = t.syn.fun },
						CmpItemKindMethod = { fg = p.blue },
						CmpItemKindVariable = { fg = t.syn.identifier },
						CmpItemKindClass = { fg = t.syn.type },
						CmpItemKindInterface = { fg = t.syn.type },
						CmpItemKindModule = { fg = p.yellow2 },
						CmpItemKindKeyword = { fg = t.syn.keyword },
						CmpItemKindSnippet = { fg = t.syn.special1 },
						CmpItemKindText = { fg = fg },
						CmpItemKindProperty = { fg = p.yellow3 },
						CmpItemKindConstant = { fg = t.syn.constant },
						CmpItemKindEnum = { fg = t.syn.type },
						CmpItemKindEnumMember = { fg = t.syn.constant },
						CmpItemKindStruct = { fg = t.syn.type },
						CmpItemKindField = { fg = p.yellow3 },
						CmpItemKindOperator = { fg = t.syn.operator },
						CmpItemKindTypeParameter = { fg = t.syn.type },
						CmpBorder = { fg = bg2, bg = bg },
						CmpDocBorder = { fg = bg2, bg = bg },

						-- ══════════════════════════════════════════════
						-- SYNTAX — muted and balanced, low contrast
						-- ══════════════════════════════════════════════
						Comment = { fg = p.gray4, italic = true },
						String = { fg = p.green3 },
						Character = { fg = p.green3 },
						Number = { fg = p.pink },
						Float = { fg = p.pink },
						Boolean = { fg = p.orange },
						Constant = { fg = p.orange },
						Function = { fg = p.blue3 },
						Keyword = { fg = p.violet2 },
						Statement = { fg = p.violet2 },
						Conditional = { fg = p.violet2, bold = true },
						Repeat = { fg = p.violet2, bold = true },
						Exception = { fg = p.red2, bold = true },
						StorageClass = { fg = p.violet2 },
						Structure = { fg = p.violet2 },
						Typedef = { fg = p.violet2 },
						Type = { fg = p.aqua },
						Operator = { fg = p.gray3 },
						Identifier = { fg = fg },
						PreProc = { fg = p.gray3 },
						Include = { fg = p.violet2 },
						Define = { fg = p.violet2 },
						Macro = { fg = p.red3 },
						PreCondit = { fg = p.violet2 },
						Special = { fg = p.yellow3 },
						SpecialChar = { fg = p.blue },
						SpecialComment = { fg = p.gray4, italic = true },
						Tag = { fg = p.yellow2 },
						Delimiter = { fg = p.gray3 },
						Debug = { fg = p.red },
						Label = { fg = p.yellow2 },
						Underlined = { fg = p.green4, underline = true },

						-- ══════════════════════════════════════════════
						-- TREESITTER — precise, quiet syntax coloring
						-- ══════════════════════════════════════════════

						-- Keywords
						["@keyword"] = { fg = p.violet2, italic = true },
						["@keyword.function"] = { fg = p.violet2, italic = true },
						["@keyword.operator"] = { fg = p.yellow3 },
						["@keyword.import"] = { fg = p.violet2 },
						["@keyword.export"] = { fg = p.violet2 },
						["@keyword.return"] = { fg = p.violet2, bold = true },
						["@keyword.exception"] = { fg = p.red2, bold = true },
						["@keyword.conditional"] = { fg = p.violet2, bold = true },
						["@keyword.repeat"] = { fg = p.violet2, bold = true },
						["@keyword.storage"] = { fg = p.violet2 },
						["@keyword.directive"] = { fg = p.violet2 },
						["@keyword.modifier"] = { fg = p.violet2 },

						-- Functions
						["@function"] = { fg = p.blue3 },
						["@function.call"] = { fg = p.blue3 },
						["@function.builtin"] = { fg = p.blue3 },
						["@function.method"] = { fg = p.blue },
						["@function.method.call"] = { fg = p.blue },
						["@function.macro"] = { fg = p.red3 },
						["@constructor"] = { fg = p.blue },

						-- Variables
						["@variable"] = { fg = fg },
						["@variable.builtin"] = { fg = p.red2 },
						["@variable.parameter"] = { fg = p.gray3 },
						["@variable.member"] = { fg = p.yellow3 },

						-- Types
						["@type"] = { fg = p.aqua },
						["@type.builtin"] = { fg = p.aqua },
						["@type.definition"] = { fg = p.aqua },
						["@type.qualifier"] = { fg = p.violet2, italic = true },

						-- Constants
						["@constant"] = { fg = p.orange },
						["@constant.builtin"] = { fg = p.orange },
						["@constant.macro"] = { fg = p.orange },

						-- Strings
						["@string"] = { fg = p.green3 },
						["@string.escape"] = { fg = p.blue },
						["@string.regex"] = { fg = p.red3 },
						["@string.special"] = { fg = p.blue },
						["@string.special.url"] = { fg = p.green4, underline = true },
						["@string.special.symbol"] = { fg = p.green3 },

						-- Numbers
						["@number"] = { fg = p.pink },
						["@number.float"] = { fg = p.pink },
						["@boolean"] = { fg = p.orange },

						-- Operators & Punctuation
						["@operator"] = { fg = p.gray3 },
						["@punctuation.bracket"] = { fg = p.gray3 },
						["@punctuation.delimiter"] = { fg = p.gray3 },
						["@punctuation.special"] = { fg = p.gray3 },

						-- Tags (HTML/JSX)
						["@tag"] = { fg = p.yellow2 },
						["@tag.builtin"] = { fg = p.yellow2 },
						["@tag.attribute"] = { fg = p.violet2 },
						["@tag.delimiter"] = { fg = p.gray3 },

						-- Properties & Fields
						["@property"] = { fg = p.yellow3 },
						["@field"] = { fg = p.yellow3 },

						-- Labels & Attributes
						["@label"] = { fg = p.yellow2 },
						["@attribute"] = { fg = p.violet2 },
						["@attribute.builtin"] = { fg = p.violet2 },

						-- Modules / Namespaces
						["@module"] = { fg = p.yellow2 },
						["@module.builtin"] = { fg = p.yellow2 },

						-- Comments
						["@comment"] = { fg = p.gray4, italic = true },
						["@comment.documentation"] = { fg = p.gray4, italic = true },
						["@comment.todo"] = { fg = p.blue, bold = true },
						["@comment.note"] = { fg = p.blue, bold = true },
						["@comment.warning"] = { fg = p.yellow, bold = true },
						["@comment.error"] = { fg = p.red, bold = true },

						-- Markup (Markdown)
						["@markup.heading"] = { fg = p.blue3, bold = true },
						["@markup.heading.1"] = { fg = p.blue3, bold = true },
						["@markup.heading.2"] = { fg = p.blue3, bold = true },
						["@markup.heading.3"] = { fg = p.blue3, bold = true },
						["@markup.italic"] = { fg = p.red3, italic = true },
						["@markup.strong"] = { bold = true },
						["@markup.strikethrough"] = { strikethrough = true },
						["@markup.underline"] = { fg = p.blue, underline = true },
						["@markup.quote"] = { italic = true },
						["@markup.link"] = { fg = p.orange },
						["@markup.link.url"] = { fg = p.green4, underline = true },
						["@markup.link.label"] = { fg = p.violet2 },
						["@markup.raw"] = { fg = p.violet2 },
						["@markup.raw.block"] = { fg = p.violet2 },
						["@markup.list"] = { fg = fg },
						["@markup.list.checked"] = { fg = p.green2 },
						["@markup.list.unchecked"] = { fg = p.gray4 },

						-- Diff
						["@diff.plus"] = { fg = p.gitGreen },
						["@diff.minus"] = { fg = p.gitRed },
						["@diff.delta"] = { fg = p.gitYellow },

						-- ══════════════════════════════════════════════
						-- LSP SEMANTIC TOKENS
						-- ══════════════════════════════════════════════
						["@lsp.type.parameter"] = { fg = p.gray3 },
						["@lsp.type.variable"] = { fg = fg },
						["@lsp.type.property"] = { fg = p.yellow3 },
						["@lsp.type.function"] = { fg = p.blue3 },
						["@lsp.type.method"] = { fg = p.blue },
						["@lsp.type.macro"] = { fg = p.red3 },
						["@lsp.type.enum"] = { fg = p.aqua },
						["@lsp.type.enumMember"] = { fg = p.orange },
						["@lsp.type.struct"] = { fg = p.aqua },
						["@lsp.type.class"] = { fg = p.aqua },
						["@lsp.type.interface"] = { fg = p.aqua },
						["@lsp.type.namespace"] = { fg = p.yellow2 },
						["@lsp.type.type"] = { fg = p.aqua },
						["@lsp.type.typeParameter"] = { fg = p.aqua },
						["@lsp.type.keyword"] = { fg = p.violet2 },
						["@lsp.type.operator"] = { fg = p.gray3 },
						["@lsp.mod.readonly"] = {},
						["@lsp.mod.defaultLibrary"] = {},
						["@lsp.typemod.function.declaration"] = { fg = p.blue3 },
						["@lsp.typemod.function.defaultLibrary"] = { fg = p.blue3 },
						["@lsp.typemod.variable.readonly"] = { fg = fg },
						["@lsp.typemod.variable.defaultLibrary"] = { fg = fg },
						["@lsp.typemod.keyword.controlFlow"] = { fg = p.violet2, bold = true },

						-- ══════════════════════════════════════════════
						-- BRACKET PAIR COLORIZATION — subdued
						-- ══════════════════════════════════════════════
						RainbowDelimiterRed = { fg = p.violet2 },
						RainbowDelimiterYellow = { fg = p.orange },
						RainbowDelimiterBlue = { fg = p.blue3 },
						RainbowDelimiterOrange = { fg = p.pink },
						RainbowDelimiterGreen = { fg = p.yellow3 },
						RainbowDelimiterViolet = { fg = p.aqua },

						-- ══════════════════════════════════════════════
						-- LANGUAGE-SPECIFIC
						-- ══════════════════════════════════════════════
						["@property.json"] = { fg = p.pink },
						jsonKeyword = { fg = p.pink },
						["@property.css"] = { fg = p.aqua },
						["@property.scss"] = { fg = p.aqua },
						["@field.yaml"] = { fg = p.yellow3 },
						["@property.toml"] = { fg = p.yellow3 },

						-- ══════════════════════════════════════════════
						-- PLUGIN HIGHLIGHTS
						-- ══════════════════════════════════════════════

						-- FzfLua
						FzfLuaNormal = { bg = bg, fg = fg },
						FzfLuaBorder = { fg = bg3 },
						FzfLuaCursorLine = { bg = bg1, fg = p.violet2 },
						FzfLuaTitle = { fg = p.blue3, bold = true },
						FzfLuaPrompt = { fg = p.violet2, bold = true },
						FzfLuaPointer = { fg = p.violet2, bold = true },
						FzfLuaMarker = { fg = p.green2 },
						FzfLuaSpinner = { fg = p.violet2, bold = true },
						FzfLuaHeader = { fg = p.gray4 },
						FzfLuaPreviewTitle = { fg = p.violet2, bold = true },

						-- Neo-tree
						NeoTreeNormal = { bg = bg, fg = fg },
						NeoTreeNormalNC = { bg = bg, fg = fg },
						NeoTreeWinSeparator = { fg = bg, bg = bg },
						NeoTreeCursorLine = { bg = bg1 },
						NeoTreeIndentMarker = { fg = bg2 },
						NeoTreeGitAdded = { fg = p.gitGreen },
						NeoTreeGitModified = { fg = p.gitYellow },
						NeoTreeGitDeleted = { fg = p.gitRed },
						NeoTreeGitUntracked = { fg = p.gray4 },
						NeoTreeGitIgnored = { fg = p.gray5 },
						NeoTreeFileName = { fg = fg },
						NeoTreeDirectoryName = { fg = p.blue3 },
						NeoTreeDirectoryIcon = { fg = p.blue3 },
						NeoTreeRootName = { fg = p.violet2, bold = true },
						NeoTreeDotfile = { fg = p.gray4 },

						-- Diagnostics
						DiagnosticError = { fg = p.red },
						DiagnosticWarn = { fg = p.orange },
						DiagnosticInfo = { fg = p.blue },
						DiagnosticHint = { fg = p.yellow },
						DiagnosticSignError = { fg = p.red },
						DiagnosticSignWarn = { fg = p.orange },
						DiagnosticSignInfo = { fg = p.blue },
						DiagnosticSignHint = { fg = p.yellow },
						DiagnosticVirtualTextError = { fg = p.red, bg = blend(p.red, bg, 0.1) },
						DiagnosticVirtualTextWarn = { fg = p.orange, bg = blend(p.orange, bg, 0.1) },
						DiagnosticVirtualTextInfo = { fg = p.blue2, bg = blend(p.blue2, bg, 0.1) },
						DiagnosticVirtualTextHint = { fg = p.green4, bg = blend(p.green4, bg, 0.1) },
						DiagnosticUnderlineError = { undercurl = true, sp = p.red },
						DiagnosticUnderlineWarn = { undercurl = true, sp = p.orange },
						DiagnosticUnderlineInfo = { undercurl = true, sp = p.blue2 },
						DiagnosticUnderlineHint = { undercurl = true, sp = p.green4 },

						-- Git signs
						GitSignsAdd = { fg = p.gitGreen },
						GitSignsChange = { fg = p.gitYellow },
						GitSignsDelete = { fg = p.gitRed },
						GitSignsCurrentLineBlame = { fg = p.gray5 },

						-- Diff
						DiffAdd = { bg = p.diffGreen },
						DiffChange = { bg = p.diffBlue },
						DiffDelete = { bg = p.diffRed },
						DiffText = { bg = p.diffYellow },

						-- Indent blankline
						IblIndent = { fg = bg2 },
						IblScope = { fg = bg3 },

						-- Inlay hints
						LspInlayHint = { fg = p.gray5, bg = bg, italic = true },

						-- Bracket match
						MatchParen = { bg = bg1, fg = fg2, bold = true },

						-- Search
						Search = { bg = p.altBlue2, fg = fg },
						IncSearch = { bg = p.yellow, fg = bg },
						CurSearch = { bg = p.yellow, fg = bg },
						Substitute = { bg = p.red2, fg = bg },

						-- Word highlight
						LspReferenceText = { bg = bg2, fg = fg },
						LspReferenceRead = { bg = bg2, fg = fg },
						LspReferenceWrite = { bg = bg2, fg = fg, underline = true },
						IlluminatedWordText = { bg = bg2, fg = fg },
						IlluminatedWordRead = { bg = bg2, fg = fg },
						IlluminatedWordWrite = { bg = bg2, fg = fg, underline = true },

						-- Which-key
						WhichKey = { fg = p.violet2 },
						WhichKeyDesc = { fg = fg },
						WhichKeyGroup = { fg = p.blue3 },
						WhichKeySeparator = { fg = p.gray5 },

						-- Noice / Notify
						NotifyERRORBorder = { fg = p.red },
						NotifyWARNBorder = { fg = p.yellow },
						NotifyINFOBorder = { fg = p.blue },
						NotifyDEBUGBorder = { fg = p.gray4 },
						NotifyTRACEBorder = { fg = p.violet },
						NotifyERRORIcon = { fg = p.red },
						NotifyWARNIcon = { fg = p.yellow },
						NotifyINFOIcon = { fg = p.blue },
						NotifyDEBUGIcon = { fg = p.gray4 },
						NotifyTRACEIcon = { fg = p.violet },
						NotifyERRORTitle = { fg = p.red },
						NotifyWARNTitle = { fg = p.yellow },
						NotifyINFOTitle = { fg = p.blue },
						NotifyDEBUGTitle = { fg = p.gray4 },
						NotifyTRACETitle = { fg = p.violet },
					}
				end,
				colors = {
					palette = {},
					theme = { zen = {}, all = {} },
				},
			})
		end,
	},
	-- ══════════════════════════════════════════════════════════════════════
	-- Black Metal (available via :colorscheme <band> — bathory, khold, mayhem…)
	--
	-- Sixteen bands, each a two-accent variation on one near-monochrome base.
	-- config/theme.lua reads their palettes live through `black-metal.palette`
	-- and registers one entry per band, so :Theme lists them all.
	--
	-- The colorscheme names are the BARE band name (`:colorscheme khold`); there
	-- is no `black-metal-*` prefix and no `black-metal` scheme at all.
	-- ══════════════════════════════════════════════════════════════════════
	{
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
				-- why no `-light` entries are registered in config/theme.lua.
				trve = true,
				-- Each band's tinted background (bathory #3E2018, khold #39121b)
				-- instead of pure black. Off here: the tint is used for the
				-- selected tab in theme.lua's bufferline table instead, where it
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

					-- fzf-lua. config/theme.lua feeds the picker the same values
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
	},
}
