return {
	{
		"mistweaverco/kulala.nvim",
		-- HTTP / REST client. Triggers loading on .http/.rest files and on the
		-- global keymaps below.
		ft = { "http", "rest" },
		keys = {
			{ "<leader>R", "", desc = "+REST (kulala)", mode = { "n", "v" } },
			{ "<leader>Rs", "<cmd>lua require('kulala').run()<cr>", mode = { "n", "v" }, desc = "Send request" },
			{
				"<leader>Ra",
				"<cmd>lua require('kulala').run_all()<cr>",
				mode = { "n", "v" },
				desc = "Send all requests",
			},
			{ "<leader>Rr", "<cmd>lua require('kulala').replay()<cr>", desc = "Replay last request" },
			{ "<leader>Rb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open scratchpad" },
			{ "<leader>Rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL" },
			{ "<leader>RC", "<cmd>lua require('kulala').from_curl()<cr>", desc = "Paste from cURL" },
			{ "<leader>Ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect current request" },
			{ "<leader>Rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request" },
			{ "<leader>Rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Jump to previous request" },
			{ "<leader>Rq", "<cmd>lua require('kulala').close()<cr>", desc = "Close kulala window" },
			{ "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
			{ "<leader>RS", "<cmd>lua require('kulala').show_stats()<cr>", desc = "Show request stats" },
			{ "<leader>Rx", "<cmd>lua require('kulala').scripts_clear_global()<cr>", desc = "Clear global variables" },
			{ "<leader>Re", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "Select environment" },
			{ "<leader>Rg", "<cmd>lua require('kulala.ui.auth_manager').open_auth_config()<cr>", desc = "Manage auth" },
			{ "<leader>Ro", "<cmd>lua require('kulala').open()<cr>", desc = "Open requests manager" },
		},
		---@type kulala.config.options
		opts = {
			-- ── core ────────────────────────────────────────────────────────
			-- Subprocess timeout (ms) for kulala-core. nil disables the timeout.
			kulala_core = {
				timeout = 60000,
			},
			-- Default environment name. Can be anything (dev, test, prod...).
			default_env = "default",
			-- "b" = per-buffer env (default), "g" = global.
			environment_scope = "b",
			-- Read VSCode REST Client environment variables from settings/workspace.
			vscode_rest_client_environmentvars = false,

			-- Scope for {{variables}} resolution: "document" keeps them local to
			-- the current file.
			variables_scope = "document",

			-- ── UI ──────────────────────────────────────────────────────────
			ui = {
				-- "split" or "float".
				display_mode = "split",
				-- "above" | "right" | "below" | "left".
				split_direction = "right",
				-- Initial pane: "body" | "headers" | "headers_body" | "verbose" | fn.
				default_view = "body",
				-- Tab bar at the top of the result buffer.
				winbar = true,
				default_winbar_panes = { "body", "headers", "verbose", "script_output", "report" },
				-- Show variable name/value as a float on hover: false | "float".
				show_variable_info_text = false,
				-- Inlay icon placement: "signcolumn" | "on_request" |
				-- "above_request" | "below_request" | nil.
				show_icons = "on_request",
				-- Show the request summary (method/url/status) in the output window.
				show_request_summary = true,
				-- Skip rendering responses larger than this (bytes).
				max_response_size = 32768,
				-- Inline body in `Copy as cURL` only below this size (bytes).
				max_request_size = 2048,

				report = {
					-- true | false | "on_error".
					show_script_output = true,
					-- true | false | "on_error" | "failed_only".
					show_asserts_output = true,
					-- true | false | "on_error".
					show_summary = true,
				},

				-- Contents of the scratchpad buffer.
				scratchpad_default_contents = {
					"@MY_TOKEN_NAME=my_token_value",
					"",
					"# @name scratchpad",
					"POST https://httpbin.org/post HTTP/1.1",
					"accept: application/json",
					"content-type: application/json",
					"",
					"{",
					'  "foo": "bar"',
					"}",
				},

				disable_news_popup = true,
			},

			-- ── LSP ─────────────────────────────────────────────────────────
			lsp = {
				enable = true,
				filetypes = {
					"http",
					"rest",
					"json",
					"yaml",
					"bruno",
				},
				-- Kulala relies on Neovim's default LSP keymaps; leave its own off.
				keymaps = false,
				formatter = {
					-- Split query/form params onto multiple lines past this count.
					split_params = 4,
					sort = {
						metadata = true,
						variables = true,
						commands = false,
						json = true,
					},
					-- Add quotes around {{variable}} in JSON bodies.
					quote_json_variables = true,
					indent = 2,
				},
			},

			-- ── misc ────────────────────────────────────────────────────────
			-- false disables, 1-4 for error/warn/info/debug verbosity.
			debug = false,
			generate_bug_report = false,

			-- Keymaps are declared above via lazy `keys`, so let kulala's own
			-- global keymaps stay off to avoid duplicates.
			global_keymaps = false,
			global_keymaps_prefix = "<leader>R",
			-- UI buffer keymaps (H, B, q, etc. inside the result window).
			kulala_keymaps = true,
			kulala_keymaps_prefix = "",
		},
		config = function(_, opts)
			-- Make sure .http files are detected as the http filetype.
			vim.filetype.add({
				extension = {
					["http"] = "http",
				},
			})
			require("kulala").setup(opts)
		end,
	},
}
