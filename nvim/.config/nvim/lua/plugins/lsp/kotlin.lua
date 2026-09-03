-- Kotlin development: kotlin.nvim (v2)
--
-- kotlin.nvim drives JetBrains' kotlin-lsp (the IntelliJ language engine run
-- headless as `bin/intellij-server --stdio`). It builds `vim.lsp.config.kotlin_lsp`
-- itself and starts the client from its own FileType autocmd, so there is no
-- `on_attach` option here — buffer-local keymaps hang off an LspAttach autocmd
-- below instead.
--
-- Requires Neovim >= 0.11 and kotlin-lsp >= v262.4739.0 (folding, file templates
-- and call hierarchy are gated on that build). `:checkhealth kotlin` verifies both.

local map = vim.keymap.set

-- kotlin-lsp runs on its own bundled JBR; this JDK is what your *code* is
-- analyzed against (JDK APIs, platform types). v2 does no auto-detection, and
-- asdf's shim hides the real JAVA_HOME behind a wrapper script, so ask asdf
-- directly. Runs once, when the first .kt buffer opens.
local function detect_jdk()
	local java_home = os.getenv("JAVA_HOME")
	if java_home and java_home ~= "" then
		return java_home
	end

	if vim.fn.executable("asdf") == 1 then
		local out = vim.trim(vim.fn.system({ "asdf", "where", "java" }))
		if vim.v.shell_error == 0 and vim.uv.fs_stat(out .. "/bin/java") then
			return out
		end
	end

	return nil -- let kotlin-lsp fall back to its own resolution
end

local opts = {
	-- Priority-grouped, exactly like Neovim's own root_markers resolution: the
	-- first group wins outright, so a multi-module build roots on the workspace
	-- dir (settings.gradle.kts) rather than the nearest module's build.gradle.kts.
	root_markers = {
		{ "settings.gradle", "settings.gradle.kts", "mvnw", "mvnw.cmd", ".git" },
		{ "build.gradle", "build.gradle.kts", "pom.xml" },
	},

	-- JDK used for symbol resolution — sent as init_options.defaultSdk/defaultJdk.
	-- Should match the project's target JDK. Leave the resolver to find it, or
	-- pin one per project via .kotlin-lsp.lua (see below).
	jdk_for_symbol_resolution = detect_jdk(),

	-- Extra JVM args for the server process, passed via $IJ_JAVA_OPTIONS.
	jvm_args = {
		"-Xmx4g", -- IntelliJ's indexer is memory-hungry on large Gradle projects
	},

	-- "gradle" | "maven" | nil (let the server decide). Everything JVM here is
	-- Gradle (see lua/plugins/android.lua), so skip the probe.
	build_tool = "gradle",

	-- LSP-driven folding via textDocument/foldingRange. The global capabilities
	-- block in lua/plugins/lsp/init.lua already advertises lineFoldingOnly.
	folding = {
		enabled = true,
	},

	-- IntelliJ file templates, surfaced by :KotlinNewFromTemplate.
	file_templates = {
		enabled = true,
	},

	-- Inlay hints, mapped onto kotlin-lsp's `jetbrains.kotlin.hints.*` optionIds.
	-- Everything defaults to true except parameters_excluded/parameters_context/
	-- call_chains; all keys are spelled out so the set is visible at a glance.
	inlay_hints = {
		enabled = true, -- master switch (auto-enabled on LSP attach)
		parameters = true, -- parameter names at call sites
		parameters_compiled = true, -- same, for compiled/external functions
		parameters_excluded = false, -- parameters IntelliJ excludes by default
		parameters_context = false, -- context parameter hints
		types_property = true, -- inferred property types
		types_variable = true, -- inferred local variable types
		function_return = true, -- inferred function return types
		function_parameter = true, -- function parameter types
		lambda_return = true, -- lambda return types
		lambda_receivers_parameters = true, -- lambda receivers/parameters
		value_ranges = true, -- value range hints
		kotlin_time = true, -- kotlin.time unit warnings
		call_chains = false, -- intermediate types in method chains (noisy)
	},
}

