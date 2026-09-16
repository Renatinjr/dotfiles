local conditions = require("heirline.conditions")
local uv = vim.uv
local tbl = {}

tbl.tbl_get = function(t, ...)
	local keys = { ... }
	for _, key in ipairs(keys) do
		if type(t) ~= "table" then
			return nil
		end
		t = t[key]
	end
	return t
end

tbl.tbl_empty = function(t)
	return not t or next(t) == nil
end

local constants = {
	diagnostic = {
		signs = {
			error = "",
			warn = "",
			info = "",
			hint = "",
		},
	},
}

local function get_hl(name)
	return vim.api.nvim_get_hl(0, { name = name, link = false })
end

-- nvim_get_hl hands back packed integers, and leaves the key absent entirely
-- when a group doesn't set that attribute — which is the normal case for `bg`
-- under the transparent colorschemes in this config.
local function hex(value)
	return value and string.format("#%06x", value) or nil
end

-- First group in the list that actually defines `attr`.
local function first_hl(attr, ...)
	for _, name in ipairs({ ... }) do
		local value = hex(get_hl(name)[attr])
		if value then
			return value
		end
	end
end

-- Mix two hex colors, for the surfaces derived below.
local function blend(fg, bg, alpha)
	local function mix(i)
		local a = tonumber(fg:sub(i, i + 1), 16) * alpha
		local b = tonumber(bg:sub(i, i + 1), 16) * (1 - alpha)
		return math.floor(math.min(math.max(a + b, 0), 255) + 0.5)
	end
	return string.format("#%02X%02X%02X", mix(2), mix(4), mix(6))
end

