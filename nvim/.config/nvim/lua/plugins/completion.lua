-- ============================================================================
-- blink.cmp — performance-first completion engine (replaces coq_nvim)
-- Repo: https://github.com/saghen/blink.cmp
--
-- WHY blink.cmp
--   * The fuzzy matcher is a native Rust/SIMD library, so ranking/filtering of
--     thousands of candidates happens in well under a frame. We pin a tagged
--     release (`version = "1.*"`) so lazy.nvim downloads the PREBUILT binary —
--     no Rust toolchain required. If you ever want to build from source instead,
--     drop `version` and add `build = "cargo build --release"`.
--   * It debounces/pre-fetches LSP requests and renders the native-feeling
--     menu asynchronously, so typing never blocks on a slow server.
--
-- LSP capabilities
--   blink advertises richer completion capabilities (snippet support, resolve,
--   additionalTextEdits, etc.). They are injected centrally in
--   lua/plugins/lsp/init.lua via:
--       require("blink.cmp").get_lsp_capabilities({ ...overrides })
--   so every server enabled there inherits them. We deliberately do NOT run an
--   lspconfig setup loop here (that file uses the Neovim 0.11+ vim.lsp.config /
--   vim.lsp.enable API).
--
-- Keymaps (preset "enter" + Tab navigation):
--   <CR>            accept the selected item — else fall through to nvim-autopairs'
--                   own <CR> (newline-between-brackets) because we list "fallback"
--   <Tab>/<S-Tab>  select next/prev row, then jump snippet placeholders
--   <C-y>          accept (always)            <C-e>  dismiss the menu
--   <C-space>      open menu / toggle docs    <C-k>  toggle signature window
--   <C-u>/<C-d>    scroll the documentation window
-- ============================================================================

-- Show completions only once the keyword under the cursor reaches this length.
-- Trigger characters (".", "::", "/", …) bypass this, so member access still
-- pops instantly — this only gates the "type a word, get suggestions" path,
-- matching the 2-char gate the old coq config emulated with a CompleteChanged
-- hack. Applied per source below.
local MIN_KEYWORD = 2

