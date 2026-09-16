-- indent-blankline: indent guides. Colors come from config.theme (indent key).
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		-- Kanso zen palette — quiet, monochromatic indent guides
		local zen = { line = "#22262D", scope = "#393B44" }

		-- The active theme (config.theme.current_theme) supplies the two greys when
		-- it defines an `indent` table; otherwise the kanso zen values stand in.
		local function indent_colors()
			local ok, theme = pcall(require, "config.theme")
			if ok and type(theme.current_theme) == "table" and type(theme.current_theme.indent) == "table" then
				return theme.current_theme.indent
			end
			return zen
		end

		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			local c = indent_colors()
			-- Indent line — barely visible, just enough structure
			vim.api.nvim_set_hl(0, "IblIndent", {
				fg = c.line,
				nocombine = true,
			})
			-- Active scope — softly highlighted
			vim.api.nvim_set_hl(0, "IblScope", {
				fg = c.scope,
				nocombine = true,
			})
		end)

		require("ibl").setup({
			indent = {
				highlight = { "IblIndent" },
				char = "▏",
				tab_char = "▏",
				smart_indent_cap = true,
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
				show_exact_scope = false,
				highlight = { "IblScope" },
				char = "▏",
			},
			exclude = {
				filetypes = {
					"bigfile",
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
	end,
}
