local conditions = require("heirline.conditions")
local uv = vim.uv or vim.loop
local tbl = {}
local statusline_bg = "#393836"

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
			error = " ",
			warn = " ",
			info = " ",
			hint = " ",
		},
	},
}

local function get_colors()
	local normal = vim.api.nvim_get_hl_by_name("Normal", true)
	local comment = vim.api.nvim_get_hl_by_name("Comment", true)
	local string_hl = vim.api.nvim_get_hl_by_name("String", true)
	local function_hl = vim.api.nvim_get_hl_by_name("Function", true)
	local type_hl = vim.api.nvim_get_hl_by_name("Type", true)
	local constant = vim.api.nvim_get_hl_by_name("Constant", true)
	local keyword = vim.api.nvim_get_hl_by_name("Keyword", true)
	local error_hl = vim.api.nvim_get_hl_by_name("Error", true)
	local warning = vim.api.nvim_get_hl_by_name("WarningMsg", true)
	local info = vim.api.nvim_get_hl_by_name("MoreMsg", true)
		or vim.api.nvim_get_hl_by_name("Question", true)
		or vim.api.nvim_get_hl_by_name("Directory", true)
	local identifier = vim.api.nvim_get_hl_by_name("Identifier", true)
	local statement = vim.api.nvim_get_hl_by_name("Statement", true)
	local visual = vim.api.nvim_get_hl_by_name("Visual", true)
	local cursorline = vim.api.nvim_get_hl_by_name("CursorLine", true)
	local cursorlinenr = vim.api.nvim_get_hl_by_name("CursorLineNr", true)
	local special = vim.api.nvim_get_hl_by_name("Special", true)
	local preproc = vim.api.nvim_get_hl_by_name("PreProc", true)
	local signcolumn = vim.api.nvim_get_hl_by_name("SignColumn", true)
	local folded = vim.api.nvim_get_hl_by_name("Folded", true)
	local diffadd = vim.api.nvim_get_hl_by_name("DiffAdd", true)
	local diffchange = vim.api.nvim_get_hl_by_name("DiffChange", true)
	local diffdelete = vim.api.nvim_get_hl_by_name("DiffDelete", true)

	-- Helper function to convert color
	local function hex_color(color_num)
		if not color_num then
			return nil
		end
		return string.format("#%06x", color_num)
	end

	-- Return colors based on highlight groups
	return {
		-- Basic colors
		bg = hex_color(normal.background) or "#1e1e2e",
		fg = hex_color(normal.foreground) or "#cdd6f4",

		-- Mode colors (for text)
		normal_fg1 = hex_color(normal.foreground) or "#cdd6f4",
		normal_fg2 = hex_color(comment.foreground) or "#6c7086",
		normal_fg3 = hex_color(constant.foreground) or "#f9e2af",
		normal_fg4 = hex_color(identifier.foreground) or "#89dceb",

		-- Mode background colors
		normal_bg1 = hex_color(type_hl.foreground) or hex_color(function_hl.foreground) or "#89b4fa",
		normal_bg2 = hex_color(cursorline.background) or hex_color(signcolumn.background) or "#2d2d3e",
		normal_bg3 = hex_color(folded.background) or "#3a3a4e",
		normal_bg4 = hex_color(signcolumn.background) or "#090e13",

		-- Insert mode
		insert_fg = hex_color(normal.foreground) or "#cdd6f4",
		insert_bg = hex_color(string_hl.foreground) or "#a6e3a1",

		-- Visual mode
		visual_fg = hex_color(normal.foreground) or "#cdd6f4",
		visual_bg = hex_color(keyword.foreground) or "#cba6f7",

		-- Replace mode
		replace_fg = hex_color(normal.foreground) or "#cdd6f4",
		replace_bg = hex_color(error_hl.foreground) or "#f38ba8",

		-- Command mode
		command_fg = hex_color(normal.foreground) or "#cdd6f4",
		command_bg = hex_color(constant.foreground) or "#f9e2af",

		-- Git colors
		git_dirty = hex_color(warning.foreground) or "#f9e2af",
		git_ahead = hex_color(diffadd.foreground) or "#a6e3a1",
		git_behind = hex_color(diffdelete.foreground) or "#f38ba8",
		git_add = hex_color(diffadd.foreground) or "#a6e3a1",
		git_change = hex_color(diffchange.foreground) or "#f9e2af",
		git_delete = hex_color(diffdelete.foreground) or "#f38ba8",

		-- Diagnostic colors
		diagnostic_error = hex_color(error_hl.foreground) or "#f38ba8",
		diagnostic_warn = hex_color(warning.foreground) or "#f9e2af",
		diagnostic_info = hex_color(info.foreground) or "#89dceb",

		-- Background color constant
		dark_bg = "#090e13",
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

local ModeHighlights = {
	NORMAL = { fg = colors.normal_fg1, bg = "#3e404a", bold = true },
	["O-PENDING"] = { fg = colors.normal_fg1, bg = colors.normal_bg1, bold = true },
	INSERT = { fg = colors.insert_fg, bg = colors.insert_bg, bold = true },
	VISUAL = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
	["V-LINE"] = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
	["V-BLOCK"] = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
	SELECT = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
	["S-LINE"] = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
	["S-BLOCK"] = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
	REPLACE = { fg = colors.replace_fg, bg = colors.replace_bg, bold = true },
	MORE = { fg = colors.replace_fg, bg = colors.replace_bg, bold = true },
	["V-REPLACE"] = { fg = colors.replace_fg, bg = colors.replace_bg, bold = true },
	COMMAND = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
	EX = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
	CONFIRM = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
	SHELL = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
	TERMINAL = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
}

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
	hl = { fg = colors.normal_fg2, bg = colors.normal_bg2 },

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
		hl = { fg = colors.normal_bg2, bg = colors.normal_bg3 },
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

	hl = { fg = colors.normal_fg3, bg = colors.dark_bg },

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
		hl = { fg = colors.git_dirty, bg = colors.dark_bg },
	},
	{
		condition = function(self)
			return self.ahead and self.ahead > 0
		end,
		provider = function(self)
			return string.format("↑[%d] ", self.ahead)
		end,
		hl = { fg = colors.git_ahead, bg = colors.dark_bg },
	},
	{
		condition = function(self)
			return self.behind and self.behind > 0
		end,
		provider = function(self)
			return string.format("↓[%d] ", self.behind)
		end,
		hl = { fg = colors.git_behind, bg = colors.dark_bg },
	},
	{
		provider = right_slant,
		hl = { fg = colors.dark_bg, bg = statusline_bg },
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

	hl = { fg = colors.normal_fg4, bg = statusline_bg },

	{
		condition = function(self)
			return self.added and self.added > 0
		end,
		provider = function(self)
			return string.format(" 󰜅%d", self.added)
		end,
		hl = { fg = colors.git_add, bg = statusline_bg },
	},
	{
		condition = function(self)
			return self.deleted and self.deleted > 0
		end,
		provider = function(self)
			return string.format(" 󱘹%d", self.deleted)
		end,
		hl = { fg = "#F52700", bg = statusline_bg },
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
		hl = { fg = colors.dark_bg, bg = statusline_bg },
	},

	{
		provider = function()
			local names = {}
			for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
				table.insert(names, server.name)
			end
			return " 󰘦 " .. table.concat(names, " ") .. " "
		end,
		hl = { fg = colors.normal_fg4, bg = colors.dark_bg, bold = true },
	},
	{
		provider = right_slant,
		hl = { fg = colors.dark_bg, bg = statusline_bg },
	},
}

