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

-- Filetypes served by the TypeScript 7.0 language server (plugins/lsp/tsc.lua),
-- where a completion is far more expensive than in other languages.

local function blink_palette()
	local ok_theme, theme = pcall(require, "config.theme")
	if ok_theme and type(theme.current_theme) == "table" and type(theme.current_theme.blink) == "table" then
		return theme.current_theme.blink
	end

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
	return {
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
end

local function blink_highlights()
	local c = blink_palette()

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
				-- Manual completion trigger, bound three ways:
				--   <C-space>  what most terminals send
				--   <C-@>      what others send for the same chord (NUL)
				--   <C-l>      terminal-safe fallback -- macOS binds Ctrl+Space to
				--              "Select the previous input source" (symbolic hotkeys 60
				--              and 61) and swallows it system-wide, so neither of the
				--              first two ever reaches Neovim until that is turned off
				--              in System Settings > Keyboard > Keyboard Shortcuts >
				--              Input Sources. <C-l> is unmapped in insert mode.
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-@>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-l>"] = { "show", "show_documentation", "hide_documentation" },
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
					-- Fully manual: the menu only appears on <C-space>/<C-l>, never
					-- while typing. Every automatic path is a request to the language
					-- server for the whole open buffer, and on a large TS/JS file that
					-- costs the server ~1.2s and a fresh type checker each time -- one
					-- line of typing fired five of them and pinned the CPU. Manual-only
					-- makes that cost something you ask for rather than something you
					-- pay per word, in every language.
					prefetch_on_insert = false,
					show_on_keyword = false,
					show_on_trigger_character = false, -- ".", "::" etc. no longer fire
					show_on_insert = false,
					show_on_backspace = false,
					show_on_backspace_in_keyword = false,
					show_on_backspace_after_accept = false,
					show_on_backspace_after_insert_enter = false,
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

				-- Documentation float, on demand only.
				--
				-- auto_show fetches docs for whichever entry is selected, which means
				-- one completionItem/resolve per entry you move over. Against the TS 7.0
				-- server that is the single most expensive thing this config can do: a
				-- resolve issued after an edit forces a fresh type checker for the new
				-- program version, and the server's checker pool keeps them. Measured on
				-- a 5154-line controller, eight rounds of "type a line, complete, move
				-- over 40 entries":
				--
				--   auto_show = true    1.16 -> 3.68 GB, and it does not come back down
				--   auto_show = false   1.16 -> 1.23 GB
				--
				-- The completions themselves are not the cost -- the same eight rounds
				-- request 1487 items each either way. It is purely resolve-on-hover, and
				-- disabling auto-imports does not help (3.78 GB), so there is nothing to
				-- fix on the server side. Press <C-space>/<C-l> a second time with the
				-- menu open to pull docs for the selected entry.
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 250,
					window = { border = "rounded" },
				},

				ghost_text = { enabled = true }, -- inline preview of the top match
			},

			-- ---- Signature help (function params while typing args) ------------
			signature = {
				enabled = true,
				window = { border = "rounded" },
				-- Same reasoning as completion.trigger: blink otherwise fires
				-- textDocument/signatureHelp on "(" and friends as you type. <C-k>
				-- shows it on demand.
				trigger = { enabled = false },
			},

			-- ---- Sources --------------------------------------------------------
			-- Priority is via `score_offset` (higher floats up): lsp > snippets >
			-- path > buffer, so semantic results win and buffer "word soup" sits last.
			sources = {
				default = { "lsp", "snippets", "path", "buffer" },
				providers = {
					lsp = {
						score_offset = 100,
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
			-- Stop blink speculatively resolving whatever entry is selected.
			--
			-- completion/init.lua registers a prefetch on select_emitter with no
			-- config flag behind it, so moving through the menu fires one
			-- completionItem/resolve per entry even with documentation.auto_show
			-- off. It debounces 50 ms and cancels the previous request, but an LSP
			-- cancel does not unwind work the server has already started -- measured
			-- against tsc, cancelling a fast scroll still cost 1.17 -> 1.80 GB.
			--
			-- Resolve is the expensive request for the TypeScript 7.0 server: issued
			-- after an edit it forces a fresh type checker for the new program
			-- version, and the checker pool keeps them. Eight rounds of "type a
			-- line, complete, move over 40 entries" on a 5154-line controller took
			-- the server from 1.16 to 3.68 GB, none of it released.
			--
			-- Accepting an item (completion/accept) and opening the docs window both
			-- call sources.resolve directly, so both still work -- auto-import edits
			-- on accept included. Only the speculative call is gone. The stub must
			-- be in place before the first selection; require() inside the emitter
			-- callback picks it up from package.loaded.
			package.loaded["blink.cmp.completion.prefetch"] = function() end

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
