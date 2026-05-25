-- yazi.nvim: Yazi (terminal file manager) integration for Neovim.
-- Requires `yazi` (>= 0.4.0) installed on the system PATH.
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = {
		-- snacks.nvim provides the floating-window picker UI used by yazi.nvim
		-- for prompts (rename, delete confirmation, etc.). If you don't have
		-- it installed elsewhere, yazi.nvim falls back to vim.ui.select.
		{ "folke/snacks.nvim", lazy = true },
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<C-n>",
			function()
				require("yazi").yazi()
			end,
			desc = "Open yazi at current file",
		},
		{
			"<leader>nf",
			function()
				require("yazi").yazi()
			end,
			desc = "Open yazi at current file",
		},
		{
			"<leader>nF",
			function()
				require("yazi").yazi(nil, vim.fn.getcwd())
			end,
			desc = "Open yazi at cwd",
		},
		{
			"<leader>nr",
			"<cmd>Yazi toggle<CR>",
			desc = "Resume last yazi session",
		},
		{
			"<leader>-",
			function()
				require("yazi").yazi()
			end,
			desc = "Open yazi at current file",
		},
	},
	---@type YaziConfig | {}
	opts = {
		-- Open yazi instead of netrw when opening a directory
		open_for_directories = true,

		-- Keymaps used inside the floating yazi window
		keymaps = {
			show_help = "<f1>",
			open_file_in_vertical_split = "<c-v>",
			open_file_in_horizontal_split = "<c-x>",
			open_file_in_tab = "<c-t>",
			grep_in_directory = "<c-s>",
			replace_in_directory = "<c-g>",
			cycle_open_buffers = "<tab>",
			copy_relative_path_to_selected_files = "<c-y>",
			send_to_quickfix_list = "<c-q>",
			change_working_directory = "<c-\\>",
			open_and_pick_window = "<c-o>",
		},

		-- Floating window appearance
		floating_window_scaling_factor = 0.9,
		yazi_floating_window_winblend = 0,
		yazi_floating_window_border = "rounded",

		-- Keep the same buffer that was opened from yazi as the current one
		-- (avoids surprising jumps when yazi closes).
		future_features = {
			-- Update neovim's CWD when yazi's CWD changes (matches the
			-- update_focused_file/update_root behaviour we had with nvim-tree).
			use_cwd_file = true,
			use_yazi_client_id_flag = true,
		},

		-- Forward delete/rename/move/trash operations to LSP so import paths,
		-- references, etc. stay in sync (vtsls, gopls, rust-analyzer all
		-- understand workspace/willRenameFiles).
		integrations = {
			grep_in_directory = function(directory)
				require("telescope.builtin").live_grep({
					search = "",
					prompt_title = "Grep in " .. directory,
					cwd = directory,
				})
			end,
			grep_in_selected_files = function(selected_files)
				require("telescope.builtin").live_grep({
					search = "",
					prompt_title = "Grep in selected files",
					search_dirs = selected_files,
				})
			end,
			replace_in_directory = function(directory)
				require("grug-far").open({
					prefills = { paths = directory.filename },
				})
			end,
			replace_in_selected_files = function(selected_files)
				local paths = vim.iter(selected_files)
					:map(function(p)
						return p.filename
					end)
					:join("\n")
				require("grug-far").open({ prefills = { paths = paths } })
			end,
		},

		-- Forward file rename/move events to LSP clients that support them
		hooks = {
			yazi_opened_multiple_files = function(chosen_files)
				for _, file in ipairs(chosen_files) do
					vim.cmd("edit " .. vim.fn.fnameescape(file))
				end
			end,
			-- After yazi closes, nudge gitsigns + diagnostics so they re-read
			-- the working tree (file may have been renamed/deleted in yazi).
			yazi_closed_successfully = function(chosen_file, config, state)
				local ok, gitsigns = pcall(require, "gitsigns")
				if ok then
					gitsigns.refresh()
				end
				vim.cmd("checktime")
			end,
		},

		-- Clear statuscolumn inside the yazi floating window so the file
		-- manager UI isn't cluttered with line numbers / gitsigns.
		set_keymappings_function = function(yazi_buffer)
			vim.opt_local.statuscolumn = ""
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
			vim.opt_local.signcolumn = "no"
		end,
	},
	init = function()
		-- Disable netrw so yazi handles directory opens (e.g. `nvim .`)
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
}
