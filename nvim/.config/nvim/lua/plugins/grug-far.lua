return {
	{
		"MagicDuck/grug-far.nvim",
		-- Note (lazy loading): grug-far.lua defers all its requires so it's lazy by default.
		-- We still gate on cmd/keys to keep startup lean and define handy entry points.
		cmd = { "GrugFar", "GrugFarWithin" },
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open()
				end,
				mode = "n",
				desc = "Search/Replace (project)",
			},
			{
				"<leader>sw",
				function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
				end,
				mode = "n",
				desc = "Search/Replace word under cursor",
			},
			{
				"<leader>sW",
				function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cWORD>") } })
				end,
				mode = "n",
				desc = "Search/Replace WORD under cursor",
			},
			{
				"<leader>srf",
				function()
					-- Limit the search to the current file only.
					require("grug-far").open({
						prefills = { paths = vim.fn.expand("%") },
					})
				end,
				mode = "n",
				desc = "Search/Replace in current file",
			},
			{
				"<leader>sr",
				function()
					-- Visual mode: prefill the search with the current selection.
					require("grug-far").with_visual_selection()
				end,
				mode = "v",
				desc = "Search/Replace selection",
			},
			{
				"<leader>sR",
				function()
					-- Visual mode: search within the selected range only.
					require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
				end,
				mode = "v",
				desc = "Search/Replace within selection (current file)",
			},
			{
				"<leader>st",
				function()
					-- Toggle a single reusable ("transient") instance.
					require("grug-far").toggle_instance({ instanceName = "main", staticTitle = "Find and Replace" })
				end,
				mode = "n",
				desc = "Toggle Search/Replace panel",
			},
		},
		config = function()
			require("grug-far").setup({
				-- ── Search behaviour ─────────────────────────────────────────────
				debounceMs = 500, -- delay after typing before searching
				minSearchChars = 2, -- minimum chars before a search fires
				maxSearchMatches = 2000, -- cap matches to keep the UI responsive
				maxLineLength = 1000, -- trim very long matched lines
				maxWorkers = 8, -- parallel workers used for replacement
				normalModeSearch = false, -- search live while typing (insert mode)
				smartInputHandling = true, -- smart cursor/insert behaviour in inputs

				-- ── Window / layout ──────────────────────────────────────────────
				windowCreationCommand = "vsplit", -- "split" for horizontal, "tabnew", etc.
				startInInsertMode = true,
				startCursorRow = 1,
				wrap = true,
				disableBufferLineNumbers = true,
				showCompactInputs = false, -- single-line inputs to save space
				showInputsTopPadding = true,
				showInputsBottomPadding = true,
				transient = false, -- close buffer automatically after replace

				-- ── Status / info display ────────────────────────────────────────
				showStatusIcon = true,
				showEngineInfo = true,
				showStatusInfo = true,
				reportDuration = true,
				resultsSeparatorLineChar = "─",

				-- ── Engine selection ─────────────────────────────────────────────
				-- ripgrep is the default; ast-grep engines are available via <localleader>e
				-- (swapEngine) once `ast-grep` is installed.
				engine = "ripgrep",
				enabledEngines = { "ripgrep", "astgrep", "astgrep-rules" },

				engines = {
					ripgrep = {
						path = "rg",
						-- Sensible defaults: follow symlinks, search hidden files,
						-- but keep ignoring .git via the explicit glob.
						extraArgs = "--hidden --follow --glob=!**/.git/*",
						showReplaceDiff = true,
						placeholders = { enabled = true },
					},
					astgrep = {
						path = "ast-grep",
						extraArgs = "",
						showReplaceDiff = true,
						placeholders = { enabled = true },
					},
					["astgrep-rules"] = {
						path = "ast-grep",
						extraArgs = "",
						placeholders = { enabled = true },
					},
				},

				-- ── Replacement interpreters ─────────────────────────────────────
				-- Allows Lua / Vimscript expressions in the replacement field,
				-- toggle with <localleader>x (swapReplacementInterpreter).
				enabledReplacementInterpreters = { "default", "lua", "vimscript" },
				replacementInterpreter = "default",

				-- ── Folding ──────────────────────────────────────────────────────
				folding = {
					enabled = true,
					foldlevel = 1, -- start with files expanded, matches collapsible
					foldcolumn = "1",
					include_file_path = false,
				},

				-- ── History ──────────────────────────────────────────────────────
				history = {
					maxHistoryLines = 10000,
					historyDir = vim.fn.stdpath("state") .. "/grug-far",
					autoSave = {
						enabled = true,
						onReplace = true,
						onSyncAll = true,
						onBufDelete = true,
					},
				},

				-- ── Icons (requires a Nerd Font; set enabled=false otherwise) ─────
				icons = {
					enabled = true,
					fileIconsProvider = "first_available", -- nvim-web-devicons / mini.icons
				},

				-- ── Keymaps (buffer-local, prefixed with <localleader>) ──────────
				-- Override only what you want; everything else keeps the defaults.
				keymaps = {
					replace = { n = "<localleader>r" },
					qflist = { n = "<localleader>q" },
					syncLocations = { n = "<localleader>s" },
					syncLine = { n = "<localleader>l" },
					close = { n = "<localleader>c" },
					historyOpen = { n = "<localleader>t" },
					historyAdd = { n = "<localleader>a" },
					refresh = { n = "<localleader>f" },
					openLocation = { n = "<localleader>o" },
					openNextLocation = { n = "<down>" },
					openPrevLocation = { n = "<up>" },
					gotoLocation = { n = "<enter>" },
					pickHistoryEntry = { n = "<enter>" },
					abort = { n = "<localleader>b" },
					help = { n = "g?" },
					toggleShowCommand = { n = "<localleader>w" },
					swapEngine = { n = "<localleader>e" },
					previewLocation = { n = "<localleader>i" },
					swapReplacementInterpreter = { n = "<localleader>x" },
					applyNext = { n = "<localleader>j" },
					applyPrev = { n = "<localleader>k" },
					syncNext = { n = "<localleader>n" },
					syncPrev = { n = "<localleader>p" },
					syncFile = { n = "<localleader>v" },
					nextInput = { n = "<tab>" },
					prevInput = { n = "<s-tab>" },
				},
			})

			-- Per-buffer tweaks for the grug-far results window.
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("grug_far_local", { clear = true }),
				pattern = "grug-far",
				callback = function()
					-- Don't wrap inside the panel and keep cursorline for orientation.
					vim.opt_local.wrap = false
					vim.opt_local.cursorline = true
				end,
			})
		end,
	},
}