local SearchCount = {
	hl = { fg = colors.normal_fg1, bg = colors.normal_bg2 },
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
	colors.diagnostic_info, -- Using info color for hints as fallback
}

local function GetDiagnosticHighlight(level)
	return { fg = DiagnosticColors[level], bg = statusline_bg }
end

local Diagnostic = {
	hl = { fg = colors.normal_fg1, bg = colors.normal_bg2 },
	update = { "DiagnosticChanged" },

	{
		provider = function()
			return GetDiagnosticText(1)
		end,
		hl = GetDiagnosticHighlight(1),
	},
	{
		provider = function()
			return GetDiagnosticText(2)
		end,
		hl = GetDiagnosticHighlight(2),
	},
	{
		provider = function()
			return GetDiagnosticText(3)
		end,
		hl = GetDiagnosticHighlight(3),
	},
	{
		provider = function()
			return GetDiagnosticText(4)
		end,
		hl = GetDiagnosticHighlight(4),
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
	hl = { fg = colors.normal_fg3, bg = colors.normal_bg3 },
	{
		provider = left_slant,
		hl = { fg = colors.normal_bg3, bg = statusline_bg },
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
	hl = { fg = colors.normal_fg3, bg = colors.normal_bg3 },
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
	hl = { fg = colors.normal_fg2, bg = colors.normal_bg2 },

	{
		provider = left_slant,
		hl = { fg = colors.normal_bg2, bg = colors.normal_bg3 },
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

-- Main StatusLine
local StatusLine = {
	fallthrough = false,
	{
		condition = function()
			local ft = vim.bo.filetype or ""
			return ft:match("^dapui") or ft == "dap-repl" or ft:match("^qf")
		end,
		FileEncoding,
	},
	{
		Mode,
		-- FileName, -- Commented out as per your structure
		GitBranch,
		GitDiff,
		{ provider = "%=", hl = { fg = "#000000", bg = "#393836" } },
		LSPActive,
		{ provider = "%=", hl = { fg = "#000000", bg = "#393836" } },
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

-- Function to update colors and redraw
local function update_colors()
	colors = get_colors()

	-- Update ModeHighlights with new colors
	ModeHighlights = {
		NORMAL = { fg = colors.normal_fg1, bg = "#3e404a", bold = true },
		["O-PENDING"] = { fg = colors.normal_fg1, bg = colors.normal_bg1, bold = true },
		INSERT = { fg = colors.insert_fg, bg = colors.insert_bg, bold = true },
		VISUAL = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
		["V-LINE"] = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
		["V-BLOCK"] = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
		SELECT = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
		["S-LINE"] = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
		["S-BLOCK"] = { fg = colors.visual_fg, bg = colors.visual_bg, bold = true },
		REPLACE = { fg = colors.replace_fg, bg = colors.replace_bg, bold = true },
		MORE = { fg = colors.replace_fg, bg = colors.replace_bg, bold = true },
		["V-REPLACE"] = { fg = colors.replace_fg, bg = colors.replace_bg, bold = true },
		COMMAND = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
		EX = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
		CONFIRM = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
		SHELL = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
		TERMINAL = { fg = colors.command_fg, bg = colors.command_bg, bold = true },
	}

	-- Update DiagnosticColors
	DiagnosticColors = {
		colors.diagnostic_error,
		colors.diagnostic_warn,
		colors.diagnostic_info,
		colors.diagnostic_info,
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

-- Update colors on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.schedule(function()
			update_colors()
		end)
	end,
})

-- Setup git integration
setup_git_updates()

-- Also update colors when Neovim starts
vim.schedule(function()
	update_colors()
end)

-- Manual refresh function for git status

-- Optional: Debug functions
_G.print_heirline_colors = function()
	print("Current heirline colors:")
	print(vim.inspect(colors))
end

_G.check_git_status = function()
	print("Git status cache:")
	print(vim.inspect(git_status_cache))
end

_G.check_highlight_groups = function()
	local groups = {
		"Normal",
		"Comment",
		"String",
		"Function",
		"Type",
		"Constant",
		"Keyword",
		"Error",
		"WarningMsg",
		"MoreMsg",
		"Identifier",
		"Statement",
		"Visual",
		"CursorLineNr",
		"Special",
		"PreProc",
		"Directory",
		"Question",
		"SignColumn",
		"CursorLine",
		"Folded",
		"DiffAdd",
		"DiffChange",
		"DiffDelete",
	}

	print("Checking highlight groups:")
	for _, group in ipairs(groups) do
		local success, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
		if success then
			local fg = hl.foreground and string.format("#%06x", hl.foreground) or "None"
			local bg = hl.background and string.format("#%06x", hl.background) or "None"
			print(string.format("%-15s: fg=%s, bg=%s", group, fg, bg))
		else
			print(string.format("%-15s: Not found", group))
		end
	end
end