-- Per-project overrides live in a `.kotlin-lsp.lua` at the project root and are
-- deep-merged over the table above, e.g.
--   return { jdk_for_symbol_resolution = "/path/to/jdk-17", build_tool = "maven" }
-- Dropping an empty `.disable-kotlin-lsp` file there turns the server off entirely.

-- `<leader>k` is globally the fzf-lua keymaps picker (lua/plugins/fzf.lua); these
-- buffer-local maps shadow it inside Kotlin buffers only.
--
-- Set with vim.keymap.set rather than which-key's `add()`: which-key only drains
-- its spec queue once, from its own setup() (which-key/config.lua:284-287), so an
-- `add()` issued later — e.g. from an LspAttach handler like this one — is queued
-- and silently never applied. The group label below still goes through which-key,
-- via the module that setup() itself calls, so the popup reads "Kotlin".
local function on_attach(bufnr)
	local keys = {
		{ "<leader>ka", "<cmd>KotlinCodeActions<CR>", "code actions" },
		{ "<leader>kq", "<cmd>KotlinQuickFix<CR>", "quick fix" },
		{ "<leader>ko", "<cmd>KotlinOrganizeImports<CR>", "organize imports" },
		{ "<leader>kf", "<cmd>KotlinFormat<CR>", "format (IntelliJ rules)" },
		{ "<leader>ks", "<cmd>KotlinSymbols<CR>", "document symbols" },
		{ "<leader>kS", "<cmd>KotlinWorkspaceSymbols<CR>", "workspace symbols" },
		{ "<leader>kr", "<cmd>KotlinReferences<CR>", "references" },
		{ "<leader>kn", "<cmd>KotlinRename<CR>", "rename symbol" },
		{ "<leader>kt", "<cmd>KotlinTypeDefinition<CR>", "type definition" },
		{ "<leader>ki", "<cmd>KotlinImplementation<CR>", "implementation" },
		{ "<leader>kc", "<cmd>KotlinIncomingCalls<CR>", "incoming calls" },
		{ "<leader>kC", "<cmd>KotlinOutgoingCalls<CR>", "outgoing calls" },
		{ "<leader>kh", "<cmd>KotlinInlayHintsToggle<CR>", "toggle inlay hints" },
		{ "<leader>kH", "<cmd>KotlinHintsToggle<CR>", "toggle HINT diagnostics" },
		{ "<leader>kT", "<cmd>KotlinNewFromTemplate<CR>", "new from template" },
		{ "<leader>kd", "<cmd>KotlinDebug<CR>", "attach debugger (:5005)" },
		{ "<leader>kw", "<cmd>KotlinCleanWorkspace<CR>", "clean workspace cache" },
		{ "<leader>kl", "<cmd>KotlinShowLogs<CR>", "show LSP logs" },
	}
	for _, key in ipairs(keys) do
		map("n", key[1], key[2], { buffer = bufnr, silent = true, desc = key[3] })
	end

	pcall(function()
		require("which-key.config").add({ { "<leader>k", group = "Kotlin", buffer = bufnr } })
	end)
end

return {
	"AlexandrosAlexiou/kotlin.nvim",
	ft = { "kotlin" },
	dependencies = {
		"mason.nvim",
		-- Required by :KotlinSymbols — the plugin calls require("trouble") with no
		-- pcall guard, so the command errors outright when it is missing.
		{ "folke/trouble.nvim", opts = {} },
		-- Backs "go to definition" into package declarations and decompiled sources.
		{ "stevearc/oil.nvim", opts = {} },
	},
	config = function()
		require("kotlin").setup(opts)

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("KotlinLspKeymaps", { clear = true }),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "kotlin_lsp" then
					on_attach(args.buf)
				end
			end,
			desc = "Kotlin buffer-local keymaps",
		})
	end,
}
