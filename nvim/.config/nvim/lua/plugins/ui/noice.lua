return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			-- Initialize opts.routes if it doesn't exist
			opts.routes = opts.routes or {}

			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})

			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})

			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {
			timeout = 5000,
		},
		config = function(_, opts)
			-- Resolved once at setup(); config.theme.switcher re-applies it on ColorScheme.
			opts.background_colour = require("config.theme").current_theme.bg_notify
			require("notify").setup(opts)
		end,
	},
}
