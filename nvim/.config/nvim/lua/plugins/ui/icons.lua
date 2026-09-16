-- Icon providers. nvim-web-devicons is the one actually used (nvim-tree,
-- fzf-lua, heirline, incline); mini.icons is only declared so grug-far's
-- fileIconsProvider = "first_available" has a fallback.
return {
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
}
