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

function M.palette()
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

		tags = {
			builtin = p.cyan,
			component = p.yellow,
			attribute = p.paleblue,
			delimiter = p.border,
		},

		alpha = {
			heading = p.accent,
			button = p.purple,
			shortcut = p.blue,
		},

		-- indent-blankline guides (consumed by plugins/editor/indent.lua)
		indent = {
			line = p.border,
			scope = p.disabled,
		},

		-- blink.cmp menu palette (consumed by plugins/coding/completion.lua)
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

		nvim_tree = lib.make_nvim_tree({
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

-- Light/dark depends on the style, which :MaterialStyle can change at runtime.
function M.background()
	return (vim.g.material_style or MATERIAL_STYLE) == "lighter" and "light" or "dark"
end

-- ══════════════════════════════════════════════════════════════════════
-- Material (available via :colorscheme material)
--
-- The default style is MATERIAL_STYLE above; it is pushed into
-- `vim.g.material_style` here, before the colorscheme loads, so the plugin
-- and M.palette() agree. Use
-- `:MaterialStyle <style>` (defined at the bottom of this block) to switch
-- at runtime — it refreshes theme.current_theme too, so nvim-tree, fzf-lua,
-- bufferline, incline and blink follow along.
M.spec = {
	"marko-cerovac/material.nvim",
	lazy = true,
	priority = 1000,
	config = function()
		-- Must be set BEFORE material.colors is required: the palette module
		-- reads this global once and caches the result.
		vim.g.material_style = MATERIAL_STYLE

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
					DiagnosticVirtualTextError = { fg = l.error, bg = lib.blend(l.error, e.bg, 0.12) },
					DiagnosticVirtualTextWarn = { fg = l.warning, bg = lib.blend(l.warning, e.bg, 0.12) },
					DiagnosticVirtualTextInfo = { fg = l.info, bg = lib.blend(l.info, e.bg, 0.12) },
					DiagnosticVirtualTextHint = { fg = l.hint, bg = lib.blend(l.hint, e.bg, 0.12) },
					DiagnosticUnnecessary = { fg = e.disabled, italic = true },
					DiagnosticDeprecated = { fg = e.disabled, strikethrough = true },

					-- ══════════════════════════════════════════════
					-- GIT / DIFF
					-- ══════════════════════════════════════════════
					DiffAdd = { fg = g.added, bg = lib.blend(g.added, e.bg, 0.15) },
					DiffChange = { fg = g.modified, bg = lib.blend(g.modified, e.bg, 0.12) },
					DiffDelete = { fg = g.removed, bg = lib.blend(g.removed, e.bg, 0.15) },
					DiffText = { fg = g.modified, bg = lib.blend(g.modified, e.bg, 0.28) },
					GitSignsCurrentLineBlame = { fg = e.disabled, italic = true },

					-- ══════════════════════════════════════════════
					-- FZF-LUA
					-- M.palette() feeds fzf-lua the same values at
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
		-- Routed through config.theme.switcher so a style change takes exactly the
		-- same path as a theme switch: its ColorSchemePre hook rebuilds
		-- theme.current_theme from the new style and sets `background`, and its
		-- ColorScheme hook re-emits bufferline, alpha, fzf-lua and notify.
		vim.api.nvim_create_user_command("MaterialStyle", function(opts)
			vim.g.material_style = opts.args ~= "" and opts.args or MATERIAL_STYLE
			require("config.theme.switcher").apply("material", { persist = true, notify = false })
		end, {
			nargs = "?",
			desc = "Switch the material.nvim style",
			complete = function()
				return { "deep ocean", "darker", "lighter", "oceanic", "palenight" }
			end,
		})
	end,
}

return M
