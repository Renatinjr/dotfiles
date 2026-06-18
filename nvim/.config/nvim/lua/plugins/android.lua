return {
	"iamironz/android-nvim-plugin",
	lazy = false,
	-- Requires the Android SDK + `adb` on your PATH. Run `:checkhealth android`
	-- if the SDK isn't picked up automatically.
	config = function()
		require("android").setup({
			-- SDK discovery: env vars are checked first, then the candidates below.
			sdk = {
				root_env_keys = { "ANDROID_SDK_ROOT", "ANDROID_HOME" },
				local_properties = true, -- read sdk.dir from local.properties
				root_candidates = {
					vim.fn.expand("~/Android/Sdk"),
					vim.fn.expand("~/Library/Android/sdk"),
				},
			},

			-- Run config for the Kotlin app module.
			run = {
				-- Prefer the conventional Android app module; falls back to a
				-- picker when none of these match.
				module_preference = { ":app", ":androidApp" },
			},

			-- Build with the project's Gradle wrapper.
			build = {
				gradle_command = "./gradlew",
				scan_all_apk_outputs = true,
			},

			ui = {
				autosave = true, -- save buffers before build/run
				file_watcher = true,
				restore_logcat = true, -- reopen logcat on startup if it was open
			},

			-- Default <leader>a* mappings are enabled by the plugin:
			--   <leader>am AndroidMenu   <leader>at AndroidTargets
			--   <leader>ao AndroidTools  <leader>aa AndroidActions
			--   <leader>ab AndroidBuild
			keymaps = { enabled = true },
		})

		-- Extra shortcuts for the run/logcat commands that ship without one.
		local map = vim.keymap.set
		map("n", "<leader>aar", "<cmd>AndroidRun<cr>", { desc = "Android: run app" })
		map("n", "<leader>ax", "<cmd>AndroidRunStop<cr>", { desc = "Android: stop run" })
		map("n", "<leader>al", "<cmd>AndroidLogcat<cr>", { desc = "Android: logcat" })
	end,
}