-- The statusline's palette, rebuilt on every ColorScheme by update_colors().
--
-- Two sources, in order: config.theme.current_theme — the same palette
-- nvim-tree, fzf-lua, bufferline and the blink menu are painted from, and the
-- only one that knows a transparent theme's real background — and then the live
-- highlight groups for everything semantic, so an unregistered `:colorscheme`
-- still lands somewhere sensible. The literal hexes are last-resort only.
local function get_colors()
	local ok, theme = pcall(require, "config.theme")
	local palette = (ok and type(theme.current_theme) == "table") and theme.current_theme or {}

	local normal = get_hl("Normal")
	local bg = palette.bg or hex(normal.bg) or "#1e1e2e"
	local fg = hex(normal.fg) or palette.text or "#cdd6f4"

	-- A three-step ramp lifted off the background, rather than read out of
	-- CursorLine / Folded / StatusLine: those collapse INTO the background on
	-- the transparent themes here (black-metal paints Folded and StatusLine
	-- pure black, the same as Normal), which would flatten every slanted
	-- separator into invisibility. Only the bar's own ground defers to the
	-- theme, via the palette's second surface.
	local surface1 = blend(fg, bg, 0.1)
	local surface2 = (palette.bg_sec and palette.bg_sec ~= bg) and palette.bg_sec or blend(fg, bg, 0.18)
	local surface3 = blend(fg, bg, 0.28)

	local comment = first_hl("fg", "Comment") or palette.text_sec or "#6c7086"

	local error_fg = first_hl("fg", "DiagnosticError", "ErrorMsg", "Error") or "#f38ba8"
	local warn_fg = first_hl("fg", "DiagnosticWarn", "WarningMsg") or "#f9e2af"
	local info_fg = first_hl("fg", "DiagnosticInfo", "MoreMsg") or "#89dceb"
	local hint_fg = first_hl("fg", "DiagnosticHint", "DiagnosticInfo") or info_fg

	-- GitSigns first: DiffAdd and friends often carry a background wash and no
	-- foreground at all, which is what made these fall through to the defaults.
	local git_add = first_hl("fg", "GitSignsAdd", "DiffAdd", "Added") or "#a6e3a1"
	local git_change = first_hl("fg", "GitSignsChange", "DiffChange", "Changed") or warn_fg
	local git_delete = first_hl("fg", "GitSignsDelete", "DiffDelete", "Removed") or error_fg

	return {
		bg = bg,
		fg = fg,

		normal_fg1 = fg,
		normal_fg2 = comment,
		normal_fg3 = first_hl("fg", "Constant") or fg,
		normal_fg4 = first_hl("fg", "Identifier", "Special") or fg,

		-- Mode pill + the three raised surfaces the separators slant between.
		normal_bg1 = first_hl("fg", "Type", "Function") or "#89b4fa",
		normal_bg2 = surface1,
		normal_bg3 = surface3,
		normal_bg4 = first_hl("bg", "SignColumn") or bg,

		insert_fg = fg,
		insert_bg = first_hl("fg", "String") or "#a6e3a1",

		visual_fg = fg,
		visual_bg = first_hl("fg", "Keyword", "Statement") or "#cba6f7",

		replace_fg = fg,
		replace_bg = error_fg,

		command_fg = fg,
		command_bg = first_hl("fg", "Constant") or "#f9e2af",

		git_dirty = warn_fg,
		git_ahead = git_add,
		git_behind = git_delete,
		git_add = git_add,
		git_change = git_change,
		git_delete = git_delete,

		diagnostic_error = error_fg,
		diagnostic_warn = warn_fg,
		diagnostic_info = info_fg,
		diagnostic_hint = hint_fg,

		-- The bar's own ground, and the color behind the mode pill's slant.
		-- Both were hardcoded (#393836 and kanagawa's #1F1F28) and so stayed
		-- put through every theme switch.
		statusline_bg = surface2,
		dark_bg = bg,
	}
end

-- Initialize colors
local colors = get_colors()

local OS_UNAME = uv.os_uname()
local left_slant = ""
local right_slant = ""

local ModeNames = {
	["n"] = "NORMAL",
	["no"] = "O-PENDING",
	["nov"] = "O-PENDING",
	["noV"] = "O-PENDING",
	["no\22"] = "O-PENDING",
	["niI"] = "NORMAL",
	["niR"] = "NORMAL",
	["niV"] = "NORMAL",
	["nt"] = "NORMAL",
	["ntT"] = "NORMAL",
	["v"] = "VISUAL",
	["vs"] = "VISUAL",
	["V"] = "V-LINE",
	["Vs"] = "V-LINE",
	["\22"] = "V-BLOCK",
	["\22s"] = "V-BLOCK",
	["s"] = "SELECT",
	["S"] = "S-LINE",
	["\19"] = "S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["ix"] = "INSERT",
	["R"] = "REPLACE",
	["Rc"] = "REPLACE",
	["Rx"] = "REPLACE",
	["Rv"] = "V-REPLACE",
	["Rvc"] = "V-REPLACE",
	["Rvx"] = "V-REPLACE",
	["c"] = "COMMAND",
	["cv"] = "EX",
	["ce"] = "EX",
	["r"] = "REPLACE",
	["rm"] = "MORE",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local function build_mode_highlights(c)
	return {
		NORMAL = { fg = c.bg, bg = c.normal_bg1, bold = true },
		["O-PENDING"] = { fg = c.bg, bg = c.normal_bg1, bold = true },
		INSERT = { fg = c.bg, bg = c.insert_bg, bold = true },
		VISUAL = { fg = c.bg, bg = c.visual_bg, bold = true },
		["V-LINE"] = { fg = c.bg, bg = c.visual_bg, bold = true },
		["V-BLOCK"] = { fg = c.bg, bg = c.visual_bg, bold = true },
		SELECT = { fg = c.bg, bg = c.visual_bg, bold = true },
		["S-LINE"] = { fg = c.bg, bg = c.visual_bg, bold = true },
		["S-BLOCK"] = { fg = c.bg, bg = c.visual_bg, bold = true },
		REPLACE = { fg = c.bg, bg = c.replace_bg, bold = true },
		MORE = { fg = c.bg, bg = c.replace_bg, bold = true },
		["V-REPLACE"] = { fg = c.bg, bg = c.replace_bg, bold = true },
		COMMAND = { fg = c.bg, bg = c.command_bg, bold = true },
		EX = { fg = c.bg, bg = c.command_bg, bold = true },
		CONFIRM = { fg = c.bg, bg = c.command_bg, bold = true },
		SHELL = { fg = c.bg, bg = c.command_bg, bold = true },
		TERMINAL = { fg = c.bg, bg = c.command_bg, bold = true },
	}
end

local ModeHighlights = build_mode_highlights(colors)

local function GetModeName(mode)
	return ModeNames[mode] or "???"
end

local function GetModeHighlight(mode)
	local mode_name = GetModeName(mode)
	if type(mode_name) == "string" and ModeHighlights[mode_name] then
		return ModeHighlights[mode_name]
	else
		return ModeHighlights.NORMAL
	end
end

local function GetOsIcon()
	local uname = OS_UNAME.sysname
	if uname:match("Darwin") then
		return ""
	elseif uname:match("Windows") then
		return ""
	elseif uname:match("Linux") then
		if type(OS_UNAME.release) == "string" and OS_UNAME.release:find("arch") then
			return ""
		end
		return "󰣇"
	else
		return "󱚟"
	end
end

local Mode = {
	init = function(self)
		self.mode = vim.api.nvim_get_mode().mode
	end,
	hl = function(self)
		local mode_hl = GetModeHighlight(self.mode)
		return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
	end,
	update = { "ModeChanged" },

	-- os icon
	{
		provider = function(self)
			return " " .. GetOsIcon() .. " "
		end,
		hl = function(self)
			local mode_hl = GetModeHighlight(self.mode)
			return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
		end,
	},
	-- mode
	{
		provider = function(self)
			return GetModeName(self.mode) .. " "
		end,
		hl = function(self)
			local mode_hl = GetModeHighlight(self.mode)
			return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
		end,
	},
	-- separator
	{
		provider = right_slant,
		hl = function(self)
			local mode_hl = GetModeHighlight(self.mode)
			return { fg = mode_hl.bg, bg = colors.dark_bg }
		end,
	},
}

local FileName = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	hl = function()
		return { fg = colors.normal_fg2, bg = colors.normal_bg2 }
	end,

	-- file name
	{
		provider = " %t ",
	},
	{
		provider = function(self)
			if self.filename == "" then
				return ""
			end
			local modifiable = vim.api.nvim_get_option_value("modifiable", { buf = 0 })
			local readonly = vim.api.nvim_get_option_value("readonly", { buf = 0 })
			if not modifiable or readonly then
				return "[] "
			end
			local modified = vim.api.nvim_get_option_value("modified", { buf = 0 })
			if modified then
				return "[] "
			end
			return ""
		end,
		update = { "OptionSet", "BufWritePost", "BufEnter", "WinEnter" },
	},
	-- file size
	{
		provider = function(self)
			if self.filename == "" then
				return ""
			end
			local fstat = uv.fs_stat(self.filename)
			local fsize_value = tbl.tbl_get(fstat, "size")
			if type(fsize_value) ~= "number" or fsize_value <= 0 then
				return ""
			end
			local suffixes = { "B", "KB", "MB", "GB" }
			local i = 1
			while fsize_value > 1024 and i < #suffixes do
				fsize_value = fsize_value / 1024
				i = i + 1
			end

			local fsize_format = i == 1 and "[%d %s] " or "[%.1f %s] "
			return string.format(fsize_format, fsize_value, suffixes[i])
		end,
		update = { "OptionSet", "BufWritePost", "BufEnter", "WinEnter" },
	},
	{
		provider = right_slant,
		hl = function()
			return { fg = colors.normal_bg2, bg = colors.normal_bg3 }
		end,
	},
}

-- Git status cache
local git_status_cache = {
	branch = nil,
	added = 0,
	deleted = 0,
	ahead = 0,
	behind = 0,
}

-- Simple git status function
local function update_git_status_simple()
	local cwd = vim.fn.getcwd()

	-- Check if we're in a git repo
	local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
	if vim.v.shell_error ~= 0 then
		git_status_cache.branch = nil
		return
	end

	-- Get current branch
	local branch = vim.fn.system("git branch --show-current 2>/dev/null")
	if vim.v.shell_error == 0 and branch and branch ~= "" then
		git_status_cache.branch = branch:gsub("%s+", "")
	else
		git_status_cache.branch = nil
		return
	end

	-- Get diff stats
	local diff_stats = vim.fn.system("git diff --shortstat 2>/dev/null")
	if vim.v.shell_error == 0 and diff_stats and diff_stats ~= "" then
		local added = diff_stats:match("(%d+) insertion")
		local deleted = diff_stats:match("(%d+) deletion")
		git_status_cache.added = added and tonumber(added) or 0
		git_status_cache.deleted = deleted and tonumber(deleted) or 0
	else
		git_status_cache.added = 0
		git_status_cache.deleted = 0
	end

	-- Get ahead/behind
	local status = vim.fn.system("git status -sb 2>/dev/null | head -1")
	if vim.v.shell_error == 0 and status and status ~= "" then
		local ahead = status:match("%[ahead (%d+)%]")
		local behind = status:match("%[behind (%d+)%]")
		git_status_cache.ahead = ahead and tonumber(ahead) or 0
		git_status_cache.behind = behind and tonumber(behind) or 0
	else
		git_status_cache.ahead = 0
		git_status_cache.behind = 0
	end

	-- Trigger update
	vim.api.nvim_exec_autocmds("User", { pattern = "HeirlineGitBranchUpdated" })
end

-- GitBranch component (simplified)
local GitBranch = {
	condition = function()
		return git_status_cache.branch ~= nil
	end,

	init = function(self)
		self.branch = git_status_cache.branch
		self.ahead = git_status_cache.ahead
		self.behind = git_status_cache.behind
		self.changed = (git_status_cache.added > 0) or (git_status_cache.deleted > 0)
	end,

	hl = function()
		return { fg = colors.normal_fg3, bg = colors.normal_bg3 }
	end,

	{
		provider = function(self)
			return "  " .. self.branch .. " "
		end,
	},
	{
		condition = function(self)
			return self.changed
		end,
		provider = "* ",
		hl = function()
			return { fg = colors.git_dirty, bg = colors.normal_bg3 }
		end,
	},
	{
		condition = function(self)
			return self.ahead and self.ahead > 0
		end,
		provider = function(self)
			return string.format("↑[%d] ", self.ahead)
		end,
		hl = function()
			return { fg = colors.git_ahead, bg = colors.normal_bg3 }
		end,
	},
	{
		condition = function(self)
			return self.behind and self.behind > 0
		end,
		provider = function(self)
			return string.format("↓[%d] ", self.behind)
		end,
		hl = function()
			return { fg = colors.git_behind, bg = colors.normal_bg3 }
		end,
	},
	{
		provider = right_slant,
		hl = function()
			return { fg = colors.normal_bg3, bg = colors.statusline_bg }
		end,
	},
}

-- GitDiff component (simplified)
local GitDiff = {
	condition = function()
		return git_status_cache.branch ~= nil and (git_status_cache.added > 0 or git_status_cache.deleted > 0)
	end,

	init = function(self)
		self.added = git_status_cache.added
		self.deleted = git_status_cache.deleted
	end,

	hl = function()
		return { fg = colors.normal_fg4, bg = colors.statusline_bg }
	end,

	{
		condition = function(self)
			return self.added and self.added > 0
		end,
		provider = function(self)
			return string.format(" 󰜅%d", self.added)
		end,
		hl = function()
			return { fg = colors.git_add, bg = colors.statusline_bg }
		end,
	},
	{
		condition = function(self)
			return self.deleted and self.deleted > 0
		end,
		provider = function(self)
			return string.format(" 󱘹%d", self.deleted)
		end,
		hl = function()
			return { fg = colors.git_delete, bg = colors.statusline_bg }
		end,
	},
}

-- Setup git updates
local function setup_git_updates()
	-- Initial update
	update_git_status_simple()

	-- Update on buffer events
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FocusGained" }, {
		callback = function()
			vim.schedule(update_git_status_simple)
		end,
	})

	-- Update every 30 seconds while in a git repo
	vim.defer_fn(function()
		vim.schedule(function()
			if git_status_cache.branch ~= nil then
				update_git_status_simple()
			end
		end)
	end, 30000)
