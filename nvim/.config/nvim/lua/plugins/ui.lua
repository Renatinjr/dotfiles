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

			vim.api.nvim_set_hl(0, "AlphaHeader", { fg = heading, bg = bg })
			vim.api.nvim_set_hl(0, "AlphaButton", { fg = button, bg = bg })
			vim.api.nvim_set_hl(0, "AlphaFooter", { fg = shortcut, bg = bg })

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
				default = true,
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
	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"linrongbin16/commons.nvim",
		},
		config = function()
			local incline = require("incline")
			local theme = require("config.theme")
			local edge_bg = theme.current_theme.bg

			local function returnSize(bufnr)
				local uv = vim.uv
				local filename = vim.api.nvim_buf_get_name(bufnr)

				if not filename or filename == "" then
					return ""
				end

				local fstat = uv.fs_stat(filename)

				if not fstat or not fstat.size then
					return ""
				end

				local fsize_value = fstat.size

				if type(fsize_value) ~= "number" or fsize_value <= 0 then
					return ""
				end

				local suffixes = { "B", "KB", "MB", "GB" }
				local i = 1
				while fsize_value > 1024 and i < #suffixes do
					fsize_value = fsize_value / 1024
					i = i + 1
				end

				local fsize_format = i == 1 and "[%d %s] " or "[%.1f %s] "
				local sizeForm = string.format(fsize_format, fsize_value, suffixes[i])
				return sizeForm
			end

			incline.setup({
				window = {
					padding = 0,
					margin = { horizontal = 0, vertical = 1 },
					zindex = 50,
					winhighlight = {
						Normal = "InclineNormal",
						FloatBorder = "InclineBorder",
					},
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "●" or ""
					local filetype_icon, filetype_color = require("nvim-web-devicons").get_icon_color(filename)

					local sizeForm = returnSize(props.buf)
					local bg_color = props.focused and theme.current_theme.incline.focused.one
						or theme.current_theme.incline.focused.two

					local buffer = {
						{ filetype_icon, guifg = filetype_color, guibg = bg_color, gui = "bold" },
						{ " ", guibg = bg_color },
						{
							filename .. " " .. sizeForm,
							gui = props.focused and "bold" or "none",
							guifg = theme.current_theme.incline.file_name.guifg,
							guibg = bg_color,
						},
						{ modified, guifg = theme.current_theme.incline.modified.guifg, guibg = bg_color },
					}

					return {
						{ "", guifg = edge_bg, guibg = bg_color },
						buffer,
						{ "", guifg = edge_bg, guibg = bg_color },
					}
				end,
			})

			vim.api.nvim_set_hl(
				0,
				"InclineNormal",
				{ fg = theme.current_theme.incline.normal.fg, bg = theme.current_theme.incline.normal.bg }
			)
			vim.api.nvim_set_hl(0, "InclineBorder", { fg = edge_bg, bg = edge_bg })
			vim.api.nvim_set_hl(
				0,
				"InclineNormalNC",
				{ fg = theme.current_theme.incline.normal_nc.fg, bg = theme.current_theme.incline.normal_nc.bg }
			)
		end,
	},
}
