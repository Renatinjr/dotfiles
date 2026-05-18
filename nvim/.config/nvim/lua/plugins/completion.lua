return {
	"saghen/blink.cmp",
	-- Loads on first insert or cmdline use; both popups need it warm.
	event = { "InsertEnter", "CmdlineEnter" },
	-- Pull pre-built fuzzy-matcher binary from the release tag.
	version = "*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
	},

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- ───────────────────────────────────────────────────────────────
		-- APPEARANCE — icons + nerd-font glyph variant
		-- ───────────────────────────────────────────────────────────────
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		-- ───────────────────────────────────────────────────────────────
		-- COMPLETION — menu / docs / ghost text / list behavior
		-- ───────────────────────────────────────────────────────────────
		completion = {
			-- Auto-insert `()` after function names, `<>` for JSX tags, etc.
			accept = {
				auto_brackets = { enabled = true },
			},

			-- The side documentation panel (shows when an item is selected).
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
				treesitter_highlighting = true,
				window = {
					border = "rounded",
					winblend = 0,
					max_width = 80,
					max_height = 20,
				},
			},

			-- The main popup menu.
			menu = {
				border = "rounded",
				winblend = 0,
				-- Keep it compact so it doesn't swallow lines under the cursor.
				max_height = 10,

				-- Re-anchor the cmdline popup so it sits flush with the prompt.
				cmdline_position = function()
					if vim.g.ui_cmdline_pos ~= nil then
						local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
						return { pos[1] - 1, pos[2] }
					end
					local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
					return { vim.o.lines - height, 0 }
				end,

				draw = {
					-- Two columns: [icon  label] [kind].
					columns = {
						{ "kind_icon", "label", gap = 1 },
						{ "kind" },
					},

					components = {
						kind_icon = {
							-- Tailwind color preview lands as a block char in the
							-- icon slot when blink detects a color item.
							text = function(ctx)
								if ctx.item and ctx.item.kind_hl then
									local hl = vim.api.nvim_get_hl(0, { name = ctx.item.kind_hl })
									if hl and hl.fg then
										return "██ "
									end
								end
								local kind = require("lspkind").symbol_map[ctx.kind] or ""
								return kind .. " "
							end,
							highlight = function(ctx)
								if ctx.item and ctx.item.kind_hl then
									local hl = vim.api.nvim_get_hl(0, { name = ctx.item.kind_hl })
									if hl and hl.fg then
										return ctx.item.kind_hl
									end
								end
								return "BlinkCmpKind" .. ctx.kind
							end,
						},
						label = {
							text = function(item)
								return item.label
							end,
							highlight = "BlinkCmpLabel",
						},
						kind = {
							text = function(item)
								return item.kind
							end,
							highlight = function(ctx)
								return "BlinkCmpKind" .. ctx.kind
							end,
						},
					},
				},
			},

			-- Inline next-suggestion preview (subtle, theme-aware).
			ghost_text = {
				enabled = true,
			},

			-- Result list limits and selection behavior.
			list = {
				max_items = 50,
				selection = {
					-- Preselect the top item but don't auto-insert until <CR>/<Tab>.
					preselect = true,
					auto_insert = false,
				},
			},

			-- Don't auto-trigger the menu until at least one keystroke; per-source
			-- min_keyword_length further tunes when each source contributes.
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_insert_on_trigger_character = true,
			},
		},

		-- ───────────────────────────────────────────────────────────────
		-- KEYMAP — explicit super-TAB layout (preset = "none")
		-- ───────────────────────────────────────────────────────────────
		keymap = {
			preset = "none",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<Tab>"] = {
				function(cmp)
					return cmp.select_next()
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = {
				function(cmp)
					return cmp.select_prev()
				end,
				"snippet_backward",
				"fallback",
			},

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-up>"] = { "scroll_documentation_up", "fallback" },
			["<C-down>"] = { "scroll_documentation_down", "fallback" },
		},

		-- ───────────────────────────────────────────────────────────────
		-- SIGNATURE HELP — floating arg hints
		-- ───────────────────────────────────────────────────────────────
		signature = {
			enabled = true,
			window = {
				border = "rounded",
				winblend = 0,
				max_width = 80,
				max_height = 20,
			},
		},

		-- ───────────────────────────────────────────────────────────────
		-- SNIPPETS — uses friendly-snippets via blink's default preset
		-- ───────────────────────────────────────────────────────────────
		snippets = {
			preset = "default",
		},

		-- ───────────────────────────────────────────────────────────────
		-- FUZZY MATCHER — Rust binary; falls back to lua with a warning
		-- ───────────────────────────────────────────────────────────────
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			-- Result sort order: best match first, then alphabetical.
			sorts = { "score", "sort_text" },
		},

		-- ───────────────────────────────────────────────────────────────
		-- SOURCES — LSP, path, snippets, buffer
		-- ───────────────────────────────────────────────────────────────
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },

			providers = {
				lsp = {
					-- LSP suggestions show from the first keystroke (most relevant).
					min_keyword_length = 0,
					score_offset = 1,
					opts = { tailwind_color_icon = "██" },
				},
				path = {
					-- Paths are useful immediately (e.g. typing `./` or `/`).
					min_keyword_length = 0,
				},
				snippets = {
					-- Wait until 2 chars so snippet prefixes don't crowd the menu.
					min_keyword_length = 2,
					score_offset = -1,
				},
				buffer = {
					-- Buffer-word matches are noisy — hold them back until 5 chars
					-- and cap to 5 items so they never dominate the popup.
					min_keyword_length = 5,
					max_items = 5,
					score_offset = -3,
				},
			},
		},

		-- ───────────────────────────────────────────────────────────────
		-- CMDLINE — completion in :command and / search prompts
		-- ───────────────────────────────────────────────────────────────
		cmdline = {
			enabled = true,
			keymap = {
				preset = "cmdline",
			},
			completion = {
				menu = { auto_show = true },
			},
		},
	},

	-- Allow other plugins / lazy specs to extend sources.default rather
	-- than overwrite it (lazy merges arrays specifically named in this list).
	opts_extend = { "sources.default" },
}
