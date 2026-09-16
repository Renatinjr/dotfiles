-- Small helpers shared across the config. Keep this file to things that are
-- actually required from more than one place; one-off helpers belong next to
-- their only caller.
local M = {}

-- ── Notifications ──────────────────────────────────────────────────────

local fast_event_aware_notify = function(msg, level, opts)
	if vim.in_fast_event() then
		vim.schedule(function()
			vim.notify(msg, level, opts)
		end)
	else
		vim.notify(msg, level, opts)
	end
end

function M.info(msg)
	fast_event_aware_notify(msg, vim.log.levels.INFO, {})
end

function M.warn(msg)
	fast_event_aware_notify(msg, vim.log.levels.WARN, {})
end

function M.err(msg)
	fast_event_aware_notify(msg, vim.log.levels.ERROR, {})
end

-- ── Windows ────────────────────────────────────────────────────────────

-- Grow/shrink the current split by `margin` lines/columns, flipping the sign
-- when the window is the last one in that direction so the key always "feels"
-- like it moves the border the same way.
M.resize = function(vertical, margin)
	local cur_win = vim.api.nvim_get_current_win()
	vim.cmd(string.format("wincmd %s", vertical and "l" or "j"))
	local new_win = vim.api.nvim_get_current_win()

	local not_last = not (cur_win == new_win)
	local sign = margin > 0
	if not_last == true then
		vim.cmd([[wincmd p]])
	else
		sign = not sign
	end

	local sign_str = sign and "+" or "-"
	local dir = vertical and "vertical " or ""
	local cmd = dir .. "resize " .. sign_str .. math.abs(margin) .. "<CR>"
	vim.cmd(cmd)
end

M.win_is_float = function(winnr)
	local wincfg = vim.api.nvim_win_get_config(winnr)
	if wincfg and (wincfg.external or wincfg.relative and #wincfg.relative > 0) then
		return true
	end
	return false
end

M.tmux_aware_navigate = function(direction, no_wrap)
	local curwin = vim.api.nvim_get_current_win()
	if not M.win_is_float(curwin) or direction == "h" then
		vim.cmd.wincmd(direction == "o" and "w" or direction)
		if not vim.env.TMUX or vim.api.nvim_get_current_win() ~= curwin then
			return
		end
	end
	local tmux_pane_flag = {
		["h"] = "-L",
		["j"] = "-D",
		["k"] = "-U",
		["l"] = "-R",
		["o"] = "-l",
	}
	local tmux_pane_to = {
		["h"] = "left",
		["j"] = "bottom",
		["k"] = "top",
		["l"] = "right",
	}
	local args = { "tmux" }
	if no_wrap then
		table.insert(args, "if-shell")
		table.insert(args, "-F")
		table.insert(args, string.format("#{pane_at_%s}", tmux_pane_to[direction]))
		table.insert(args, "")
		table.insert(args, string.format("select-pane -t %s %s", vim.env.TMUX_PANE, tmux_pane_flag[direction]))
	else
		table.insert(args, "select-pane")
		table.insert(args, "-t")
		table.insert(args, vim.env.TMUX_PANE)
		table.insert(args, tmux_pane_flag[direction])
	end
	vim.fn.system(args)
end

-- Registers :YaziIconsExport.
require("utils.yazi-icons")

return M
