-- ══════════════════════════════════════════════════════════════════════
-- Theme registry + persisted state
--
-- One entry per INSTALLED colorscheme, in picker order. Each entry names a
-- module under lua/themes/ (see the contract at the top of any of those files)
-- that owns both the consumer palette and the colorscheme plugin's lazy spec.
-- `colorscheme` is the name handed to :colorscheme and `plugin` the lazy spec
-- name, so config.theme.switcher can load it BEFORE building the palette —
-- kanso and black-metal read their colors straight off the plugin.
--
-- Nothing here requires a theme module at load time: palettes are built on
-- demand by M.build() and the plugin specs are collected by
-- plugins/ui/colorscheme.lua. Theme modules never require this file back.
--
-- Switching, persistence and the picker live in config/theme/switcher.lua.
-- ══════════════════════════════════════════════════════════════════════
local M = {}

-- Modules under lua/themes/ that plugins/ui/colorscheme.lua imports specs from.
M.modules = { "koda", "material", "evergarden", "kanso", "rose_pine", "kanagawa", "jellybeans", "black_metal" }

local function palette_module(name)
	return require("themes." .. name)
end

-- For the two themes whose light/dark answer depends on runtime state.
local function dynamic_background(name)
	return function()
		return palette_module(name).background()
	end
end

M.themes = {
	{
		key = "koda",
		label = "Koda",
		plugin = "koda.nvim",
		colorscheme = "koda-dark",
		module = "koda",
		background = "dark",
	},
	{
		key = "koda-moss",
		label = "Koda Moss",
		plugin = "koda.nvim",
		colorscheme = "koda-moss",
		module = "koda",
		variant = "moss",
		background = "dark",
	},
	{
		key = "koda-glade",
		label = "Koda Glade",
		plugin = "koda.nvim",
		colorscheme = "koda-glade",
		module = "koda",
		variant = "glade",
		background = "light", -- glade is koda's light palette
	},

	{
		key = "material",
		label = "Material",
		plugin = "material.nvim",
		colorscheme = "material",
		module = "material",
		background = dynamic_background("material"),
	},
	{
		key = "evergarden",
		label = "Evergarden",
		plugin = "evergarden",
		colorscheme = "evergarden",
		module = "evergarden",
		background = dynamic_background("evergarden"),
	},
	{
		key = "kanso-zen",
		label = "Kanso Zen",
		plugin = "kanso.nvim",
		colorscheme = "kanso-zen",
		alias = "kanso", -- what colors/kanso-zen reports as vim.g.colors_name
		module = "kanso",
		variant = "zen",
		background = "dark",
	},
	{
		key = "kanso-ink",
		label = "Kanso Ink",
		plugin = "kanso.nvim",
		colorscheme = "kanso-ink",
		module = "kanso",
		variant = "ink",
		background = "dark",
	},
	{
		key = "kanso-mist",
		label = "Kanso Mist",
		plugin = "kanso.nvim",
		colorscheme = "kanso-mist",
		module = "kanso",
		variant = "mist",
		background = "dark",
	},
	{
		key = "kanso-pearl",
		label = "Kanso Pearl",
		plugin = "kanso.nvim",
		colorscheme = "kanso-pearl",
		module = "kanso",
		variant = "pearl",
		background = "light",
	},
	{
		key = "rose-pine",
		label = "Rose Pine",
		plugin = "rose-pine",
		colorscheme = "rose-pine",
		module = "rose_pine",
		variant = "main",
		background = "dark",
	},
	{
		key = "rose-pine-moon",
		label = "Rose Pine Moon",
		plugin = "rose-pine",
		colorscheme = "rose-pine-moon",
		module = "rose_pine",
		variant = "moon",
		background = "dark",
	},
	{
		key = "rose-pine-dawn",
		label = "Rose Pine Dawn",
		plugin = "rose-pine",
		colorscheme = "rose-pine-dawn",
		module = "rose_pine",
		variant = "dawn",
		background = "light",
	},
	{
		key = "kanagawa",
		label = "Kanagawa",
		plugin = "kanagawa.nvim",
		colorscheme = "kanagawa-wave",
		alias = "kanagawa",
		module = "kanagawa",
		background = "dark",
	},
	{
		key = "jellybeans",
		label = "Jellybeans",
		plugin = "jellybeans.nvim",
		colorscheme = "jellybeans",
		module = "jellybeans",
		background = "dark",
	},
}

