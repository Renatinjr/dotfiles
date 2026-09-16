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

-- Kanso palette (zen variant)
-- Kanso reads straight off the plugin, which is safe here because
-- kanso.colors.setup() takes the theme explicitly — it does not depend on which
-- variant happens to be loaded. Returns {} when the plugin isn't in memory yet;
-- M.build() catches that.
function M.palette(variant)
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

		nvim_tree = lib.make_nvim_tree({
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

-- Kanso Zen — minimal, muted palette for deep focus
M.spec = {
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
					DiagnosticVirtualTextError = { fg = p.red, bg = lib.blend(p.red, bg, 0.1) },
					DiagnosticVirtualTextWarn = { fg = p.orange, bg = lib.blend(p.orange, bg, 0.1) },
					DiagnosticVirtualTextInfo = { fg = p.blue2, bg = lib.blend(p.blue2, bg, 0.1) },
					DiagnosticVirtualTextHint = { fg = p.green4, bg = lib.blend(p.green4, bg, 0.1) },
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
}

return M
