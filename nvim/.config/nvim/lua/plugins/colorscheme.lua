return {
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanso").setup({
				style = "dark", -- "dark" or "light"
				bold = true, -- enable bold fonts
				italics = true, -- enable italics
				compile = true, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = {},
				typeStyle = {},
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}

				overrides = function(colors)
					local gutter_bg = "#090e13"
					local custom_bg = "#0A0E14"
					return {
						SignColumn = { bg = gutter_bg },
						LineNr = {
							bg = gutter_bg,
							fg = colors.comment or "#727169",
						},
						CursorLineNr = {
							bg = gutter_bg,
							fg = colors.foreground or "#DCD7BA",
							bold = true,
						},
						FoldColumn = {
							bg = gutter_bg,
							fg = colors.comment or "#727169",
						},
						BlinkCmpMenu = {
							bg = colors.bg,
							fg = "#DCD7BA",
						},
						BlinkCmpMenuSelection = {
							bg = "#2A2A37",
							fg = "#7E9CD8",
							bold = true,
						},
						BlinkCmpMenuBorder = {
							fg = "#54546D",
							bg = colors.bg,
						},

						BlinkCmpDoc = {
							bg = colors.bg,
						},

						BlinkCmpLabel = {
							fg = "#DCD7BA",
						},
						BlinkCmpLabelMatch = {
							fg = "#7E9CD8",
							bold = true,
						},
						BlinkCmpLabelDetails = {
							fg = "#727169",
						},

						-- Vibrant Kind Colors
						BlinkCmpKind = {
							fg = "#957FB8",
						},
						BlinkCmpKindText = {
							fg = "#DCD7BA",
						},
						BlinkCmpKindFunction = {
							fg = "#7E9CD8",
						},
						BlinkCmpKindVariable = {
							fg = "#E46876",
						},
						BlinkCmpKindClass = {
							fg = "#FFA066",
						},
						BlinkCmpKindInterface = {
							fg = "#957FB8",
						},
						BlinkCmpKindModule = {
							fg = "#7FB4CA",
						},
						BlinkCmpKindProperty = {
							fg = "#98BB6C",
						},
						BlinkCmpKindKeyword = {
							fg = "#D27E99",
						},
						BlinkCmpKindSnippet = {
							fg = "#7FB4CA",
						},
						FzfLuaPointer = { fg = colors.palette.carpYellow },
						NvimTreeVertSplit = { bg = "#0A0E14", fg = "#0A0E14" },
						NvimTreeWinSeparator = { bg = "#0A0E14", fg = "#0A0E14" },
						Normal = { bg = custom_bg },
						NormalFloat = { bg = custom_bg },
						NormalNC = { bg = custom_bg },
					}
				end,

				plugins = {
					treesitter = true,
					cmp = true,
					gitsigns = true,
					telescope = true,
					nvimtree = true,
					bufferline = true,
					lsp = true,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = false,
					},
					which_key = true,
					symbols_outline = true,
					dashboard = true,
					neogit = true,
					vim_sneak = true,
					fern = true,
					barbar = true,
					glyph_palette = true,
				},

				colors = {
					palette = {
						fg = "#dcd7ba",
						bg = "#0a0e14",
					},
					theme = { zen = {}, pearl = {}, ink = {}, all = {} },
				},
			})

			vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = "#64748b" }) -- Sets opened folder icon to red
			vim.api.nvim_set_hl(0, "NvimTreeClosedFolderIcon", { fg = "#64748b" }) -- Sets closed folder icon to green
			vim.api.nvim_set_hl(0, "NvimTreeFolderArrowClosed", { fg = "#64748b" }) -- Red arrow when closed
			vim.api.nvim_set_hl(0, "NvimTreeFolderArrowOpen", { fg = "#64748b" }) -- Green arrow when open
			-- vim.cmd("colorscheme kanso-zen")
			vim.opt.background = "dark"
			-- vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#1F1F28" })
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "main", -- "main", "moon", or "dawn"
				dark_variant = "main", -- "main", "moon"
				light_variant = "dawn",
				dim_inactive_windows = false,
				extend_background_behind_borders = false,

				styles = {
					bold = true,
					italic = true,
					transparency = false,
				},

				groups = {
					border = "muted",
					comment = "muted",
					link = "iris",
					punctuation = "subtle",

					error = "love",
					hint = "iris",
					info = "foam",
					warn = "gold",

					headings = {
						h1 = "iris",
						h2 = "foam",
						h3 = "rose",
						h4 = "gold",
						h5 = "pine",
						h6 = "foam",
					},
				},

				highlight_groups = {
					-- Custom background colors
					ColorColumn = { bg = "surface" },
					CursorLine = { bg = "surface" },
					CursorLineNr = { fg = "text", bg = "base" },

					-- Gutter customizations
					SignColumn = { bg = "#0a0912" },
					LineNr = { bg = "#0a0912", fg = "muted" },
					FoldColumn = { bg = "#0a0912", fg = "muted" },

					-- CMP customizations
					CmpItemMenu = { fg = "text" },
					CmpItemMenuSelection = { bg = "highlight_med", fg = "iris", bold = true },
					CmpItemMenuBorder = { fg = "overlay", bg = "base" },

					-- CMP Kind Colors (Rose Pine palette)
					CmpItemKind = { fg = "gold" },
					CmpItemKindText = { fg = "text" },
					CmpItemKindFunction = { fg = "foam" },
					CmpItemKindVariable = { fg = "love" },
					CmpItemKindClass = { fg = "gold" },
					CmpItemKindInterface = { fg = "iris" },
					CmpItemKindModule = { fg = "foam" },
					CmpItemKindProperty = { fg = "pine" },
					CmpItemKindKeyword = { fg = "love" },
					CmpItemKindSnippet = { fg = "rose" },

					-- Tree customizations
					NvimTreeWinSeparator = { bg = "#0f0d1a", fg = "#0f0d1a" },
					NvimTreeNormal = { bg = "#0f0d1a" },
					NvimTreeNormalNC = { bg = "#0f0d1a" },

					-- Background customizations
					Normal = { bg = "#0f0d1a" },
					NormalFloat = { bg = "#0f0d1a" },
					NormalNC = { bg = "#0f0d1a" },
					FloatBorder = { bg = "#0f0d1a", fg = "#0f0d1a" },

					-- WinSeparator customization
					WinSeparator = { fg = "overlay", bg = "#0f0d1a" },

					-- Telescope customizations
					TelescopeBorder = { fg = "overlay", bg = "#0f0d1a" },
					TelescopeNormal = { bg = "#0f0d1a" },
					TelescopePreviewBorder = { fg = "overlay", bg = "#0f0d1a" },
					TelescopePreviewNormal = { bg = "#0f0d1a" },
					TelescopePreviewTitle = { fg = "text", bg = "#0f0d1a" },
					TelescopePromptBorder = { fg = "overlay", bg = "#0f0d1a" },
					TelescopePromptNormal = { bg = "#0f0d1a" },
					TelescopePromptTitle = { fg = "text", bg = "#0f0d1a" },
					TelescopeResultsBorder = { fg = "overlay", bg = "#0f0d1a" },
					TelescopeResultsNormal = { bg = "#0f0d1a" },
					TelescopeResultsTitle = { fg = "text", bg = "#0f0d1a" },

					-- Diagnostic customizations
					DiagnosticVirtualTextError = { bg = "none" },
					DiagnosticVirtualTextWarn = { bg = "none" },
					DiagnosticVirtualTextInfo = { bg = "none" },
					DiagnosticVirtualTextHint = { bg = "none" },

					-- Indent blankline
					IndentBlanklineChar = { fg = "overlay" },
					IndentBlanklineContextChar = { fg = "subtle" },

					-- WhichKey
					WhichKeyFloat = { bg = "#0f0d1a" },

					-- LSP Signature
					LspSignatureActiveParameter = { bg = "surface", fg = "gold" },
				},

				-- Before/After hooks for further customization
				before_highlight = function(group, highlight, palette)
					-- Disable all undercurl
					if highlight.undercurl then
						highlight.undercurl = false
					end

					-- Customize specific groups
					if group == "Comment" then
						highlight.italic = true
					end

					if group:match("^Diagnostic") then
						highlight.underline = false
					end
				end,
			})

			-- Set the colorscheme
			-- vim.cmd("colorscheme rose-pine")

			-- Custom folder icon colors
			vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = "#9ccfd8" })
			vim.api.nvim_set_hl(0, "NvimTreeClosedFolderIcon", { fg = "#9ccfd8" })
			vim.api.nvim_set_hl(0, "NvimTreeFolderArrowClosed", { fg = "#9ccfd8" })
			vim.api.nvim_set_hl(0, "NvimTreeFolderArrowOpen", { fg = "#9ccfd8" })
			vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#9ccfd8" })

			-- Additional customizations
			vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#26233a" })
			vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = "#ebbcba", bold = true })

			-- Set custom background for terminal buffers
			vim.api.nvim_set_hl(0, "Terminal", { bg = "#0f0d1a" })
			vim.api.nvim_set_hl(0, "TerminalBorder", { bg = "#0f0d1a", fg = "#0f0d1a" })

			-- Git signs customization
			vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#9ccfd8", bg = "#0a0912" })
			vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#f6c177", bg = "#0a0912" })
			vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#eb6f92", bg = "#0a0912" })

			-- Bufferline customizations (if using bufferline.nvim)
			vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "#0a0912", fg = "#6e6a86" })
			vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = "#0f0d1a", fg = "#e0def4", bold = true })
			vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { bg = "#0f0d1a", fg = "#0f0d1a" })
			vim.api.nvim_set_hl(0, "BufferLineSeparator", { bg = "#0a0912", fg = "#0a0912" })

			-- Status line customizations
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "#0a0912", fg = "#908caa" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#0a0912", fg = "#6e6a86" })

			-- Tab line customizations
			vim.api.nvim_set_hl(0, "TabLine", { bg = "#0a0912", fg = "#6e6a86" })
			vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#0f0d1a", fg = "#e0def4", bold = true })
			vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#0a0912" })
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				-- Kanagawa has three main variants: wave (default), dragon, lotus
				-- "dragon" is the darker variant similar to what you're looking for
				theme = "dragon",

				-- Style overrides
				overrides = function(colors)
					local theme = colors.theme
					local gutter_bg = "#090e13"
					local custom_bg = "#0A0E14"

					return {
						-- Gutter and line numbers
						SignColumn = { bg = gutter_bg },
						LineNr = {
							bg = gutter_bg,
							fg = colors.fujiGray or "#727169",
						},
						CursorLineNr = {
							bg = gutter_bg,
							fg = colors.fujiWhite or "#DCD7BA",
							bold = true,
						},
						FoldColumn = {
							bg = gutter_bg,
							fg = colors.fujiGray or "#727169",
						},

						-- CMP styling (using Kanagawa's built-in groups where possible)
						CmpItemAbbr = { fg = colors.fujiWhite or "#DCD7BA" },
						CmpItemAbbrMatch = {
							fg = colors.crystalBlue or "#7E9CD8",
							bold = true,
						},
						CmpItemAbbrMatchFuzzy = {
							fg = colors.crystalBlue or "#7E9CD8",
							bold = true,
						},
						CmpItemMenu = { fg = colors.fujiGray or "#727169" },

						-- Cmp item kinds with vibrant colors
						CmpItemKindText = { fg = colors.fujiWhite or "#DCD7BA" },
						CmpItemKindFunction = { fg = colors.crystalBlue or "#7E9CD8" },
						CmpItemKindVariable = { fg = colors.peachRed or "#E46876" },
						CmpItemKindClass = { fg = colors.autumnYellow or "#FFA066" },
						CmpItemKindInterface = { fg = colors.lotusPurple2 or "#957FB8" },
						CmpItemKindModule = { fg = colors.surimiOrange or "#FF9E64" },
						CmpItemKindProperty = { fg = colors.springGreen or "#98BB6C" },
						CmpItemKindKeyword = { fg = colors.sakuraPink or "#D27E99" },
						CmpItemKindSnippet = { fg = colors.waveAqua2 or "#7FB4CA" },

						-- Cmp borders and selection
						CmpBorder = { fg = colors.fujiGray or "#54546D", bg = colors.bg_dark or "#0A0E14" },
						CmpDocBorder = { bg = colors.bg_dark or "#0A0E14" },

						-- Pmenu (used by cmp)
						Pmenu = { bg = colors.bg_dark or "#0A0E14" },
						PmenuSel = {
							bg = colors.bg_highlight or "#2A2A37",
							fg = colors.crystalBlue or "#7E9CD8",
							bold = true,
						},

						-- Window separators
						WinSeparator = {
							fg = colors.bg_dark or "#0A0E14",
							bg = colors.bg_dark or "#0A0E14",
						},

						-- Tree styling
						NvimTreeVertSplit = {
							bg = custom_bg,
							fg = custom_bg,
						},
						NvimTreeWinSeparator = {
							bg = custom_bg,
							fg = custom_bg,
						},

						-- Background overrides
						Normal = { bg = custom_bg },
						NormalFloat = { bg = custom_bg },
						NormalNC = { bg = custom_bg },

						-- Tree folder icons (already defined, but you can override)
						NvimTreeFolderIcon = { fg = colors.fujiGray or "#64748b" },
						NvimTreeOpenedFolderIcon = { fg = colors.fujiGray or "#64748b" },
						NvimTreeClosedFolderIcon = { fg = colors.fujiGray or "#64748b" },

						-- Additional customizations from your config
						FzfLuaPointer = { fg = colors.carpYellow or "#E6C384" },

						-- Optional: Make comments italic if desired
						Comment = { fg = colors.fujiGray, italic = true },

						-- Optional: Make keywords italic
						["@keyword"] = { italic = true },
						["@type.qualifier"] = { italic = true },
					}
				end,

				-- Global settings
				compile = true, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = {},
				typeStyle = {},
				variablebuiltinStyle = {},

				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}

				colors = {
					-- You can override palette colors here if needed
					palette = {},
					theme = {
						-- Theme overrides - dragon is already dark, but you can customize further
						dragon = {
							bg = "#0A0E14", -- Your custom background
							bg_dark = "#090e13", -- Darker background for gutters
							bg_darker = "#080c11", -- Even darker
						},
					},
				},

				-- Plugin integrations
				-- Kanagawa has built-in support for many plugins
				integrations = {
					cmp = true,
					gitsigns = true,
					telescope = {
						enabled = true,
						-- style = "nvchad" -- Optional: different telescope styles
					},
					treesitter = true,
					treesitter_context = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
					},
					lsp_trouble = true,
					which_key = true,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = false,
					},
					dashboard = true,
					neogit = true,
					vim_sneak = true,
					fern = false, -- Kanagawa doesn't have fern by default, but overrides will work
					barbar = false, -- Kanagawa doesn't have barbar by default
					bufferline = {
						enabled = true,
						colors = {
							-- Optional: customize bufferline colors
						},
					},
					markdown = true,
					lightspeed = true,
					ts_rainbow = true,
					hop = true,
					notify = true,
					symbols_outline = true,
					mini = {
						enabled = true,
						indentscope_color = "", -- let Kanagawa decide
					},
					neotree = {
						enabled = true, -- NvimTree alternative
					},
					nvimtree = true,
				},
			})

			-- Apply the colorscheme
			vim.cmd("colorscheme kanagawa-dragon")
			vim.opt.background = "dark"

			-- Additional custom highlights (using Kanagawa's color names)
			vim.api.nvim_set_hl(0, "NvimTreeFolderArrowClosed", { fg = "#64748b" })
			vim.api.nvim_set_hl(0, "NvimTreeFolderArrowOpen", { fg = "#64748b" })

			-- Optional: If you want to use NvimTree instead of neotree
			-- These will override the Kanagawa defaults
			local colors = require("kanagawa.colors").setup({ theme = "dragon" })
			vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = colors.palette.fujiGray })
			vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = colors.palette.fujiGray })
			vim.api.nvim_set_hl(0, "NvimTreeClosedFolderIcon", { fg = colors.palette.fujiGray })

			-- Set WinSeparator color if not already set in overrides
			vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#0A0E14", bg = "#0A0E14" })
		end,
	},
}
