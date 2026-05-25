-- Export nvim-web-devicons icon tables to yazi's [icon] section.
--
-- Yazi is a separate Rust binary; it can't call lua plugins from nvim.
-- This module reads the live nvim-web-devicons icon table and writes
-- equivalent `[icon]` rules into ~/.config/yazi/theme.toml between two
-- markers, so yazi renders the same glyphs + colors as nvim.
--
-- Usage:   :YaziIconsExport         (writes to theme.toml)
-- Re-run:  safe — the block between markers is replaced in place.

local M = {}

local YAZI_THEME = vim.fn.expand("~/.config/yazi/theme.toml")
local BEGIN_MARKER = "# >>> nvim-web-devicons begin (auto-generated, do not edit)"
local END_MARKER = "# <<< nvim-web-devicons end"

local function escape_toml_string(s)
  return (s:gsub("\\", "\\\\"):gsub('"', '\\"'))
end

local function emit_rules(out, header, items)
  if not next(items) then
    return
  end

  table.insert(out, header .. " = [")
  local names = vim.tbl_keys(items)
  table.sort(names)
  for _, name in ipairs(names) do
    local it = items[name]
    if it and it.icon and it.color then
      table.insert(
        out,
        string.format('  { name = "%s", text = "%s", fg = "%s" },', escape_toml_string(name), it.icon, it.color)
      )
    end
  end
  table.insert(out, "]")
  table.insert(out, "")
end

function M.export()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    vim.notify("YaziIcons: nvim-web-devicons is not loaded", vim.log.levels.ERROR)
    return
  end

  -- nvim-web-devicons exposes getters in newer versions; fall back to the
  -- raw internal tables on older versions.
  local by_ext = (devicons.get_icons_by_extension and devicons.get_icons_by_extension())
    or (devicons.get_icons and devicons.get_icons().by_extension)
    or {}
  local by_file = (devicons.get_icons_by_filename and devicons.get_icons_by_filename())
    or (devicons.get_icons and devicons.get_icons().by_filename)
    or {}

  local lines = {
    BEGIN_MARKER,
    "# Source: nvim-web-devicons (auto-exported by :YaziIconsExport).",
    "# Re-run the command after updating the plugin or your custom icons.",
    "[icon]",
    "",
  }

  emit_rules(lines, "files", by_file)
  emit_rules(lines, "exts", by_ext)

  table.insert(lines, END_MARKER)

  -- Read existing theme.toml
  local content = ""
  local f = io.open(YAZI_THEME, "r")
  if f then
    content = f:read("*a")
    f:close()
  end

  local block = table.concat(lines, "\n")

  -- Replace existing block between markers, or append to EOF
  local begin_idx = content:find(BEGIN_MARKER, 1, true)
  if begin_idx then
    local end_idx = content:find(END_MARKER, begin_idx, true)
    if not end_idx then
      vim.notify(
        "YaziIcons: found BEGIN marker but no END marker in theme.toml — refusing to overwrite",
        vim.log.levels.ERROR
      )
      return
    end
    end_idx = end_idx + #END_MARKER
    content = content:sub(1, begin_idx - 1) .. block .. content:sub(end_idx + 1)
  else
    if not content:match("\n$") then
      content = content .. "\n"
    end
    content = content .. "\n" .. block .. "\n"
  end

  local out = io.open(YAZI_THEME, "w")
  if not out then
    vim.notify("YaziIcons: cannot write " .. YAZI_THEME, vim.log.levels.ERROR)
    return
  end
  out:write(content)
  out:close()

  local file_count = vim.tbl_count(by_file)
  local ext_count = vim.tbl_count(by_ext)
  vim.notify(
    string.format("YaziIcons: exported %d files + %d extensions → %s", file_count, ext_count, YAZI_THEME),
    vim.log.levels.INFO
  )
end

vim.api.nvim_create_user_command("YaziIconsExport", function()
  M.export()
end, { desc = "Export nvim-web-devicons → yazi theme.toml [icon] section" })

return M
