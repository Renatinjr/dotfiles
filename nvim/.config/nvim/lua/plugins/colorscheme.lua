return {
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanso").setup({
				theme = "zen",
				compile = true,
				undercurl = true,
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = {},
				typeStyle = {},
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				background = {
					dark = "zen",
					light = "pearl",
				},
				overrides = function(colors)
					local palette = colors.palette
					local theme = colors.theme
					local custom_bg = "#1e1e27"

					return {
						-- Gutter and line numbers
						SignColumn = { bg = custom_bg },
						LineNr = { bg = custom_bg, fg = theme.ui.nontext },
						CursorLineNr = { bg = custom_bg, fg = theme.ui.fg, bold = true },
						FoldColumn = { bg = custom_bg, fg = theme.ui.nontext },

						-- CMP styling
						CmpItemAbbr = { fg = theme.ui.fg },
						CmpItemAbbrMatch = { fg = theme.syn.fun, bold = true },
						CmpItemAbbrMatchFuzzy = { fg = theme.syn.fun, bold = true },
						CmpItemMenu = { fg = theme.ui.nontext },

						-- Cmp item kinds
						CmpItemKindText = { fg = theme.ui.fg },
						CmpItemKindFunction = { fg = theme.syn.fun },
						CmpItemKindVariable = { fg = theme.syn.identifier },
						CmpItemKindClass = { fg = theme.syn.type },
						CmpItemKindInterface = { fg = theme.syn.type },
						CmpItemKindModule = { fg = theme.syn.preproc },
						CmpItemKindProperty = { fg = theme.syn.identifier },
						CmpItemKindKeyword = { fg = theme.syn.keyword },
						CmpItemKindSnippet = { fg = theme.syn.special1 },

						-- Cmp borders and selection
						CmpBorder = { fg = theme.ui.nontext, bg = custom_bg },
						CmpDocBorder = { bg = custom_bg },

						-- Pmenu
						Pmenu = { bg = custom_bg },
						PmenuSel = { bg = theme.ui.bg_p2, fg = theme.syn.fun, bold = true },

						-- Window separators
						WinSeparator = { fg = custom_bg, bg = custom_bg },

						-- NvimTree styling
						NvimTreeVertSplit = { bg = custom_bg, fg = custom_bg },
						NvimTreeWinSeparator = { bg = custom_bg, fg = custom_bg },
						NvimTreeFloatBorder = { bg = custom_bg, fg = custom_bg },
						NvimTreeNormal = { bg = custom_bg },
						NvimTreeNormalNC = { bg = custom_bg },

						-- Background overrides
						Normal = { bg = custom_bg },
						NormalFloat = { bg = custom_bg },
						NormalNC = { bg = custom_bg },
						FloatBorder = { bg = custom_bg, fg = theme.ui.nontext },

						-- Tree folder icons
						NvimTreeFolderIcon = { fg = theme.ui.nontext },
						NvimTreeOpenedFolderIcon = { fg = theme.ui.nontext },
						NvimTreeClosedFolderIcon = { fg = theme.ui.nontext },

						-- FzfLua
						FzfLuaPointer = { fg = theme.syn.special1 },

						-- Comments and keywords italic
						Comment = { fg = theme.syn.comment, italic = true },
						["@keyword"] = { italic = true },
						["@type.qualifier"] = { italic = true },
					}
				end,

				colors = {
					palette = {},
					theme = {
						zen = {},
						all = {},
					},
				},
			})

			vim.cmd("colorscheme kanso-zen")
			vim.opt.background = "dark"

			-- Additional custom highlights
			vim.api.nvim_set_hl(0, "NvimTreeFolderArrowClosed", { fg = "#64748b" })
			vim.api.nvim_set_hl(0, "NvimTreeFolderArrowOpen", { fg = "#64748b" })
		end,
	},
}
