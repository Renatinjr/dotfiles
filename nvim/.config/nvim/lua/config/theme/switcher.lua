-- ══════════════════════════════════════════════════════════════════════
-- Theme switcher
--
-- Switching themes in this config means moving two things at once: the
-- colorscheme itself (highlight groups, from the plugin specs in
-- lua/themes/*.lua) and `config.theme.current_theme` (the transcribed
-- palette that bufferline, nvim-tree, alpha, incline, blink, fzf-lua, ibl and
-- notify all read). Let them drift and the chrome no longer matches the buffer.
--
-- The whole module hangs off two autocmds:
--
--   ColorSchemePre  repoints current_theme at the INCOMING scheme, before it
--                   loads, so the ColorScheme handlers in explorer.lua /
--                   completion.lua / incline.lua see the new palette when they run.
--   ColorScheme     re-emits the consumers that bake their colors in at
--                   setup() and so can't follow the event themselves.
--
-- Because the work hangs off the events rather off this module's own entry
-- points, ANY `:colorscheme x` is correct — including the bare vim.cmd() that
-- fzf-lua's live preview fires on every cursor move, which is what makes
-- M.pick() below a thin wrapper instead of a reimplemented picker.
-- ══════════════════════════════════════════════════════════════════════
local theme = require("config.theme")
local utils = require("utils")

local M = {}

local function background_for(entry)
	local bg = entry.background
	if type(bg) == "function" then
		bg = bg()
	end
	return bg == "light" and "light" or "dark"
end

-- Pull a lazy-loaded colorscheme plugin into memory. Must happen before the
-- palette is built: kanso() reads its colors straight off `kanso.colors` and
-- returns an empty table when the plugin isn't there yet.
local function load_plugin(entry)
	pcall(function()
		require("lazy").load({ plugins = { entry.plugin } })
	end)
end

-- bufferline's keys are snake_case and its highlight groups are CamelCase:
-- buffer_selected -> BufferLineBufferSelected.
local function bufferline_group(key)
	return "BufferLine"
		.. key:gsub("(%a)([%w]*)", function(first, rest)
			return first:upper() .. rest
		end):gsub("_", "")
end

-- ══════════════════════════════════════════════════════════════════════
-- Re-emit the setup()-time consumers
--
-- These four read the palette once, when their plugin is configured, and keep
-- no ColorScheme hook of their own — so a switch leaves them painted in the
-- previous theme until something re-applies them. Generalizes the bufferline
-- loop that :MaterialStyle used to carry inline.
-- ══════════════════════════════════════════════════════════════════════
function M.refresh()
	local current = theme.current_theme
	if type(current) ~= "table" then
		return
	end

	-- bufferline: highlights are passed into setup() and never revisited.
	for key, hl in pairs(current.bufferline or {}) do
		pcall(vim.api.nvim_set_hl, 0, bufferline_group(key), hl)
	end

	-- alpha: the dashboard sets these three groups itself at setup(). Foreground
	-- only, matching alpha.lua — the transparent themes (koda, rose-pine, kanso)
	-- would otherwise get a solid block painted behind the dashboard.
	if type(current.alpha) == "table" then
		pcall(vim.api.nvim_set_hl, 0, "AlphaHeader", { fg = current.alpha.heading })
		pcall(vim.api.nvim_set_hl, 0, "AlphaButton", { fg = current.alpha.button })
		pcall(vim.api.nvim_set_hl, 0, "AlphaFooter", { fg = current.alpha.shortcut })
	end

	-- fzf-lua: setup_colors() defines the FzfLua* groups as a side effect and
	-- returns only group NAMES, which never go stale — so re-calling it is the
	-- entire fix. Matters most for rose-pine, the one spec that doesn't
	-- redefine those groups in its own highlight overrides.
	if type(current.fzf) == "table" and type(current.fzf.setup_colors) == "function" then
		pcall(current.fzf.setup_colors)
	end

	-- nvim-notify: background_colour is resolved once, inside its setup().
	if package.loaded["notify"] and current.bg_notify then
		pcall(function()
			require("notify").setup({ background_colour = current.bg_notify })
		end)
	end

	-- Mirrors config/options.lua, which sets this at startup off the palette.
	pcall(vim.api.nvim_set_hl, 0, "LspInlayHint", {
		bg = current.inlay_hint_bg,
		fg = current.inlay_hint_fg,
		italic = true,
		underline = false,
	})
end

-- Persist the choice. Called only from apply() with `persist`, never from the
-- autocmds: the picker's live preview would otherwise write once per keystroke.
function M.save(key)
	local file, err = io.open(theme.state_file, "w")
	if not file then
		utils.warn("Theme: could not save choice (" .. tostring(err) .. ")")
		return
	end
	file:write(vim.json.encode({ theme = key }))
	file:close()
end

-- Switch to `key`. The palette rebuild, the background and the re-emit all
-- happen in the autocmds below, so this only has to get the plugin loaded and
-- fire :colorscheme.
function M.apply(key, opts)
	opts = opts or {}
	local entry = theme.by_key(key)
	if not entry then
		utils.warn("Theme: unknown theme " .. vim.inspect(key))
		return false
	end

	load_plugin(entry)

	local ok, err = pcall(vim.cmd.colorscheme, entry.colorscheme)
	if not ok then
		utils.err("Theme: failed to load " .. entry.colorscheme .. " (" .. tostring(err) .. ")")
		return false
	end

	if opts.persist then
		M.save(key)
	end
	if opts.notify ~= false then
		utils.info("Theme: " .. entry.label)
	end
	return true
end

-- A user-command completion function is used verbatim (like `customlist`),
-- so the prefix filtering has to happen here.
local function keys(arglead)
	local matches = {}
	for _, entry in ipairs(theme.themes) do
		if entry.key:find(arglead or "", 1, true) == 1 then
			table.insert(matches, entry.key)
		end
	end
	return matches
end

-- ══════════════════════════════════════════════════════════════════════
-- Picker
--
-- fzf-lua's built-in `colorschemes` provider can't be reused here, for two
-- reasons. It appends every colors/* file from unloaded plugin rtps on top of
-- whatever `colors` list you give it, so the list can't be curated; and it
-- tracks the active theme through `vim.g.colors_name`, which collapses for the
-- two multi-variant families — every kanso variant reports "kanso" and every
-- rose-pine variant reports "rose-pine". Aborting a preview of kanso-ink would
-- therefore restore plain `:colorscheme kanso`, i.e. zen.
--
-- So the list, the preview and the revert are all driven off registry KEYS,
-- which stay unambiguous. The live-preview mechanism itself is lifted from that
-- provider: a zero-width preview window whose "preview command" is a Lua
-- callback, which fzf re-runs on every cursor move.
-- ══════════════════════════════════════════════════════════════════════
function M.pick()
	local fzf = require("fzf-lua")

	-- Active theme first, then registry order.
	local list, active = {}, theme.active
	for _, entry in ipairs(theme.themes) do
		if entry.key ~= active then
			table.insert(list, entry.key)
		end
	end
	if theme.by_key(active) then
		table.insert(list, 1, active)
	end

	local previous, previewed, confirmed = active, nil, false

	local opts = {
		prompt = "Theme❯ ",
		fzf_opts = {
			["--no-multi"] = true,
			-- Zero-width, but must not be hidden or fzf skips the preview action.
			["--preview-window"] = "nohidden:right:0",
		},
		winopts = {
			height = 0.45,
			width = 0.35,
			backdrop = false,
			title = " Colorscheme ",
			title_pos = "center",
		},
		actions = {
			["enter"] = function(selected)
				confirmed = true
				local key = selected and selected[1]
				if not theme.by_key(key) then
					return
				end
				if key == previewed then
					-- Already on screen from the preview; just remember it.
					M.save(key)
					utils.info("Theme: " .. theme.by_key(key).label)
				else
					M.apply(key, { persist = true })
				end
			end,
		},
	}

	opts.preview = fzf.shell.stringify_data(function(selected)
		if selected and selected[1] and theme.by_key(selected[1]) then
			previewed = selected[1]
			M.apply(previewed, { persist = false, notify = false })
		end
	end, opts, "{}")

	-- on_close fires for <CR> and <Esc> alike, and runs BEFORE the action
	-- (fzf-lua core.lua:296-300). Deferring a tick lets a confirm cancel the
	-- revert, so accepting a theme never flashes the old one on the way out.
	opts.winopts.on_close = function()
		vim.schedule(function()
			if confirmed or not previewed or previewed == previous then
				return
			end
			M.apply(previous, { persist = false, notify = false })
		end)
	end

	fzf.fzf_exec(list, opts)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("ThemeSwitcher", { clear = true })

	vim.api.nvim_create_autocmd("ColorSchemePre", {
		group = group,
		callback = function(args)
			local entry = theme.by_colorscheme(args.match)
			-- Anything we don't own (:colorscheme default, a variant picked by
			-- hand) keeps whatever palette is loaded rather than being forced
			-- onto a mismatched one.
			if not entry then
				return
			end

			load_plugin(entry)
			theme.current_theme = theme.build(entry.key)
			theme.active = entry.key

			-- Only when it actually changes: assigning `background` re-sources
			-- the current colorscheme, which we do not want mid-switch.
			local bg = background_for(entry)
			if vim.o.background ~= bg then
				vim.o.background = bg
			end
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			M.refresh()
		end,
	})

	vim.api.nvim_create_user_command("Theme", function(opts)
		if opts.args == "" then
			M.pick()
		else
			M.apply(opts.args, { persist = true })
		end
	end, {
		nargs = "?",
		desc = "Switch colorscheme (no argument opens the picker)",
		complete = keys,
	})

	-- Startup: the persisted theme. No notification and no write-back — this is
	-- restoring a choice, not making one. If the plugin fails to load, still
	-- paint the setup()-time consumers from the fallback palette.
	if not M.apply(theme.active, { persist = false, notify = false }) then
		M.refresh()
	end
end

return M
