-- Per-tag-name colors for HTML/JSX.
--
-- A treesitter capture can only say WHAT a node is, never what it contains, so
-- `@tag` / `@tag.builtin` can give html elements one color and components
-- another and that is the end of it -- every <div>, <span> and <button> still
-- shares a single color. Coloring by the tag's NAME needs extmarks, which is
-- what this module does: each distinct name gets a stable color, so <div> is
-- always the same color everywhere in the file (and in every file), <span> is
-- always a different one, and a closing </div> matches its opener because the
-- color comes from the name rather than from position or nesting.
--
-- The angle brackets are left alone -- rainbow-delimiters colors those by
-- nesting depth (plugins/editor/rainbow.lua), so depth and identity stay
-- readable at the same time.

local M = {}

local ns = vim.api.nvim_create_namespace("tag_colors")

-- Extmarks beat treesitter (100) and LSP semantic tokens (125), so the name
-- color wins over whatever @tag/@tag.builtin resolved to.
local PRIORITY = 200

-- Tag names are matched per language with a tiny query rather than by running
-- the full `highlights` query, which would mean walking every capture in the
-- buffer on each keystroke.
local JSX = [[
  [
    (jsx_opening_element name: (_) @name)
    (jsx_closing_element name: (_) @name)
    (jsx_self_closing_element name: (_) @name)
  ]
]]

local QUERIES = {
	html = "((tag_name) @name)",
	javascript = JSX, -- .js and .jsx both parse as `javascript`
	tsx = JSX,
}

-- Colors are taken from groups the colorscheme has already defined, so this
-- follows a :Theme switch and needs no per-theme palette entry. They are the
-- theme's own syntax colors, which is what keeps the result looking like it
-- belongs to the theme instead of a fixed rainbow pasted on top.
local SOURCES = {
	"@function",
	"@type",
	"@string",
	"@constant",
	"@keyword",
	"@property",
	"@number",
	"@constructor",
	"@operator",
	"@variable.member",
	"@boolean",
	"@label",
	"@variable",
	"@parameter",
	"@field",
	"@attribute",
	"@character",
	"@module",
	"@keyword.return",
	"@punctuation.special",
	"Identifier",
	"Special",
}

local groups = {} ---@type string[] names of the TagColor* groups, in order

---Relative luminance, for keeping unreadable colors out of the set.
local function luminance(hex)
	local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
	if not r then
		return nil
	end
	local function channel(c)
		c = tonumber(c, 16) / 255
		return c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
	end
	return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
end

local function contrast(a, b)
	local la, lb = luminance(a), luminance(b)
	if not la or not lb then
		return 0
	end
	local hi, lo = math.max(la, lb), math.min(la, lb)
	return (hi + 0.05) / (lo + 0.05)
end

---Hue in degrees, or nil for a grey.
local function hue(hex)
	local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
	if not r then
		return nil
	end
	r, g, b = tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255
	local mx, mn = math.max(r, g, b), math.min(r, g, b)
	if mx == mn then
		return nil
	end
	local d, h = mx - mn, 0
	if mx == r then
		h = ((g - b) / d) % 6
	elseif mx == g then
		h = (b - r) / d + 2
	else
		h = (r - g) / d + 4
	end
	return h * 60
end

---Two colors are usable as separate tag colors when they differ in hue OR in
---lightness. Judging on lightness alone threw away perfectly distinct pairs --
---a teal and a grey of the same brightness are easy to tell apart.
local function distinct(a, b)
	local ha, hb = hue(a), hue(b)
	if ha and hb then
		local hd = math.abs(ha - hb)
		if hd > 180 then
			hd = 360 - hd
		end
		if hd >= 25 then
			return true
		end
	elseif (ha == nil) ~= (hb == nil) then
		-- one grey, one colored: distinct as long as they are not the same
		-- brightness mush
		if contrast(a, b) >= 1.10 then
			return true
		end
	end
	return contrast(a, b) >= 1.18
end

---Rebuild TagColor1..N from the active colorscheme.
---Called at startup and on every ColorScheme.
function M.build_palette()
	local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
	local bg = normal.bg and string.format("#%06X", normal.bg) or "#000000"
	-- A tag painted the same color as ordinary text is not a tag color.
	local fg = normal.fg and string.format("#%06X", normal.fg) or nil

	local colors, seen = {}, {}
	for _, source in ipairs(SOURCES) do
		local hl = vim.api.nvim_get_hl(0, { name = source, link = false })
		if hl and hl.fg then
			local hex = string.format("#%06X", hl.fg)
			-- Skip near-duplicates of a color already taken, and anything that
			-- would be unreadable on this background.
			local ok_new = not seen[hex]
			if ok_new then
				for _, taken in ipairs(colors) do
					if not distinct(hex, taken) then
						ok_new = false
						break
					end
				end
			end
			if ok_new and fg and not distinct(hex, fg) then
				ok_new = false
			end
			if ok_new and contrast(hex, bg) >= 2.5 then
				seen[hex] = true
				table.insert(colors, hex)
			end
		end
	end

	groups = {}
	for i, hex in ipairs(colors) do
		local name = "TagColor" .. i
		vim.api.nvim_set_hl(0, name, { fg = hex })
		table.insert(groups, name)
	end
	return #groups
