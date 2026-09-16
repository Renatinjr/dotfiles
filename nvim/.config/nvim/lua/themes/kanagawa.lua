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

-- Kanagawa Wave palette (matched to VSCode kanagawa-wave theme)
function M.palette()
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

		nvim_tree = lib.make_nvim_tree({
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

-- Kanagawa Wave (available via :colorscheme kanagawa-wave)
-- Colors matched to the VSCode Kanagawa theme by metapho-re
M.spec = {
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
}

return M