end

local LSPActive = {
	condition = conditions.lsp_attached,
	update = { "LspAttach", "LspDetach" },
	{
		provider = left_slant,
		hl = function()
			return { fg = colors.normal_bg3, bg = colors.statusline_bg }
		end,
	},

	{
		provider = function()
			local names = {}
			for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
				table.insert(names, server.name)
			end
			return " 󰘦 " .. table.concat(names, " ") .. " "
		end,
		hl = function()
			return { fg = colors.normal_fg1, bg = colors.normal_bg3, bold = true }
		end,
	},
	{
		provider = right_slant,
		hl = function()
			return { fg = colors.normal_bg3, bg = colors.statusline_bg }
		end,
	},
}

local SearchCount = {
	hl = function()
		return { fg = colors.normal_fg1, bg = colors.normal_bg2 }
	end,
	provider = function()
		if vim.v.hlsearch == 0 then
			return ""
		end
		local ok, result = pcall(vim.fn.searchcount, { maxcount = 100, timeout = 500 })
		if not ok or tbl.tbl_empty(result) then
			return ""
		end
		local denominator = math.min(result.total, result.maxcount)
		return string.format("[%d/%d] ", result.current, denominator)
	end,
	update = {
		"SearchWrapped",
		"CmdlineEnter",
		"CmdlineLeave",
	},
}