end

---Stable index for a tag name: the same name always lands on the same color,
---which is what makes <div> recognisable at a glance and keeps a closing tag
---matching its opener. FNV-1a, to spread similar names (div/dir/dl) apart.
local function index_for(name)
	local hash = 2166136261
	for i = 1, #name do
		hash = hash ~ name:byte(i)
		hash = (hash * 16777619) % 4294967296
	end
	return (hash % #groups) + 1
end

---A component is `<Foo>` or `<Foo.Bar>`; an element is `<div>`. They already
---differ by color here, but bold keeps the distinction legible for anyone who
---reads shape faster than hue.
local function is_component(name)
	return name:match("^%u") ~= nil or name:find(".", 1, true) ~= nil
end

function M.highlight(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_loaded(buf) or vim.b[buf].bigfile then
		return
	end
	if #groups == 0 and M.build_palette() == 0 then
		return
	end

	local ok, parser = pcall(vim.treesitter.get_parser, buf)
	if not ok or not parser then
		return
	end

	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	-- The hash keeps a name on the same color across files, but with a small
	-- palette (a near-monochrome theme yields six or seven) several names can
	-- land on one slot and the whole point is lost. Probe to the next free
	-- color when that happens, so within a buffer the tags stay spread out and
	-- the common ones still keep their usual color.
	local assigned, used = {}, {}
	local function color_for(name)
		if assigned[name] then
			return assigned[name]
		end
		local idx = index_for(name)
		if used[idx] then
			for step = 1, #groups - 1 do
				local try = ((idx - 1 + step) % #groups) + 1
				if not used[try] then
					idx = try
					break
				end
			end
		end
		assigned[name], used[idx] = idx, true
		return idx
	end

	-- for_each_tree covers injected languages too, so JSX inside a markdown
	-- code block or html inside a blade template is handled the same way.
	parser:for_each_tree(function(tree, ltree)
		local src = QUERIES[ltree:lang()]
		if not src then
			return
		end
		local parsed = vim.treesitter.query.parse(ltree:lang(), src)
		for _, node in parsed:iter_captures(tree:root(), buf) do
			local text = vim.treesitter.get_node_text(node, buf)
			if text and text ~= "" then
				local srow, scol, erow, ecol = node:range()
				pcall(vim.api.nvim_buf_set_extmark, buf, ns, srow, scol, {
					end_row = erow,
					end_col = ecol,
					hl_group = groups[color_for(text)],
					hl_mode = "combine",
					priority = PRIORITY,
					-- bold rides on top of the color via hl_mode = "combine"
					-- only when a second mark is added, so components get their
					-- own group instead.
				})
				if is_component(text) then
					pcall(vim.api.nvim_buf_set_extmark, buf, ns, srow, scol, {
						end_row = erow,
						end_col = ecol,
						hl_group = "TagColorComponent",
						hl_mode = "combine",
						priority = PRIORITY + 1,
					})
				end
			end
		end
	end)
end

function M.setup()
	vim.api.nvim_set_hl(0, "TagColorComponent", { bold = true })
	M.build_palette()

	local group = vim.api.nvim_create_augroup("TagColors", { clear = true })
	local timers = {}

	-- Coalesce bursts of changes; re-running the query on every keystroke of a
	-- long JSX line is wasted work.
	local function schedule(buf)
		if not QUERIES[vim.treesitter.language.get_lang(vim.bo[buf].filetype) or ""] then
			return
		end
		if timers[buf] then
			timers[buf]:stop()
		end
		timers[buf] = vim.defer_fn(function()
			timers[buf] = nil
			if vim.api.nvim_buf_is_valid(buf) then
				M.highlight(buf)
			end
		end, 60)
	end

	vim.api.nvim_create_autocmd({ "BufWinEnter", "TextChanged", "InsertLeave" }, {
		group = group,
		callback = function(args)
			schedule(args.buf)
		end,
	})

	-- Live updates while typing, but only where the pass is cheap: a dense
	-- thousand-tag file costs ~13ms per run, which is fine on <CR> and far too
	-- often on every keystroke. Bigger buffers catch up on InsertLeave.
	vim.api.nvim_create_autocmd("TextChangedI", {
		group = group,
		callback = function(args)
			if vim.api.nvim_buf_line_count(args.buf) <= 1000 then
				schedule(args.buf)
			end
		end,
	})

	-- Colors are read off the colorscheme, so both have to be redone.
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			vim.api.nvim_set_hl(0, "TagColorComponent", { bold = true })
			M.build_palette()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					schedule(buf)
				end
			end
		end,
	})

	vim.api.nvim_create_user_command("TagColors", function()
		local n = M.build_palette()
		M.highlight(0)
		vim.notify(("Tag colors: %d colors from the active theme"):format(n))
	end, { desc = "Rebuild the per-tag-name colors" })
end

return M