-- Black Metal's sixteen bands, in registry order.
local BLACK_METAL_BANDS = {
	"bathory",
	"burzum",
	"dark-funeral",
	"darkthrone",
	"emperor",
	"gorgoroth",
	"immortal",
	"impaled-nazarene",
	"khold",
	"marduk",
	"mayhem",
	"nile",
	"taake",
	"thyrfing",
	"venom",
	"windir",
}

-- Black Metal's sixteen bands. Generated rather than written out: the entries
-- differ only in the band name, and the palette builder takes it as its
-- `variant` (M.build passes entry.variant as the sole argument). `colorscheme`
-- is the bare band name — the plugin registers `colors/<band>.lua`, there is no
-- `black-metal-` prefix — and no `alias` is needed because its load() reports
-- that same name as vim.g.colors_name.
for _, band in ipairs(BLACK_METAL_BANDS) do
	table.insert(M.themes, {
		key = "black-metal-" .. band,
		label = "Black Metal · " .. (band:gsub("(%a)([%w]*)", function(first, rest)
			return first:upper() .. rest
		end):gsub("%-", " ")),
		plugin = "black-metal-theme-neovim",
		colorscheme = band,
		module = "black_metal",
		variant = band,
		background = "dark", -- light variants are disabled by `trve` in the spec
	})
end

-- Fallback whenever nothing is persisted, the saved name is unknown, or a

-- Fallback whenever nothing is persisted, the saved name is unknown, or a
-- palette fails to build. koda is the only builder with no external dependency.
M.DEFAULT_THEME = "koda"

-- Where the chosen theme is remembered across restarts. Written only on an
-- explicit switch (:Theme / the picker's <CR>), never from the ColorScheme
-- autocmds — the picker's live preview fires one :colorscheme per cursor move.
M.state_file = vim.fn.stdpath("state") .. "/theme.json"

function M.by_key(key)
	for _, entry in ipairs(M.themes) do
		if entry.key == key then
			return entry
		end
	end
end

-- Resolve a :colorscheme name to its registry entry. Also matches `alias`: two
-- of these schemes set vim.g.colors_name to their family name rather than the
-- variant they were loaded as ("kanso-zen" reports "kanso"), and fzf-lua's
-- picker restores THAT string when you abort a live preview — so without the
-- alias an <Esc> would leave current_theme pointing at the previewed palette.
function M.by_colorscheme(name)
	for _, entry in ipairs(M.themes) do
		if entry.colorscheme == name or entry.alias == name then
			return entry
		end
	end
end

-- Read the persisted choice. Returns nil — never throws — on a missing,
-- unreadable, malformed or unrecognized file, so a corrupt state file costs a
-- fallback to DEFAULT_THEME rather than a broken startup.
function M.read_saved()
	local file = io.open(M.state_file, "r")
	if not file then
		return nil
	end
	local contents = file:read("*a")
	file:close()

	local ok, decoded = pcall(vim.json.decode, contents)
	if not ok or type(decoded) ~= "table" then
		return nil
	end
	return M.by_key(decoded.theme) and decoded.theme or nil
end

-- koda's palette: the only one with no plugin dependency, so it can always be
-- built. Consumers that need a complete palette before a theme is applied
-- (blink's menu colors at setup) read this.
function M.fallback()
	return palette_module("koda").palette()
end

-- Build a palette defensively. kanso and black-metal return {} when their
-- plugin isn't loaded yet, and this module is first required during lazy's
-- spec import, before anything is loaded — so a bare call could hand back a
-- table with no `fzf` key that every consumer then indexes into. Callers get
-- koda's palette instead of a crash; config.theme.switcher rebuilds properly
-- from its ColorSchemePre hook once the plugin is in memory.
function M.build(key)
	local entry = M.by_key(key)
	if entry then
		local ok, palette = pcall(function()
			return palette_module(entry.module).palette(entry.variant)
		end)
		if ok and type(palette) == "table" and palette.fzf then
			return palette
		end
	end
	return M.fallback()
end

-- Active theme. Persisted by config.theme.switcher; edit theme.json or use
-- :Theme / <leader>uc rather than hardcoding a builder here.
M.active = M.read_saved() or M.DEFAULT_THEME
M.current_theme = M.build(M.active)

return M