local DiagnosticSeverity = { "ERROR", "WARN", "INFO", "HINT" }

local DiagnosticSigns = {
	constants.diagnostic.signs.error,
	constants.diagnostic.signs.warn,
	constants.diagnostic.signs.info,
	constants.diagnostic.signs.hint,
}

local function GetDiagnosticText(level)
	local value = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[DiagnosticSeverity[level]] })
	if value <= 0 then
		return ""
	else
		return string.format("%s %d ", DiagnosticSigns[level]:gsub("%s+", ""), value)
	end
end

local DiagnosticColors = {
	colors.diagnostic_error,
	colors.diagnostic_warn,
	colors.diagnostic_info,
	colors.diagnostic_hint,
}

local function GetDiagnosticHighlight(level)
	return { fg = DiagnosticColors[level], bg = colors.statusline_bg }
end

local Diagnostic = {
	hl = function()
		return { fg = colors.normal_fg1, bg = colors.normal_bg2 }
	end,
	update = { "DiagnosticChanged" },

	{
		provider = function()
			return GetDiagnosticText(1)
		end,
		hl = function()
			return GetDiagnosticHighlight(1)
		end,
	},
	{
		provider = function()
			return GetDiagnosticText(2)
		end,
		hl = function()
			return GetDiagnosticHighlight(2)
		end,
	},
	{
		provider = function()
			return GetDiagnosticText(3)
		end,
		hl = function()
			return GetDiagnosticHighlight(3)
		end,
	},
	{
		provider = function()
			return GetDiagnosticText(4)
		end,
		hl = function()
			return GetDiagnosticHighlight(4)
		end,
	},
}

