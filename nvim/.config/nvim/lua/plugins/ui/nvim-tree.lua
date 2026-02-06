return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- for file icons
	},
	config = function()
		local HEIGHT_RATIO = 0.8
		local WIDTH_RATIO = 0.5
		local map = vim.keymap.set

		map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
		map("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>", { desc = "Find current file in NvimTree" })
		map("n", "<leader>nr", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh NvimTree" })

		require("nvim-tree").setup({
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = true,
			},
			sort = {
				sorter = "case_sensitive",
				folders_first = true,
			},
			view = {
				centralize_selection = true,
				cursorline = true,
				side = "left",
				width = 30,
				float = {
					enable = true,
					open_win_config = function()
						local screen_w = vim.opt.columns:get()
						local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
						local window_w = screen_w * WIDTH_RATIO
						local window_h = screen_h * HEIGHT_RATIO
						local window_w_int = math.floor(window_w)
						local window_h_int = math.floor(window_h)
						local center_x = (screen_w - window_w) / 2
						local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
						return {
							border = "rounded",
							relative = "editor",
							row = center_y,
							col = center_x,
							width = window_w_int,
							height = window_h_int,
						}
					end,
				},
			},
			renderer = {
				add_trailing = true,
				group_empty = true,
				highlight_git = "name",
				highlight_opened_files = "icon",
				highlight_modified = "all",
				special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },
				indent_markers = {
					enable = true,
					icons = {
						corner = "└ ",
						edge = "│ ",
						item = "│ ",
						none = "  ",
					},
				},
				icons = {
					web_devicons = {
						file = {
							enable = true,
							color = true,
						},
						folder = {
							enable = false,
							color = true,
						},
					},
					git_placement = "before",
					modified_placement = "after",
					padding = " ",
					symlink_arrow = " ➛ ",
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
						modified = true,
						diagnostics = true,
					},
					glyphs = {
						default = "󰈮",
						symlink = "",
						folder = {
							arrow_closed = "ᐅ",
							arrow_open = "▼",
							default = "",
							open = "",
							empty = "",
							empty_open = "",
							symlink = "",
							symlink_open = "",
						},
						git = {
							unstaged = "M",
							staged = "S",
							unmerged = "U",
							renamed = "R",
							untracked = "?",
							deleted = "D",
							ignored = "",
						},
					},
				},
			},
			filters = {
				dotfiles = false, -- Show dotfiles by default
				git_ignored = false,
				custom = { "^.git$", "^node_modules$", "^.cache$", "^dist$" }, -- Common dirs to hide
				exclude = { ".gitignore", ".env.example" }, -- Files to never hide
			},
			git = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = false,
				timeout = 300,
			},
			diagnostics = {
				enable = true,
				show_on_dirs = false,
				debounce_delay = 50,
				icons = {
					hint = "💡",
					info = " ",
					warning = " ",
					error = "󰅙 ",
				},
			},
			modified = {
				enable = true,
				show_on_dirs = true,
			},
			actions = {
				use_system_clipboard = true,
				change_dir = {
					enable = true,
					global = false,
				},
				open_file = {
					quit_on_open = false, -- Don't close NvimTree when opening a file
					resize_window = true,
					window_picker = {
						enable = true,
						chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
						exclude = {
							filetype = {
								"notify",
								"packer",
								"qf",
								"diff",
								"fugitive",
								"fugitiveblame",
								"TelescopePrompt",
								"NvimTree",
							},
							buftype = { "nofile", "terminal", "help" },
						},
					},
				},
				remove_file = {
					close_window = true,
				},
			},
			live_filter = {
				prefix = "🔍 ",
				always_show_folders = true,
			},
			ui = {
				confirm = {
					remove = true,
					trash = true,
				},
			},
			filesystem_watchers = {
				enable = true,
				debounce_delay = 50,
			},
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				api.config.mappings.default_on_attach(bufnr)

				map("n", "?", api.tree.toggle_help, opts("Help"))
				map("n", "l", api.node.open.edit, opts("Open"))
				map("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
				map("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
				map("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
				map("n", "C", api.tree.change_root_to_node, opts("CD"))
				map("n", "u", api.tree.change_root_to_parent, opts("Up"))
			end,
		})
	end,
}
