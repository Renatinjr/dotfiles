return {
	"3rd/image.nvim",
	dependencies = { "luarocks.nvim" },
	event = "BufRead",
	config = function()
		require("image").setup({
			backend = "kitty",

			-- sizing
			max_width = nil,
			max_height = nil,
			max_width_window_percentage = 80,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

			-- processing
			editor_only_render_when_focused = true,
			tmux_show_only_in_active_window = true,

			-- integrations
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki" },
				},
				neorg = {
					enabled = true,
					clear_in_insert_mode = true,
					only_render_image_at_cursor = false,
					filetypes = { "norg" },
				},
			},

			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg", "*.avif" },
		})
	end,
}
