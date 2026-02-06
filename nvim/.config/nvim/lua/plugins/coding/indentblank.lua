return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {},
	config = function()
		-- Kanagawa color palette (official)
		local kanagawa = {
			sumiInk0 = "#16161D",
			sumiInk1 = "#181820",
			sumiInk2 = "#1a1a22",
			sumiInk3 = "#1F1F28",
			sumiInk4 = "#2A2A37",
			sumiInk5 = "#363646",

			waveBlue1 = "#223249",
			waveBlue2 = "#2D4F67",

			winterGreen = "#2B3328",
			winterYellow = "#49443C",
			winterRed = "#43242B",
			winterBlue = "#252535",

			autumnGreen = "#76946A",
			autumnRed = "#C34043",
			autumnYellow = "#DCA561",

			samuraiRed = "#E82424",
			roninYellow = "#FF9E3B",
			waveAqua1 = "#6A9589",
			dragonBlue = "#658594",

			fujiWhite = "#DCD7BA",
			fujiGray = "#727169",
			springViolet1 = "#938AA9",
			oniViolet = "#957FB8",
			crystalBlue = "#7E9CD8",
			springViolet2 = "#9CABCA",
			springBlue = "#7FB4CA",
			lightBlue = "#A3D4D5",
			waveAqua2 = "#7AA89F",
			springGreen = "#98BB6C",
			boatYellow1 = "#938056",
			boatYellow2 = "#C0A36E",
			carpYellow = "#E6C384",
			sakuraPink = "#D27E99",
			waveRed = "#E46876",
			peachRed = "#FF5D62",
			surimiOrange = "#FFA066",
			katanaGray = "#717C7C",
		}

		-- Indent colors using Kanagawa's subtle colors
		-- These progress from subtle to more visible
		local indent_colors = {
			kanagawa.sumiInk4, -- Very subtle
			kanagawa.katanaGray, -- Gray
			kanagawa.springViolet1, -- Subtle violet
			kanagawa.crystalBlue, -- Blue
			kanagawa.springBlue, -- Light blue
			kanagawa.springGreen, -- Green
			kanagawa.carpYellow, -- Yellow
			kanagawa.surimiOrange, -- Orange
			kanagawa.waveRed, -- Red
			kanagawa.oniViolet, -- Violet
			kanagawa.autumnGreen, -- Green
		}

		-- Generate highlight groups dynamically
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			-- Create indent highlight groups
			for i, color in ipairs(indent_colors) do
				vim.api.nvim_set_hl(0, "IndentKanagawa" .. i, {
					fg = color,
					bg = "NONE",
					blend = 0,
					nocombine = true,
				})
			end

			-- Scope highlighting
			vim.api.nvim_set_hl(0, "IblScope", {
				fg = kanagawa.springBlue,
				bg = "NONE",
				blend = 0,
				nocombine = true,
			})

			-- Current scope (more prominent)
			vim.api.nvim_set_hl(0, "IblCurrentScope", {
				fg = kanagawa.springGreen,
				bg = "NONE",
				bold = true,
				blend = 0,
				nocombine = true,
			})

			-- Whitespace
			vim.api.nvim_set_hl(0, "IblWhitespace", {
				fg = kanagawa.sumiInk4,
				bg = "NONE",
				blend = 30,
			})
		end)

		-- Create highlight table for indent-blankline
		local highlight = {}
		for i = 1, #indent_colors do
			table.insert(highlight, "IndentKanagawa" .. i)
		end

		require("ibl").setup({
			indent = {
				highlight = highlight,
				char = "▏", -- Thin vertical bar that fits Kanagawa aesthetic
				tab_char = "▏",
				smart_indent_cap = true,
				priority = 1,
			},
			scope = {
				show_start = true,
				show_end = false, -- Kanagawa style usually shows only start
				highlight = { "IblScope" },
				show_exact_scope = false,
				injected_languages = true,
				char = "▏",
				priority = 2,
			},
			whitespace = {
				highlight = { "IblWhitespace" },
				remove_blankline_trail = true,
			},
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"markdown",
					"text",
					"NvimTree",
					"Outline",
					"qf",
				},
				buftypes = {
					"terminal",
					"nofile",
					"quickfix",
					"prompt",
				},
			},
		})

		-- Optional: Override for specific filetypes
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown", "txt", "text", "gitcommit" },
			callback = function()
				vim.api.nvim_set_hl(0, "IblScope", {
					fg = kanagawa.fujiGray,
					bg = "NONE",
					blend = 0,
					nocombine = true,
				})
			end,
		})
	end,
}
