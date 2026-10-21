-- Debug Adapter Protocol: nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"williamboman/mason.nvim",
		},
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Conditional Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Open REPL",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "DAP Continue",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "DAP Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "DAP Step Into",
			},
			{
				"<S-F11>",
				function()
					require("dap").step_out()
				end,
				desc = "DAP Step Out",
			},
		},
		config = function()
			local dap = require("dap")

			-- Breakpoint signs
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "▶", texthl = "DiagnosticSignInfo", linehl = "DapStoppedLine", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
			)

			-- JS/TS adapter (vscode-js-debug via Mason)
			local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
				},
			}

			for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
				dap.configurations[lang] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end

			-- Go adapter (Delve)
			dap.adapters.delve = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			dap.configurations.go = {
				{
					type = "delve",
					name = "Debug",
					request = "launch",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug test",
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug test (go.mod)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
			}

			-- PHP adapter (Xdebug via vscode-php-debug from Mason).
			--
			-- php-debug-adapter is a node: wrapper in Mason's bin dir, which
			-- config/options.lua has already prepended to PATH.
			dap.adapters.php = {
				type = "executable",
				command = "php-debug-adapter",
			}

			dap.configurations.php = {
				{
					-- The usual one: start this, then hit a route or run a command
					-- with the Xdebug trigger set and the request stops here.
					--   XDEBUG_TRIGGER=1 php artisan queue:work
					--   curl 'localhost:8000/?XDEBUG_TRIGGER=1'
					-- The trigger is required because php.ini sets
					-- xdebug.start_with_request=trigger, so ordinary runs never
					-- pay the connection cost.
					type = "php",
					request = "launch",
					name = "Listen for Xdebug (:9003)",
					port = 9003,
					-- Only needed when php runs somewhere else than this filesystem
					-- (Sail/DDEV/a remote host). For Laravel Sail that is:
					--   pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
				},
				{
					-- No trigger needed: Xdebug is told to connect for this one run.
					type = "php",
					request = "launch",
					name = "Debug current script",
					program = "${file}",
					cwd = "${fileDirname}",
					port = 0, -- let the adapter pick a free port and pass it on
					runtimeArgs = { "-dxdebug.start_with_request=yes" },
				},
				{
					type = "php",
					request = "launch",
					name = "Debug artisan command",
					program = "${workspaceFolder}/artisan",
					cwd = "${workspaceFolder}",
					port = 0,
					runtimeArgs = { "-dxdebug.start_with_request=yes" },
					args = function()
						return vim.split(vim.fn.input("artisan "), " ", { trimempty = true })
					end,
				},
			}

			-- Rust: handled by rustaceanvim (codelldb adapter)

			-- Virtual text
			require("nvim-dap-virtual-text").setup({})
		end,
	},

	-- DAP UI
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle DAP UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Eval Expression",
				mode = { "n", "v" },
			},
		},
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)

			-- Auto open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- Virtual text for debugger
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
	},
}
