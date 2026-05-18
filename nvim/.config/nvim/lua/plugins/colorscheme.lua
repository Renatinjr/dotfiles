-- Colorschemes: kanso-zen (active), serenity, rose-pine, kanagawa, jellybeans & koda (available)
return {
	-- Serenity
	{
		"oskarnurm/koda.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("koda").setup({
				transparent = false, -- enable for transparent backgrounds

				-- Set the variants to use when auto-switching based on vim.o.background
				-- Valid values: 'dark', 'light', 'moss', 'glade'
				theme = {
					dark = "dark",
					light = "light",
				},

				-- Automatically enable highlights only for plugins installed by your plugin manager
				-- Currently only supports `lazy.nvim`, `mini.deps` and `vim.pack`
				auto = true, -- disable to load ALL available plugin highlights

				cache = true, -- caches the theme for better performance

				-- Style to be applied to different syntax groups
				-- Common use case would be to set either `italic = true` or `bold = true` for a desired group
				-- See `:help nvim_set_hl` for more valid values
				styles = {
					functions = { bold = true },
					keywords = {},
					comments = {},
					strings = {},
					constants = {}, -- includes numbers, booleans
				},

				-- Override colors for the active variant
				-- Available keys (e.g., 'func') can be found in lua/koda/palette/
				colors = {
					-- func = "#4078F2",
					-- keyword = "#A627A4",
				},

				-- Comprehensive override block — mirrors the depth of the kanso
				-- block below, but mapped to koda's flat palette (palette/dark.lua).
				-- Both fg and bg are set everywhere kanso sets them; we keep
				-- koda's near-monochrome aesthetic (most syntax = gray/white).
				on_highlights = function(hl, c)
					local fg = "#DCD7BA" -- #C5C9C7

					-- ── EDITOR UI ─────────────────────────────────────────
					hl.Normal = { bg = c.bg, fg = fg }
					hl.NormalFloat = { bg = c.bg, fg = fg }
					hl.NormalNC = { bg = c.bg, fg = fg }
					hl.SignColumn = { bg = c.bg, fg = c.dim }
					hl.LineNr = { bg = c.bg, fg = c.dim }
					hl.LineNrAbove = { bg = c.bg, fg = c.dim }
					hl.LineNrBelow = { bg = c.bg, fg = c.dim }
					hl.CursorLineNr = { bg = c.bg, fg = c.fg, bold = true }
					hl.CursorLine = { bg = c.line }
					hl.FoldColumn = { bg = c.bg, fg = c.dim }
					hl.Folded = { bg = c.line, fg = c.comment }
					hl.WinSeparator = { bg = c.bg, fg = c.line }
					hl.StatusLine = { bg = c.line, fg = c.fg }
					hl.StatusLineNC = { bg = c.bg, fg = c.dim }
					hl.Visual = { bg = c.dim, fg = c.fg }
					hl.VisualNOS = { bg = c.dim, fg = c.fg }
					hl.NonText = { bg = c.bg, fg = c.dim }
					hl.Whitespace = { bg = c.bg, fg = c.dim }
					hl.VertSplit = { bg = c.bg, fg = c.line }
					hl.ColorColumn = { bg = c.line }
					hl.Conceal = { bg = c.bg, fg = c.comment }
					hl.Directory = { bg = c.bg, fg = c.info }
					hl.EndOfBuffer = { bg = c.bg, fg = c.bg }
					hl.ErrorMsg = { bg = c.bg, fg = c.danger }
					hl.WarningMsg = { bg = c.bg, fg = c.warning }
					hl.ModeMsg = { bg = c.bg, fg = c.fg, bold = true }
					hl.MoreMsg = { bg = c.bg, fg = c.info }
					hl.Question = { bg = c.bg, fg = c.info }
					hl.Title = { bg = c.bg, fg = c.info, bold = true }
					hl.WildMenu = { bg = c.line, fg = c.fg }

					-- ── Cursor ────────────────────────────────────────────
					hl.Cursor = { bg = c.fg, fg = c.bg }
					hl.lCursor = { bg = c.fg, fg = c.bg }
					hl.CursorIM = { bg = c.fg, fg = c.bg }
					hl.TermCursor = { bg = c.fg, fg = c.bg }

					-- ── Tabs ──────────────────────────────────────────────
					hl.TabLine = { bg = c.bg, fg = c.dim }
					hl.TabLineSel = { bg = c.line, fg = c.fg }
					hl.TabLineFill = { bg = c.bg, fg = c.dim }

					-- ── Floating windows / Hover ──────────────────────────
					hl.FloatBorder = { bg = c.bg, fg = c.dim }
					hl.FloatTitle = { bg = c.bg, fg = c.info, bold = true }

					-- ── Pmenu / Completion ────────────────────────────────
					hl.Pmenu = { bg = c.line, fg = c.fg }
					hl.PmenuSel = { bg = c.dim, fg = c.fg, bold = true }
					hl.PmenuSbar = { bg = c.line }
					hl.PmenuThumb = { bg = c.dim }
					hl.CmpItemAbbr = { bg = c.line, fg = c.fg }
					hl.CmpItemAbbrMatch = { bg = c.line, fg = c.info, bold = true }
					hl.CmpItemAbbrMatchFuzzy = { bg = c.line, fg = c.info, bold = true }
					hl.CmpItemAbbrDeprecated = { bg = c.line, fg = c.comment, strikethrough = true }
					hl.CmpItemMenu = { bg = c.line, fg = c.comment }
					hl.CmpItemKindFunction = { bg = c.line, fg = fg }
					hl.CmpItemKindMethod = { bg = c.line, fg = fg }
					hl.CmpItemKindVariable = { bg = c.line, fg = c.fg }
					hl.CmpItemKindClass = { bg = c.line, fg = c.type }
					hl.CmpItemKindInterface = { bg = c.line, fg = c.type }
					hl.CmpItemKindModule = { bg = c.line, fg = c.const }
					hl.CmpItemKindKeyword = { bg = c.line, fg = c.keyword }
					hl.CmpItemKindSnippet = { bg = c.line, fg = fg }
					hl.CmpItemKindText = { bg = c.line, fg = c.fg }
					hl.CmpItemKindProperty = { bg = c.line, fg = c.const }
					hl.CmpItemKindConstant = { bg = c.line, fg = c.const }
					hl.CmpItemKindEnum = { bg = c.line, fg = c.type }
					hl.CmpItemKindEnumMember = { bg = c.line, fg = c.const }
					hl.CmpItemKindStruct = { bg = c.line, fg = c.type }
					hl.CmpItemKindField = { bg = c.line, fg = c.const }
					hl.CmpItemKindOperator = { bg = c.line, fg = c.operator }
					hl.CmpItemKindTypeParameter = { bg = c.line, fg = c.type }
					hl.CmpBorder = { bg = c.bg, fg = c.dim }
					hl.CmpDocBorder = { bg = c.bg, fg = c.dim }

					-- ── SYNTAX (minimal aesthetic) ────────────────────────
					hl.Comment = { fg = c.comment, italic = true }
					hl.String = { fg = fg }
					hl.Character = { fg = fg }
					hl.Number = { fg = c.const }
					hl.Float = { fg = c.const }
					hl.Boolean = { fg = c.const }
					hl.Constant = { fg = c.const }
					hl.Function = { fg = fg, bold = true }
					hl.Keyword = { fg = c.keyword }
					hl.Statement = { fg = c.keyword, bold = true }
					hl.Conditional = { fg = c.keyword, bold = true }
					hl.Repeat = { fg = c.keyword, bold = true }
					hl.Exception = { fg = c.danger, bold = true }
					hl.StorageClass = { fg = c.keyword }
					hl.Structure = { fg = c.keyword }
					hl.Typedef = { fg = c.keyword }
					hl.Type = { fg = c.type }
					hl.Operator = { fg = c.operator }
					hl.Identifier = { fg = c.fg }
					hl.PreProc = { fg = fg }
					hl.Include = { fg = c.keyword }
					hl.Define = { fg = c.keyword }
					hl.Macro = { fg = fg }
					hl.PreCondit = { fg = c.keyword }
					hl.Special = { fg = fg }
					hl.SpecialChar = { fg = fg }
					hl.SpecialComment = { fg = c.comment, italic = true }
					hl.Tag = { fg = c.const }
					hl.Delimiter = { fg = c.dim }
					hl.Debug = { fg = c.danger }
					hl.Label = { fg = c.const }
					hl.Underlined = { fg = c.info, underline = true }

					-- ── TREESITTER ────────────────────────────────────────
					hl["@keyword"] = { fg = c.keyword }
					hl["@keyword.function"] = { fg = c.keyword }
					hl["@keyword.operator"] = { fg = c.operator }
					hl["@keyword.import"] = { fg = c.keyword }
					hl["@keyword.export"] = { fg = c.keyword }
					hl["@keyword.return"] = { fg = c.keyword, bold = true }
					hl["@keyword.exception"] = { fg = c.danger, bold = true }
					hl["@keyword.conditional"] = { fg = c.keyword, bold = true }
					hl["@keyword.repeat"] = { fg = c.keyword, bold = true }
					hl["@keyword.storage"] = { fg = c.keyword }
					hl["@keyword.directive"] = { fg = c.keyword }
					hl["@keyword.modifier"] = { fg = c.keyword }

					hl["@function"] = { fg = fg, bold = true }
					hl["@function.call"] = { fg = fg }
					hl["@function.builtin"] = { fg = fg }
					hl["@function.method"] = { fg = fg }
					hl["@function.method.call"] = { fg = fg }
					hl["@function.macro"] = { fg = fg }
					hl["@constructor"] = { fg = c.type }

					hl["@variable"] = { fg = c.fg }
					hl["@variable.builtin"] = { fg = c.danger }
					hl["@variable.parameter"] = { fg = c.fg }
					hl["@variable.member"] = { fg = c.const }

					hl["@type"] = { fg = c.type }
					hl["@type.builtin"] = { fg = c.type }
					hl["@type.definition"] = { fg = c.type }
					hl["@type.qualifier"] = { fg = c.keyword }

					hl["@constant"] = { fg = c.const }
					hl["@constant.builtin"] = { fg = c.const }
					hl["@constant.macro"] = { fg = c.const }

					hl["@string"] = { fg = fg }
					hl["@string.escape"] = { fg = fg }
					hl["@string.regex"] = { fg = fg }
					hl["@string.special"] = { fg = fg }
					hl["@string.special.url"] = { fg = c.info, underline = true }
					hl["@string.special.symbol"] = { fg = fg }

					hl["@number"] = { fg = c.const }
					hl["@number.float"] = { fg = c.const }
					hl["@boolean"] = { fg = c.const }

					hl["@operator"] = { fg = c.operator }
					hl["@punctuation.bracket"] = { fg = c.dim }
					hl["@punctuation.delimiter"] = { fg = c.dim }
					hl["@punctuation.special"] = { fg = fg }

					hl["@tag"] = { fg = c.const }
					hl["@tag.builtin"] = { fg = c.const }
					hl["@tag.attribute"] = { fg = c.keyword }
					hl["@tag.delimiter"] = { fg = c.dim }

					hl["@property"] = { fg = c.const }
					hl["@field"] = { fg = c.const }

					hl["@label"] = { fg = c.const }
					hl["@attribute"] = { fg = c.keyword }
					hl["@attribute.builtin"] = { fg = c.keyword }

					hl["@module"] = { fg = c.const }
					hl["@module.builtin"] = { fg = c.const }

					hl["@comment"] = { fg = c.comment, italic = true }
					hl["@comment.documentation"] = { fg = c.comment, italic = true }
					hl["@comment.todo"] = { fg = c.info, bold = true }
					hl["@comment.note"] = { fg = c.info, bold = true }
					hl["@comment.warning"] = { fg = c.warning, bold = true }
					hl["@comment.error"] = { fg = c.danger, bold = true }

					-- Markdown / Markup
					hl["@markup.heading"] = { fg = c.info, bold = true }
					hl["@markup.heading.1"] = { fg = c.info, bold = true }
					hl["@markup.heading.2"] = { fg = c.info, bold = true }
					hl["@markup.heading.3"] = { fg = c.info, bold = true }
					hl["@markup.italic"] = { fg = c.fg, italic = true }
					hl["@markup.strong"] = { bold = true }
					hl["@markup.strikethrough"] = { strikethrough = true }
					hl["@markup.underline"] = { fg = c.info, underline = true }
					hl["@markup.quote"] = { italic = true }
					hl["@markup.link"] = { fg = c.info }
					hl["@markup.link.url"] = { fg = c.info, underline = true }
					hl["@markup.link.label"] = { fg = c.highlight }
					hl["@markup.raw"] = { fg = fg }
					hl["@markup.raw.block"] = { fg = fg }
					hl["@markup.list"] = { fg = c.fg }
					hl["@markup.list.checked"] = { fg = c.success }
					hl["@markup.list.unchecked"] = { fg = c.comment }

					-- Diff
					hl["@diff.plus"] = { fg = c.success }
					hl["@diff.minus"] = { fg = c.danger }
					hl["@diff.delta"] = { fg = c.warning }

					-- ── LSP SEMANTIC TOKENS ──────────────────────────────
					hl["@lsp.type.parameter"] = { fg = c.fg }
					hl["@lsp.type.variable"] = { fg = c.fg }
					hl["@lsp.type.property"] = { fg = c.const }
					hl["@lsp.type.function"] = { fg = fg }
					hl["@lsp.type.method"] = { fg = fg }
					hl["@lsp.type.macro"] = { fg = fg }
					hl["@lsp.type.enum"] = { fg = c.type }
					hl["@lsp.type.enumMember"] = { fg = c.const }
					hl["@lsp.type.struct"] = { fg = c.type }
					hl["@lsp.type.class"] = { fg = c.type }
					hl["@lsp.type.interface"] = { fg = c.type }
					hl["@lsp.type.namespace"] = { fg = c.const }
					hl["@lsp.type.type"] = { fg = c.type }
					hl["@lsp.type.typeParameter"] = { fg = c.type }
					hl["@lsp.type.keyword"] = { fg = c.keyword }
					hl["@lsp.type.operator"] = { fg = c.operator }
					hl["@lsp.mod.readonly"] = {}
					hl["@lsp.mod.defaultLibrary"] = {}
					hl["@lsp.typemod.function.declaration"] = { fg = fg, bold = true }
					hl["@lsp.typemod.function.defaultLibrary"] = { fg = fg }
					hl["@lsp.typemod.variable.readonly"] = { fg = c.fg }
					hl["@lsp.typemod.variable.defaultLibrary"] = { fg = c.fg }
					hl["@lsp.typemod.keyword.controlFlow"] = { fg = c.keyword, bold = true }

					-- ── BRACKET PAIR COLORIZATION ────────────────────────
					hl.RainbowDelimiterRed = { fg = c.danger }
					hl.RainbowDelimiterYellow = { fg = c.warning }
					hl.RainbowDelimiterBlue = { fg = c.info }
					hl.RainbowDelimiterOrange = { fg = c.orange }
					hl.RainbowDelimiterGreen = { fg = c.success }
					hl.RainbowDelimiterViolet = { fg = c.highlight }

					-- ── LANGUAGE-SPECIFIC ────────────────────────────────
					hl["@property.json"] = { fg = c.info }
					hl.jsonKeyword = { fg = c.info }
					hl["@property.css"] = { fg = c.type }
					hl["@property.scss"] = { fg = c.type }
					hl["@field.yaml"] = { fg = c.const }
					hl["@property.toml"] = { fg = c.const }

					-- ══════════════════════════════════════════════════════
					-- PLUGIN HIGHLIGHTS
					-- ══════════════════════════════════════════════════════

					-- FzfLua
					hl.FzfLuaNormal = { bg = c.bg, fg = c.fg }
					hl.FzfLuaBorder = { bg = c.bg, fg = c.dim }
					hl.FzfLuaCursorLine = { bg = c.line, fg = c.highlight }
					hl.FzfLuaTitle = { bg = c.bg, fg = c.info, bold = true }
					hl.FzfLuaPrompt = { bg = c.bg, fg = c.highlight, bold = true }
					hl.FzfLuaPointer = { bg = c.bg, fg = c.highlight, bold = true }
					hl.FzfLuaMarker = { bg = c.bg, fg = c.success }
					hl.FzfLuaSpinner = { bg = c.bg, fg = c.highlight, bold = true }
					hl.FzfLuaHeader = { bg = c.bg, fg = c.comment }
					hl.FzfLuaPreviewTitle = { bg = c.bg, fg = c.highlight, bold = true }

					-- NvimTree / ChadTree (chadtree uses Pmenu+Normal, NeoTree group covers nvim-tree)
					hl.NeoTreeNormal = { bg = c.bg, fg = c.fg }
					hl.NeoTreeNormalNC = { bg = c.bg, fg = c.fg }
					hl.NeoTreeWinSeparator = { bg = c.bg, fg = c.bg }
					hl.NeoTreeCursorLine = { bg = c.line }
					hl.NeoTreeIndentMarker = { bg = c.bg, fg = c.dim }
					hl.NeoTreeGitAdded = { bg = c.bg, fg = c.success }
					hl.NeoTreeGitModified = { bg = c.bg, fg = c.warning }
					hl.NeoTreeGitDeleted = { bg = c.bg, fg = c.danger }
					hl.NeoTreeGitUntracked = { bg = c.bg, fg = c.highlight }
					hl.NeoTreeGitIgnored = { bg = c.bg, fg = c.comment }
					hl.NeoTreeFileName = { bg = c.bg, fg = c.fg }
					hl.NeoTreeDirectoryName = { bg = c.bg, fg = c.info }
					hl.NeoTreeDirectoryIcon = { bg = c.bg, fg = c.info }
					hl.NeoTreeRootName = { bg = c.bg, fg = c.highlight, bold = true }
					hl.NeoTreeDotfile = { bg = c.bg, fg = c.comment }

					-- Diagnostics
					hl.DiagnosticError = { fg = c.danger }
					hl.DiagnosticWarn = { fg = c.warning }
					hl.DiagnosticInfo = { fg = c.info }
					hl.DiagnosticHint = { fg = c.highlight }
					hl.DiagnosticSignError = { bg = c.bg, fg = c.danger }
					hl.DiagnosticSignWarn = { bg = c.bg, fg = c.warning }
					hl.DiagnosticSignInfo = { bg = c.bg, fg = c.info }
					hl.DiagnosticSignHint = { bg = c.bg, fg = c.highlight }
					hl.DiagnosticVirtualTextError = { fg = c.danger, bg = "#1A0B0B" }
					hl.DiagnosticVirtualTextWarn = { fg = c.warning, bg = "#1A1408" }
					hl.DiagnosticVirtualTextInfo = { fg = c.info, bg = "#0B141A" }
					hl.DiagnosticVirtualTextHint = { fg = c.highlight, bg = "#0B1018" }
					hl.DiagnosticUnderlineError = { undercurl = true, sp = c.danger }
					hl.DiagnosticUnderlineWarn = { undercurl = true, sp = c.warning }
					hl.DiagnosticUnderlineInfo = { undercurl = true, sp = c.info }
					hl.DiagnosticUnderlineHint = { undercurl = true, sp = c.highlight }

					-- Git signs
					hl.GitSignsAdd = { bg = c.bg, fg = c.success }
					hl.GitSignsChange = { bg = c.bg, fg = c.warning }
					hl.GitSignsDelete = { bg = c.bg, fg = c.danger }
					hl.GitSignsCurrentLineBlame = { bg = c.bg, fg = c.comment }

					-- Diff
					hl.DiffAdd = { bg = "#0F1A0F", fg = c.success }
					hl.DiffChange = { bg = "#1A1408", fg = c.warning }
					hl.DiffDelete = { bg = "#1A0B0B", fg = c.danger }
					hl.DiffText = { bg = c.line, fg = c.info }

					-- Indent blankline
					hl.IblIndent = { fg = c.line }
					hl.IblScope = { fg = c.dim }

					-- Inlay hints
					hl.LspInlayHint = { bg = c.bg, fg = c.dim, italic = true }

					-- Bracket match
					hl.MatchParen = { bg = c.dim, fg = c.fg, bold = true }

					-- Search
					hl.Search = { bg = c.dim, fg = c.fg }
					hl.IncSearch = { bg = c.warning, fg = c.bg }
					hl.CurSearch = { bg = c.warning, fg = c.bg }
					hl.Substitute = { bg = c.danger, fg = c.bg }

					-- Word highlight (LSP references / illuminate)
					hl.LspReferenceText = { bg = c.line, fg = c.fg }
					hl.LspReferenceRead = { bg = c.line, fg = c.fg }
					hl.LspReferenceWrite = { bg = c.line, fg = c.fg, underline = true }
					hl.IlluminatedWordText = { bg = c.line, fg = c.fg }
					hl.IlluminatedWordRead = { bg = c.line, fg = c.fg }
					hl.IlluminatedWordWrite = { bg = c.line, fg = c.fg, underline = true }

					-- Which-key
					hl.WhichKey = { bg = c.bg, fg = c.highlight }
					hl.WhichKeyDesc = { bg = c.bg, fg = c.fg }
					hl.WhichKeyGroup = { bg = c.bg, fg = c.info }
					hl.WhichKeySeparator = { bg = c.bg, fg = c.comment }

					-- Noice / Notify
					hl.NotifyERRORBorder = { fg = c.danger }
					hl.NotifyWARNBorder = { fg = c.warning }
					hl.NotifyINFOBorder = { fg = c.info }
					hl.NotifyDEBUGBorder = { fg = c.comment }
					hl.NotifyTRACEBorder = { fg = c.highlight }
					hl.NotifyERRORIcon = { fg = c.danger }
					hl.NotifyWARNIcon = { fg = c.warning }
					hl.NotifyINFOIcon = { fg = c.info }
					hl.NotifyDEBUGIcon = { fg = c.comment }
					hl.NotifyTRACEIcon = { fg = c.highlight }
					hl.NotifyERRORTitle = { fg = c.danger }
					hl.NotifyWARNTitle = { fg = c.warning }
					hl.NotifyINFOTitle = { fg = c.info }
					hl.NotifyDEBUGTitle = { fg = c.comment }
					hl.NotifyTRACETitle = { fg = c.highlight }
				end,
			})

			vim.cmd("colorscheme koda")
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
				variant = "main",
				transparent = true,
				dark_variant = "main",
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
					Normal = { bg = "#191724" },
					NormalFloat = { bg = "#1f1d2e" },
					NormalNC = { bg = "#191724" },
					SignColumn = { bg = "#191724" },
					LineNr = { bg = "#191724", fg = "muted" },
					CursorLineNr = { bg = "#191724", fg = "text", bold = true },
					FoldColumn = { bg = "#191724" },
					WinSeparator = { fg = "#26233a", bg = "#191724" },
					StatusLine = { bg = "#26233a", fg = "text" },
					StatusLineNC = { bg = "#1f1d2e", fg = "muted" },

					-- Pmenu / Completion
					Pmenu = { bg = "#1f1d2e", fg = "text" },
					PmenuSel = { bg = "#26233a", fg = "rose", bold = true },
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
					NeoTreeNormal = { bg = "#191724" },
					NeoTreeNormalNC = { bg = "#191724" },
					NeoTreeWinSeparator = { fg = "#191724", bg = "#191724" },
					NeoTreeCursorLine = { bg = "#26233a" },
					NeoTreeGitAdded = { fg = "foam" },
					NeoTreeGitModified = { fg = "rose" },
					NeoTreeGitDeleted = { fg = "love" },
					NeoTreeGitUntracked = { fg = "iris" },

					-- Diagnostics
					DiagnosticVirtualTextError = { fg = "love", bg = "#2a1f29" },
					DiagnosticVirtualTextWarn = { fg = "gold", bg = "#28251e" },
					DiagnosticVirtualTextInfo = { fg = "foam", bg = "#1e2a2d" },
					DiagnosticVirtualTextHint = { fg = "iris", bg = "#231f2e" },

					-- Git signs
					GitSignsAdd = { fg = "foam" },
					GitSignsChange = { fg = "rose" },
					GitSignsDelete = { fg = "love" },

					-- Indent blankline
					IblIndent = { fg = "#26233a" },
					IblScope = { fg = "#524f67" },
				},
			})

			-- vim.cmd("colorscheme rose-pine")
			vim.opt.background = "dark"
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
			-- vim.cmd("colorscheme kanagawa-dragon")
			vim.opt.background = "dark"
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
				-- vim.cmd("colorscheme jellybeans")
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
				transparent = false,
				dimInactive = true,
				terminalColors = true,
				background = { dark = "zen", light = "pearl" },
				overrides = function(colors)
					local p = colors.palette
					local t = colors.theme
					local bg = p.zenBg0 -- #090E13
					local bg1 = p.zenBg1 -- #1C1E25
					local bg2 = p.zenBg2 -- #22262D
					local bg3 = p.zenBg3 -- #393B44
					local fg = "#DCD7BA" -- #C5C9C7
					local fg2 = p.fg2 -- #f2f1ef
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
						DiagnosticVirtualTextError = { fg = p.red, bg = "#130A0C" },
						DiagnosticVirtualTextWarn = { fg = p.orange, bg = "#15110A" },
						DiagnosticVirtualTextInfo = { fg = p.blue2, bg = "#0A0F13" },
						DiagnosticVirtualTextHint = { fg = p.green4, bg = "#0A1210" },
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
						LspReferenceText = { bg = bg2, fg = "#DCD7BA" },
						LspReferenceRead = { bg = bg2, fg = "#DCD7BA" },
						LspReferenceWrite = { bg = bg2, fg = "#DCD7BA", underline = true },
						IlluminatedWordText = { bg = bg2, fg = "#DCD7BA" },
						IlluminatedWordRead = { bg = bg2, fg = "#DCD7BA" },
						IlluminatedWordWrite = { bg = bg2, fg = "#DCD7BA", underline = true },

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
			-- vim.cmd("colorscheme kanso-zen")
			vim.opt.background = "dark"
		end,
	},
}
