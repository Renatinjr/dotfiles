local map = vim.keymap.set
local filter = require("utils.filter").filter
local filterReactDTS = require("utils.filterReactDTS").filterReactDTS
local errorTranslator = require("ts-error-translator")

-- Enhanced handlers with better error handling
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		silent = true,
		border = "rounded",
		focusable = false,
	}),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
		focusable = false,
	}),
	["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
		if not result or not result.diagnostics then
			return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
		end

		local filtered_diagnostics = {}
		for _, diagnostic in ipairs(result.diagnostics) do
			-- Skip CommonJS conversion suggestions and other noisy diagnostics
			if diagnostic.code ~= 80001 and diagnostic.code ~= 2691 then
				-- Translate TypeScript error message
				local success, translated = pcall(function()
					return errorTranslator.translate(diagnostic.message, diagnostic.code)
				end)

				if success and translated then
					diagnostic.message = translated
				end

				table.insert(filtered_diagnostics, diagnostic)
			end
		end

		result.diagnostics = filtered_diagnostics
		vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
	end,
	["textDocument/definition"] = function(err, result, method, ...)
		if not result or vim.tbl_isempty(result) then
			return vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
		end
		if vim.tbl_islist(result) and #result > 1 then
			local filtered_result = filter(result, filterReactDTS)
			return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
		end
		vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
	end,
}