local FileEncodingIcons = {
	["utf-8"] = "󰉿",
	["utf-16"] = "󰊀",
	["utf-32"] = "󰊁",
	["utf-8mb4"] = "󰊂",
	["utf-16le"] = "󰊃",
	["utf-16be"] = "󰊄",
}

local FileEncoding = {
	hl = function()
		return { fg = colors.normal_fg3, bg = colors.normal_bg3 }
	end,
	{
		provider = left_slant,
		hl = function()
			return { fg = colors.normal_bg3, bg = colors.statusline_bg }
		end,
	},
	{
		provider = function()
			local text = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
			if text == "" then
				return ""
			end

			local icon = FileEncodingIcons[text]
			if not icon or icon == "" then
				return " " .. text .. " "
			else
				return " " .. icon .. " " .. text .. " "
			end
		end,
		update = {
			"BufEnter",
		},
	},
}

local FileFormatIcons = {
	unix = "󰌽 LF", -- e712
	dos = " CRLF", -- e70f
	mac = " CR", -- e711
}

local FileFormat = {
	hl = function()
		return { fg = colors.normal_fg3, bg = colors.normal_bg3 }
	end,
	provider = function(self)
		local text = vim.bo.fileformat
		if text == "" then
			return ""
		end

		local icon = FileFormatIcons[text]
		if not icon or icon == "" then
			return " " .. text .. " "
		else
			return " " .. icon .. " "
		end
	end,
	update = {
		"BufEnter",
	},
}

local FileType = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0) or ""
		self.filename_ext = vim.fn.fnamemodify(self.filename, ":e") or ""
		self.devicons = require("nvim-web-devicons")
	end,
	hl = function()
		return { fg = colors.normal_fg2, bg = colors.normal_bg2 }
	end,

	{
		provider = left_slant,
		hl = function()
			return { fg = colors.normal_bg2, bg = colors.normal_bg3 }
		end,
	},
	{
		provider = function(self)
			if self.filename_ext == "" then
				return ""
			end
			local text, _ = self.devicons.get_icon_color(self.filename, self.filename_ext, { default = true })
			if text and text ~= "" then
				return " " .. text .. " "
			else
				return "  "
			end
		end,
		hl = function(self)
			local _, color = self.devicons.get_icon_color(self.filename, self.filename_ext, { default = true })
			if color and color ~= "" then
				return { fg = color, bg = colors.normal_bg2 }
			else
				return { fg = colors.normal_fg2, bg = colors.normal_bg2 }
			end
		end,
		update = { "BufEnter" },
	},
	{
		provider = function(self)
			if self.filename == "" then
				return ""
			end
			local ft = vim.filetype.match({ filename = self.filename }) or ""
			if ft == "" then
				return ""
			end
			return ft .. " "
		end,
		update = { "BufEnter" },
	},
}