-- ---------------------------------------------------------------------------
-- Theme integration — derive the menu palette from the ACTIVE colorscheme.
-- koda is the live theme (lua/config/theme.lua); we read its palette directly
-- (with a hardcoded fallback, mirroring theme.lua) and re-apply on every
-- :colorscheme change so the menu always tracks the editor. blink, unlike coq,
-- emits a real per-item highlight group (BlinkCmpKind<Kind>), so icons CAN be
-- colored per kind — that's what the kind map below is for.
-- ---------------------------------------------------------------------------
local function blink_highlights()
	local ok, p = pcall(require, "koda.palette.dark")
	if not ok or type(p) ~= "table" then
		p = {
			bg = "#101010",
			fg = "#b0b0b0",
			dim = "#474747",
			line = "#272727",
			comment = "#50585d",
			const = "#d9ba73",
			highlight = "#458ee6",
			info = "#8ebeec",
			success = "#86cd82",
			danger = "#ff7676",
			orange = "#ff5733",
			pink = "#f2a4db",
			cyan = "#5abfb5",
		}
	end

	-- Semantic shorthands. `func`/`string` use the values colorscheme.lua
	-- overrides koda with (gold functions, pale-yellow strings) so the menu
	-- matches the actual buffer syntax rather than koda's muted defaults.
	local c = {
		fg = p.fg,
		blue = p.highlight,
		info = p.info,
		gold = p.const,
		green = p.success,
		red = p.danger,
		cyan = p.cyan,
		pink = p.pink,
		orange = p.orange or "#ff5733",
		comment = p.comment,
		dim = p.dim,
		line = p.line,
		func = "#E6C384",
		string = "#ffffb8",
	}

	-- LSP CompletionItemKind -> accent color.
	local kinds = {
		Text = c.comment,
		Method = c.func,
		Function = c.func,
		Constructor = c.func,
		Field = c.gold,
		Variable = c.info,
		Class = c.cyan,
		Interface = c.cyan,
		Module = c.blue,
		Property = c.gold,
		Unit = c.gold,
		Value = c.gold,
		Enum = c.cyan,
		Keyword = c.pink,
		Snippet = c.green,
		Color = c.pink,
		File = c.info,
		Reference = c.fg,
		Folder = c.info,
		EnumMember = c.gold,
		Constant = c.gold,
		Struct = c.cyan,
		Event = c.orange,
		Operator = c.pink,
		TypeParameter = c.cyan,
	}

	local hl = vim.api.nvim_set_hl
	-- Menu chrome (links so a theme that ships its own floats still wins shape).
	hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
	hl(0, "BlinkCmpMenuBorder", { fg = c.dim, bg = "NONE" })
	hl(0, "BlinkCmpMenuSelection", { bg = c.line, bold = true })
	hl(0, "BlinkCmpScrollBarThumb", { bg = c.dim })
	hl(0, "BlinkCmpScrollBarGutter", { bg = c.line })

	-- Labels.
	hl(0, "BlinkCmpLabel", { fg = c.fg })
	hl(0, "BlinkCmpLabelMatch", { fg = c.blue, bold = true }) -- fuzzy-matched chars
	hl(0, "BlinkCmpLabelDeprecated", { fg = c.comment, strikethrough = true })
	hl(0, "BlinkCmpLabelDetail", { fg = c.comment })
	hl(0, "BlinkCmpLabelDescription", { fg = c.comment })

	-- Kind column + source + ghost text.
	hl(0, "BlinkCmpKind", { fg = c.fg })
	hl(0, "BlinkCmpSource", { fg = c.comment, italic = true })
	hl(0, "BlinkCmpGhostText", { fg = c.dim, italic = true })

	-- Documentation / signature floats.
	hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
	hl(0, "BlinkCmpDocBorder", { fg = c.dim, bg = "NONE" })
	hl(0, "BlinkCmpDocSeparator", { fg = c.dim })
	hl(0, "BlinkCmpDocCursorLine", { bg = c.line })
	hl(0, "BlinkCmpSignatureHelp", { link = "NormalFloat" })
	hl(0, "BlinkCmpSignatureHelpBorder", { fg = c.dim, bg = "NONE" })
	hl(0, "BlinkCmpSignatureHelpActiveParameter", { fg = c.orange, bold = true })

	-- Per-kind icon colors.
	for kind, color in pairs(kinds) do
		hl(0, "BlinkCmpKind" .. kind, { fg = color })
	end
end