local settings = {
	complete_function_calls = true,
	typescript = {
		preferences = {
			includePackageJsonAutoImports = "on",
			importModuleSpecifier = "relative",
			importModuleSpecifierEnding = "minimal",
			includeCompletionsWithSnippetText = true,
		},
		implementAbstractClasses = "auto",
		suggest = {
			completeFunctionCalls = true,
			includeCompletionsForModuleExports = true,
			includeCompletionsWithInsertText = true,
			includeAutomaticOptionalChainCompletions = true,
			includeCompletionsForImportStatements = true,
		},
		inlayHints = {
			includeInlayParameterNameHints = "literals",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = false,
			includeInlayVariableTypeHints = false,
			includeInlayPropertyDeclarationTypeHints = false,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
		updateImportsOnFileMove = { enabled = "always" },
		tsserver = {
			maxTsServerMemory = 2080,
			useBatchedBufferSync = true,
		},
		referencesCodeLens = {
			enabled = true,
			showOnAllFunctions = false,
		},
		implementationCodeLens = {
			enabled = true,
		},
	},
	javascript = {
		preferences = {
			includePackageJsonAutoImports = "on",
			importModuleSpecifier = "relative",
			importModuleSpecifierEnding = "minimal",
			includeCompletionsWithSnippetText = true,
		},
		suggest = {
			completeFunctionCalls = true,
			includeCompletionsForModuleExports = true,
			includeCompletionsWithInsertText = true,
			includeAutomaticOptionalChainCompletions = true,
		},
		inlayHints = {
			includeInlayParameterNameHints = "literals",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = false,
			includeInlayVariableTypeHints = false,
			includeInlayPropertyDeclarationTypeHints = false,
			includeInlayFunctionLikeReturnTypeHints = true,
		},
		updateImportsOnFileMove = { enabled = "always" },
		tsserver = {
			maxTsServerMemory = 2080,
			useBatchedBufferSync = true,
		},
	},
	vtsls = {
		enableMoveToFileCodeAction = true,
		autoUseWorkspaceTsdk = true,
		experimental = {
			completion = {
				enableServerSideFuzzyMatch = true,
				completeUnimported = true,
			},
		},
		codeLens = {
			references = true,
			implementations = true,
		},
	},
}

-- Enhanced on_attach function
local on_attach = function(client, bufnr)
	-- Enable omnifunc
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Enhanced move to file refactoring command
	client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
		local action, uri, range = unpack(command.arguments)
		local function move(newf)
			client.request("workspace/executeCommand", {
				command = command.command,
				arguments = { action, uri, range, newf },
			}, function(move_err, move_result)
				if move_err then
					vim.notify("Move to file failed: " .. tostring(move_err), vim.log.levels.ERROR)
					return
				end
				vim.notify("Successfully moved to " .. vim.fn.fnamemodify(newf, ":~:."))
			end)
		end

		local fname = vim.uri_to_fname(uri)
		client.request("workspace/executeCommand", {
			command = "typescript.tsserverRequest",
			arguments = {
				"getMoveToRefactoringFileSuggestions",
				{
					file = fname,
					startLine = range.start.line + 1,
					startOffset = range.start.character + 1,
					endLine = range["end"].line + 1,
					endOffset = range["end"].character + 1,
				},
			},
		}, function(_, result)
			if not result or not result.body or not result.body.files then
				vim.notify("No move suggestions available", vim.log.levels.WARN)
				return
			end

			local files = result.body.files
			table.insert(files, 1, "Enter new path...")
			vim.ui.select(files, {
				prompt = "Select move destination:",
				format_item = function(f)
					return vim.fn.fnamemodify(f, ":~:.")
				end,
			}, function(f)
				if not f then
					return
				end
				if f:find("^Enter new path") then
					vim.ui.input({
						prompt = "Enter move destination:",
						default = vim.fn.fnamemodify(fname, ":h") .. "/",
						completion = "file",
					}, function(newf)
						if newf and newf ~= "" then
							move(newf)
						end
					end)
				else
					move(f)
				end
			end)
		end)
	end

	-- Enhanced keymaps with better descriptions
	require("which-key").add({
		{ buffer = bufnr },
		{ "<leader>c", group = "TypeScript Actions" },
		{ "<leader>ce", "<cmd>TSC<CR>", desc = "workspace errors (TSC)" },
		{ "<leader>cF", "<cmd>VtsExec fix_all<CR>", desc = "fix all" },
		{ "<leader>ci", "<cmd>VtsExec add_missing_imports<CR>", desc = "import all" },
		{ "<leader>co", "<cmd>VtsExec organize_imports<CR>", desc = "organize imports" },
		{ "<leader>cs", "<cmd>VtsExec source_actions<CR>", desc = "source actions" },
		{ "<leader>cu", "<cmd>VtsExec remove_unused<CR>", desc = "remove unused" },
		{ "<leader>cV", "<cmd>VtsExec select_ts_version<CR>", desc = "select TS version" },
		{ "<leader>cf", "<cmd>VtsExec file_references<CR>", desc = "file references" },
	})

	-- Additional useful keymaps
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	map("n", "gD", vim.lsp.buf.declaration, bufopts)
	map("n", "gd", vim.lsp.buf.definition, bufopts)
	map("n", "K", vim.lsp.buf.hover, bufopts)
	map("n", "gi", vim.lsp.buf.implementation, bufopts)
	map("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)

	-- Prettier formatting keymap
	local curr_path = vim.fn.getcwd()
	map("n", "<leader>pw", "<cmd>term ~/.local/share/nvim/mason/bin/prettier --write " .. curr_path .. "<CR>", {
		buffer = bufnr,
		desc = "Prettier Format All",
	})

	vim.notify("TypeScript LSP attached", vim.log.levels.INFO)
end

-- Main configuration
local M = {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = function(fname)
		local util = require("lspconfig.util")
		local root = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git", "node_modules")(fname)

		if not root then
			root = util.find_package_json_ancestor(fname)
		end

		print(util.path.dirname(fname))
		return root
	end,
	single_file_support = true,
	capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("blink.cmp").get_lsp_capabilities() or {}
	),
	flags = {
		debounce_text_changes = 150,
		allow_incremental_sync = true,
	},
	handlers = handlers,
	on_attach = on_attach,
	settings = settings,
	workspace_folders = {
		{
			name = "workspace",
			uri = vim.uri_from_fname(vim.fn.getcwd()),
		},
	},
}

return {
	"yioneko/nvim-vtsls",
	lazy = true,
	ft = M.filetypes,
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"dmmulroy/ts-error-translator.nvim", -- Add this explicitly
	},
	opts = M,
	config = function(_, opts)
		local lspconfig = require("lspconfig")

		-- Enhanced setup with better error handling
		local ok, setup_err = pcall(function()
			lspconfig.vtsls.setup(opts)
		end)

		if not ok then
			vim.notify("Failed to setup vtsls: " .. tostring(setup_err), vim.log.levels.ERROR)
			return
		end

		-- Optional: Add type information on cursor hold
		vim.api.nvim_create_autocmd("CursorHold", {
			pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
			callback = function()
				if vim.b.lsp_current_servers and vim.b.lsp_current_servers.vtsls then
					vim.diagnostic.open_float(nil, {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = "rounded",
						source = "always",
						prefix = " ",
						scope = "cursor",
					})
				end
			end,
		})
		vim.api.nvim_create_user_command("TypeScriptReloadProjects", function()
			local clients = vim.lsp.get_active_clients({ name = "vtsls" })
			for _, client in ipairs(clients) do
				if client.supports_method("workspace/executeCommand") then
					client.request("workspace/executeCommand", {
						command = "typescript.reloadProjects",
						arguments = {},
					}, function(err, result)
						if err then
							vim.notify("Failed to reload projects: " .. tostring(err), vim.log.levels.ERROR)
						else
							vim.notify("TypeScript projects reloaded", vim.log.levels.INFO)
						end
					end)
				end
			end
		end, {})

		-- Auto-initialize project when opening TypeScript/JavaScript files
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
			callback = function(args)
				local bufnr = args.buf
				vim.defer_fn(function()
					-- Try to trigger auto-import discovery
					vim.lsp.buf_request(bufnr, "textDocument/completion", {
						textDocument = { uri = vim.uri_from_bufnr(bufnr) },
						position = { line = 0, character = 0 },
						context = { triggerKind = 1 }, -- Invoked
					}, function() end)
				end, 2000) -- Wait 2 seconds for project to load
			end,
		})
	end,
}