local Location = {
	init = function(self)
		self.mode = vim.fn.mode(1)
	end,
	hl = function(self)
		local mode_hl = GetModeHighlight(self.mode)
		return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
	end,

	{
		provider = left_slant,
		hl = function(self)
			local mode_hl = GetModeHighlight(self.mode)
			return { fg = mode_hl.bg, bg = colors.normal_bg2, bold = true }
		end,
	},
	{
		provider = "  %2l:%-2c",
	},
}

local CursorHex = {
	init = function(self)
		self.mode = vim.api.nvim_get_mode().mode
	end,
	hl = function(self)
		local mode_hl = GetModeHighlight(self.mode)
		return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
	end,
	provider = " 0x%04B",
}

local Progress = {
	init = function(self)
		self.mode = vim.api.nvim_get_mode().mode
	end,
	hl = function(self)
		local mode_hl = GetModeHighlight(self.mode)
		return { fg = mode_hl.fg, bg = mode_hl.bg, bold = true }
	end,
	provider = "  %P ",
}

-- The %= fillers between segments. Painted with the bar's own ground so the
-- gaps match whichever theme is active.
local Align = {
	provider = "%=",
	hl = function()
		return { fg = colors.bg, bg = colors.statusline_bg }
	end,
}

-- Main StatusLine
local StatusLine = {
	fallthrough = false,
	{
		condition = function()
			local ft = vim.bo.filetype or ""
			return ft:match("^dapui") or ft == "dap-repl" or ft:match("^qf") or ft == "kulala_ui"
		end,
		Align,
		FileEncoding,
		Location,
		CursorHex,
		Progress,
	},
	{
		Mode,
		-- FileName, -- Commented out as per your structure
		GitBranch,
		GitDiff,
		Align,
		LSPActive,
		Align,
		SearchCount,
		Diagnostic,
		FileEncoding,
		FileFormat,
		FileType,
		Location,
		CursorHex,
		Progress,
	},
}

-- Rebuild the palette from the newly active colorscheme and repaint.
--
-- `colors` is a module-level local that every hl callback closes over, so
-- rebinding it here is what reaches the whole statusline — which is why the
-- components below build their highlights in functions rather than as literal
-- tables: a table would have captured the hexes once, at load time.
local function update_colors()
	colors = get_colors()

	-- Drop heirline's cache of generated StatusLine* groups and reload its color
	-- aliases. Required, not just tidy: a colorscheme that runs `hi clear` — which
	-- is how black-metal applies itself — deletes those groups behind heirline's
	-- back, and the cache would otherwise stop it from ever recreating them,
	-- leaving the bar rendering against empty highlights.
	pcall(function()
		require("heirline.utils").on_colorscheme(colors)
	end)

	-- Update ModeHighlights with new colors
	ModeHighlights = build_mode_highlights(colors)

	-- Update DiagnosticColors
	DiagnosticColors = {
		colors.diagnostic_error,
		colors.diagnostic_warn,
		colors.diagnostic_info,
		colors.diagnostic_hint,
	}

	-- Force redraw of statusline
	vim.cmd("redrawstatus")
end

-- Setup Heirline
require("heirline").setup({
	statusline = StatusLine,
	opts = {
		colors = colors,
	},
})

-- Rebuild the palette whenever the colorscheme changes. config.theme_switcher
-- rebuilds theme.current_theme from its own ColorSchemePre hook, so by the time
-- this runs get_colors() reads the incoming theme, not the outgoing one.
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("HeirlineThemeIntegration", { clear = true }),
	callback = function()
		vim.schedule(update_colors)
	end,
})

-- Setup git integration
setup_git_updates()

-- Also update colors when Neovim starts
vim.schedule(function()
	update_colors()
end)

-- Manual refresh function for git status
