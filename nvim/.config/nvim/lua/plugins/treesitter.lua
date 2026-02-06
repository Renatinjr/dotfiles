return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSUpdate", "TSUpdateSync" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				lazy = true,
          branch = "main"
			},
		},
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"css",
				"dockerfile",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"rust",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = { query = "@function.outer", desc = "Select outer function" },
						["if"] = { query = "@function.inner", desc = "Select inner function" },
						["ac"] = { query = "@class.outer", desc = "Select outer class" },
						["ic"] = { query = "@class.inner", desc = "Select inner class" },
						["aa"] = { query = "@parameter.outer", desc = "Select outer argument" },
						["ia"] = { query = "@parameter.inner", desc = "Select inner argument" },
						["ai"] = { query = "@conditional.outer", desc = "Select outer conditional" },
						["ii"] = { query = "@conditional.inner", desc = "Select inner conditional" },
						["al"] = { query = "@loop.outer", desc = "Select outer loop" },
						["il"] = { query = "@loop.inner", desc = "Select inner loop" },
						["ab"] = { query = "@block.outer", desc = "Select outer block" },
						["ib"] = { query = "@block.inner", desc = "Select inner block" },
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = { query = "@function.outer", desc = "Next function start" },
						["]c"] = { query = "@class.outer", desc = "Next class start" },
						["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
					},
					goto_next_end = {
						["]F"] = { query = "@function.outer", desc = "Next function end" },
						["]C"] = { query = "@class.outer", desc = "Next class end" },
						["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
					},
					goto_previous_start = {
						["[f"] = { query = "@function.outer", desc = "Previous function start" },
						["[c"] = { query = "@class.outer", desc = "Previous class start" },
						["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
					},
					goto_previous_end = {
						["[F"] = { query = "@function.outer", desc = "Previous function end" },
						["[C"] = { query = "@class.outer", desc = "Previous class end" },
						["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>sa"] = { query = "@parameter.inner", desc = "Swap with next argument" },
						["<leader>sf"] = { query = "@function.outer", desc = "Swap with next function" },
					},
					swap_previous = {
						["<leader>sA"] = { query = "@parameter.inner", desc = "Swap with previous argument" },
						["<leader>sF"] = { query = "@function.outer", desc = "Swap with previous function" },
					},
				},
			},
		},
		config = function(_, opts)
			require('nvim-treesitter-textobjects').setup(opts)

			-- Folding with treesitter
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = false -- Start with folds open
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
		},
		keys = {
			{
				"[x",
				function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end,
				desc = "Go to context",
				silent = true,
			},
		},
	},
}