-- ---------------------------------------------------------------------------
-- Plugin spec (lazy.nvim)
-- ---------------------------------------------------------------------------
return {
	{
		"saghen/blink.cmp",
		-- Pinned tag => lazy fetches the prebuilt fuzzy binary (no cargo needed).
		version = "1.*",
		-- Load before we type and before the cmdline opens; the LSP layer also
		-- require()s blink at BufReadPre for capabilities, so lazy will usually
		-- bring it up a touch earlier — that's fine, opts apply on first load.
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			-- VSCode-format snippet collection consumed by the snippets source.
			"rafamadriz/friendly-snippets",
		},

		-- `opts_extend` lets other specs append sources without clobbering ours.
		opts_extend = { "sources.default" },

		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			-- ---- Keymaps --------------------------------------------------------
			keymap = {
				preset = "enter", -- <CR> accepts / falls back to autopairs' <CR>
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-y>"] = { "select_and_accept" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			},

			-- ---- Appearance -----------------------------------------------------
			appearance = {
				-- "mono" = the Nerd Font Mono glyph variant (correct single-cell
				-- width in the menu). Use "normal" if your font isn't the Mono build.
				nerd_font_variant = "mono",
				-- Nerd Font v3 glyphs per CompletionItemKind (carried over from the
				-- previous coq config so the icon set stays familiar).
				kind_icons = {
					Text = "󰉿",
					Method = "󰆧",
					Function = "󰊕",
					Constructor = "",
					Field = "󰜢",
					Variable = "󰀫",
					Class = "󰠱",
					Interface = "",
					Module = "",
					Property = "󰜢",
					Unit = "󰑭",
					Value = "󰎠",
					Enum = "",
					Keyword = "󰌋",
					Snippet = "",
					Color = "󰏘",
					File = "󰈙",
					Reference = "󰈇",
					Folder = "󰉋",
					EnumMember = "",
					Constant = "󰏿",
					Struct = "󰙅",
					Event = "",
					Operator = "󰆕",
					TypeParameter = "",
				},
			},

			-- ---- Completion behaviour / UI -------------------------------------
			completion = {
				keyword = { range = "prefix" },

				trigger = {
					-- Prefetch on insert so the first menu render is instant — the
					-- single biggest perceived-latency win.
					prefetch_on_insert = true,
					show_on_keyword = true,
					show_on_trigger_character = true, -- ".", "::" etc. always fire
				},

				list = {
					-- Don't auto-select/insert the first row: <CR> on an unselected
					-- list inserts a real newline (matches the old coq pre_select=false).
					selection = { preselect = false, auto_insert = true },
					max_items = 60,
				},

				-- Insert "()" (and place the cursor) when accepting a function, using
				-- the LSP's own signature info — no extra round-trip.
				accept = {
					auto_brackets = { enabled = true },
				},

				menu = {
					border = "rounded",
					max_height = 12, -- ~pumheight; keeps the popup compact
					scrollbar = true,
					draw = {
						treesitter = { "lsp" }, -- syntax-highlight LSP labels
						-- Columns: [icon] [label + inline description] [kind word]
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},

				-- Documentation float. blink positions it on whichever side has room
				-- (and only fetches after the delay, on idle), so it no longer drops
				-- on top of your code the way coq's preview did. Flip auto_show to
				-- false if you'd rather pull docs manually with <C-space>/<C-k>.
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					window = { border = "rounded" },
				},

				ghost_text = { enabled = true }, -- inline preview of the top match
			},

			-- ---- Signature help (function params while typing args) ------------
			signature = {
				enabled = true,
				window = { border = "rounded" },
			},

			-- ---- Sources --------------------------------------------------------
			-- Priority is via `score_offset` (higher floats up): lsp > snippets >
			-- path > buffer, so semantic results win and buffer "word soup" sits last.
			sources = {
				default = { "lsp", "snippets", "path", "buffer" },
				providers = {
					lsp = {
						score_offset = 100,
						min_keyword_length = MIN_KEYWORD,
					},
					snippets = {
						score_offset = 80,
						min_keyword_length = MIN_KEYWORD,
					},
					path = {
						score_offset = 30,
						-- Resolve paths relative to the current file's directory.
						opts = {
							get_cwd = function(_)
								return vim.fn.expand("%:p:h")
							end,
						},
					},
					buffer = {
						score_offset = 0,
						min_keyword_length = MIN_KEYWORD,
						max_items = 8,
						-- Only scan visible buffers — big perf win in many-buffer sessions.
						opts = {
							get_bufnrs = function()
								return vim.tbl_map(function(win)
									return vim.api.nvim_win_get_buf(win)
								end, vim.api.nvim_tabpage_list_wins(0))
							end,
						},
					},
				},
			},

			-- ---- Fuzzy matcher --------------------------------------------------
			fuzzy = {
				-- Use the native Rust matcher; warn (don't hard-fail) if the prebuilt
				-- binary is missing so completion still works via the Lua fallback.
				implementation = "prefer_rust_with_warning",
				max_typos = function(keyword)
					-- Allow 1 typo per ~4 chars; stricter on short words.
					return math.floor(#keyword / 4)
				end,
				-- Float recently/frequently used items up (persisted across sessions)
				-- and boost items matching nearby words. Rust matcher only.
				frecency = { enabled = true },
				use_proximity = true,
			},

			-- Cmdline gets a lighter setup (no docs popup, manual menu).
			cmdline = {
				keymap = { preset = "inherit" },
				completion = {
					menu = { auto_show = true },
					ghost_text = { enabled = false },
				},
			},
		},

		config = function(_, opts)
			require("blink.cmp").setup(opts)

			-- Apply the theme-derived menu colors now and on every colorscheme swap.
			blink_highlights()
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("BlinkCmpHl", { clear = true }),
				callback = blink_highlights,
			})
		end,
	},
}
