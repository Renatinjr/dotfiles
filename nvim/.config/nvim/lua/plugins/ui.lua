-- UI components: bufferline, dashboard, icons, incline
return {
	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		event = { "BufReadPost" },
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
			{ "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
			{ "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
			{ "<leader>bc", "<cmd>bdelete<cr>", desc = "Close buffer" },
			{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
			{ "<leader>x", "<cmd>bd<CR>", desc = "Close buffer" },
		},
		config = function()
			local bufferline = require("bufferline")
			local theme = require("config.theme")

			bufferline.setup({
				options = {
					mode = "buffers",
					numbers = "none",
					close_command = "bdelete! %d",
					right_mouse_command = "bdelete! %d",
					left_mouse_command = "buffer %d",
					middle_mouse_command = nil,
					indicator = {
						icon = "▎",
						style = "underline",
					},
					hover = {
						enabled = true,
						delay = 200,
						reveal = { "close" },
					},
					show_buffer_close_icons = false,
					separator_style = { "", "" },
					always_show_bufferline = false,
					underline = true,
					buffer_close_icon = "󰅙",
					modified_icon = "",
					close_icon = "󰅙",
					left_trunc_marker = "",
					right_trunc_marker = "",
					max_name_length = 14,
					max_prefix_length = 13,
					tab_size = 10,
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,
					format = function(opts)
						local duplicates = require("bufferline.utils").get_duplicates(opts)
						local name = opts.name
						local path = vim.fn.fnamemodify(name, ":h")
						local filename = vim.fn.fnamemodify(name, ":t")

						if duplicates[name] then
							return string.format(
								"%s/%s",
								"%#BufferLinePath#" .. path .. "%*",
								"%#BufferLineDuplicate#" .. filename .. "%*"
							)
						end
						return filename
					end,
					show_buffer_paths = function(opts)
						local duplicates = require("bufferline.utils").get_duplicates(opts)
						return next(duplicates) ~= nil
					end,
					custom_filter = function(buf_number)
						if vim.bo[buf_number].filetype ~= "qf" then
							return true
						end
					end,
				},
				highlights = theme.current_theme.bufferline,
			})
		end,
	},

	-- Dashboard (alpha-nvim)
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			local theme = require("config.theme")
			local heading = theme.current_theme.alpha.heading
			local button = theme.current_theme.alpha.button
			local shortcut = theme.current_theme.alpha.shortcut

			-- Header (ASCII art or text)
			dashboard.section.header.val = {
				[[           ████████]],
				[[       ████████████████]],
				[[     ████████████████████]],
				[[   ██████    ████████    ██]],
				[[   ████        ████        ]],
				[[   ████    ▒▒▒▒████    ▒▒▒▒]],
				[[ ██████    ▒▒▒▒████    ▒▒▒▒██]],
				[[ ████████    ████████    ████]],
				[[ ████████████████████████████]],
				[[ ████████████████████████████]],
				[[ ████████████████████████████]],
				[[ ████  ██████    ██████  ████]],
				[[ ██      ████    ████      ██]],
			}

			dashboard.section.buttons.val = {
				dashboard.button("e", "❐  New File", "<cmd>ene <CR>"),
				dashboard.button("SPC f f", "🔍 Explore"),
				dashboard.button("SPC f r", "󰑓  Recents"),
				dashboard.button("SPC f s", "󰑑  Grep Files"),
				dashboard.button("SPC f g", "  Git Files"),
				dashboard.button("p", "  Plugins", "<cmd>Lazy<CR>"),
			}

			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButton"
			dashboard.section.footer.opts.hl = "AlphaFooter"

			vim.api.nvim_set_hl(0, "AlphaHeader", { fg = heading })
			vim.api.nvim_set_hl(0, "AlphaButton", { fg = button })
			vim.api.nvim_set_hl(0, "AlphaFooter", { fg = shortcut })

			dashboard.opts.opts.noautocmd = true
			dashboard.section.footer.val = "-NvLeet-"
			alpha.setup(dashboard.opts)
			vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
		end,
	},

	-- Icons: mini.icons + nvim-web-devicons
	{
		"echasnovski/mini.icons",
		version = "*",
		config = function()
			require("mini.icons").setup()
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				color_icons = true,
				default = false,
				variant = "dark",
				strict = false,
				override = {
					zsh = {
						icon = "",
						color = "#428850",
						cterm_color = "65",
						name = "Zsh",
					},
					["build"] = {
						icon = "󱧼",
						color = "#FFC300",
						name = "BuildDir",
					},
					src = {
						icon = "󰴉", -- Choose an icon from your font
						color = "#A9A9A9", -- Example color
						name = "Source", -- Optional name for the icon
					},
				},
				override_by_filename = {
					[".gitignore"] = {
						icon = "",
						color = "#f1502f",
						name = "Gitignore",
					},
					[".env"] = {
						icon = "",
						color = "#FFC300",
						name = "EnvFile",
					},
					["build"] = {
						icon = "󱧼",
						color = "#FFC300",
						name = "BuildDir",
					},
				},
				override_by_extension = {
					["build"] = {
						icon = "󱧼",
						color = "#FFC300",
						name = "BuildDir",
					},

					["log"] = {
						icon = "",
						color = "#81e043",
						name = "Log",
					},

					["js"] = {
						icon = " ",
						color = "#f59e0b",
						name = "jsfile",
					},
				},
				override_by_operating_system = {
					["apple"] = {
						icon = "",
						color = "#A2AAAD",
						cterm_color = "248",
						name = "Apple",
					},
				},
			})
			require("nvim-web-devicons").set_default_icon("*", "#5e5c5c", 65)
		end,
	},

	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		config = function()
			require("tiny-devicons-auto-colors").setup()
		end,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},

	-- Incline (floating filename labels)
	--
	-- A rounded pill in each window's top-right corner: filetype icon, filename,
	-- file size, git churn, diagnostics and a modified dot. Colors come from the
	-- active palette (lua/config/theme.lua, `incline` key) and the live
	-- Diagnostic*/GitSigns* groups, and the whole config is rebuilt on
	-- :colorscheme so the labels follow a theme switch.
	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>ui",
				function()
					require("incline").toggle()
				end,
				desc = "Toggle incline labels",
			},
		},
		config = function()
			local incline = require("incline")
			local devicons = require("nvim-web-devicons")

			-- Read a group's foreground as "#rrggbb" so it can be paired with the
			-- pill background; chunks that use `group =` would drag along that
			-- group's background and punch a hole in the pill.
			local function hl_fg(group, fallback)
				local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
				if ok and hl and hl.fg then
					return string.format("#%06x", hl.fg)
				end
				return fallback
			end

			-- Human-readable size of the file backing `bufnr`; "" when the buffer
			-- has no file on disk yet.
			local function file_size(bufnr)
				local name = vim.api.nvim_buf_get_name(bufnr)
				if name == "" then
					return ""
				end

				local stat = vim.uv.fs_stat(name)
				local size = stat and stat.size
				if type(size) ~= "number" or size <= 0 then
					return ""
				end

				local units = { "B", "KB", "MB", "GB" }
				local i = 1
				while size > 1024 and i < #units do
					size = size / 1024
					i = i + 1
				end

				return string.format(i == 1 and "[%d %s]" or "[%.1f %s]", size, units[i])
			end

			-- Built as a function so the ColorScheme handler below can re-run setup
			-- against the new palette.
			local function build_opts()
				local theme = require("config.theme").current_theme
				local t = theme.incline

				-- The float itself stays out of the way — the editor background, or
				-- nothing at all under a transparent colorscheme. The pill is painted
				-- entirely by the render chunks, which is what gives the  ends
				-- their rounded silhouette instead of a hard rectangle.
				local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
				local base_bg = normal.bg and string.format("#%06x", normal.bg) or "NONE"

				local c = {
					error = hl_fg("DiagnosticError", "#ff7676"),
					warn = hl_fg("DiagnosticWarn", "#d9ba73"),
					info = hl_fg("DiagnosticInfo", "#8ebeec"),
					hint = hl_fg("DiagnosticHint", "#5abfb5"),
					git_add = hl_fg("GitSignsAdd", "#86cd82"),
					git_change = hl_fg("GitSignsChange", "#d9ba73"),
					git_delete = hl_fg("GitSignsDelete", "#ff7676"),
				}

				return {
					-- Rising/falling debounce around window events; the defaults are
					-- responsive without redrawing on every keystroke.
					debounce_threshold = { rising = 10, falling = 50 },

					window = {
						width = "fit",
						padding = 0, -- the pill's own  ends are the padding
						margin = { horizontal = 0, vertical = 1 },
						placement = { vertical = "top", horizontal = "right" },
						overlap = {
							winbar = false,
							tabline = false,
							borders = true,
							statusline = false,
						},
						zindex = 50,
						-- Must be split active/inactive: a flat table is applied to
						-- BOTH states, which leaves InclineNormalNC unused.
						winhighlight = {
							active = { Normal = "InclineNormal" },
							inactive = { Normal = "InclineNormalNC" },
						},
					},

					-- Declaring the groups here rather than calling nvim_set_hl once:
					-- incline re-registers them on every ColorScheme, so they survive
					-- a scheme reload that would otherwise wipe them.
					highlight = {
						groups = {
							InclineNormal = { guifg = t.normal.fg, guibg = base_bg },
							InclineNormalNC = { guifg = t.normal_nc.fg, guibg = base_bg },
						},
					},

					hide = {
						cursorline = "smart", -- step aside when the cursor lands under it
						focused_win = false,
						only_win = false,
					},

					ignore = {
						unlisted_buffers = true,
						floating_wins = true,
						buftypes = "special",
						wintypes = "special",
						filetypes = {
							"alpha",
							"NvimTree",
							"fzf",
							"grug-far",
							"help",
							"lazy",
							"mason",
							"dap-repl",
							"dapui_scopes",
							"dapui_breakpoints",
							"dapui_stacks",
							"dapui_watches",
							"dapui_console",
						},
					},

					render = function(props)
						local bufname = vim.api.nvim_buf_get_name(props.buf)
						local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
						local icon, icon_color = devicons.get_icon_color(filename)
						local bg = props.focused and t.normal.bg or t.normal_nc.bg
						local fg = props.focused and t.file_name.guifg or t.normal_nc.fg

						local label = {
							{ " ", guibg = bg },
							icon and { icon .. " ", guifg = icon_color, guibg = bg, gui = "bold" } or "",
							{
								filename .. " ",
								guifg = fg,
								guibg = bg,
								gui = props.focused and "bold" or "none",
							},
						}

						local size = file_size(props.buf)
						if size ~= "" then
							table.insert(label, { size .. " ", guifg = t.normal_nc.fg, guibg = bg })
						end

						if vim.bo[props.buf].modified then
							table.insert(label, { "● ", guifg = t.modified.guifg, guibg = bg })
						end

						-- Rounded ends: drawn in the pill color against the float's
						-- background, so they read as the pill's edges.
						return {
							{ "", guifg = bg, guibg = base_bg },
							label,
							{ "", guifg = bg, guibg = base_bg },
						}
					end,
				}
			end

			incline.setup(build_opts())

			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("InclineThemeIntegration", { clear = true }),
				callback = function()
					incline.setup(build_opts())
				end,
			})
		end,
	},
}
