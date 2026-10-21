# Neovim config

Neovim ≥ 0.11, [lazy.nvim](https://github.com/folke/lazy.nvim), Lua only.
Lives in `dotfiles/nvim/.config/nvim` and is symlinked to `~/.config/nvim`.

## Layout

```
init.lua                     version guard, leader, require chain
stylua.toml / .luarc.json    formatter + lua_ls settings for editing this repo
lazy-lock.json               pinned plugin revisions

lua/config/                  editor behaviour, no plugin specs
  lazy.lua                   bootstrap + which plugin directories to import
  options.lua                vim.opt / vim.g
  statuscolumn.lua           the custom 'statuscolumn' renderer
  keymaps.lua                global maps + buffer-local LSP maps (LspAttach)
  autocmds.lua               yank highlight, resize, close-with-q, treesitter start…
  bigfile.lua                guard that turns heavy features off on big files
  heirline.lua               statusline definition
  health.lua                 :checkhealth config
  theme/init.lua             theme registry + persisted choice (theme.json)
  theme/switcher.lua         :Theme, <leader>uc picker, ColorScheme hooks

lua/themes/                  one file per colorscheme family (palette + plugin spec)
  lib.lua                    make_nvim_tree(), blend() shared helpers

lua/lsp/                     plain LSP modules (not plugin specs)
  servers/<name>.lua         vim.lsp.config() table for one server
  eslint.lua, ts_shared.lua  eslint setup, shared TypeScript handlers

lua/plugins/                 every file is a lazy.nvim spec (or a list of specs)
  ui/        colorscheme loader, bufferline, alpha, icons, incline, noice, statusline, diagnostics
  editor/    autopairs, comment, which-key, indent guides, rainbow delimiters, fzf, nvim-tree, gitsigns, grug-far
  coding/    blink.cmp, conform, treesitter
  lsp/       mason, nvim-lspconfig
  lang/      rustaceanvim, crates, kotlin, android, tsc (TypeScript 7), vtsls
             (PHP needs no plugin — see Language servers below)
  tools/     tmux navigator, claudecode, kulala (REST), dap, image, agrolens

lua/utils/                   notify/resize/tmux helpers, :YaziIconsExport
```

Rule of thumb: if a file returns a lazy spec it goes under `lua/plugins/`; anything
else goes next to what uses it. lazy errors on non-spec modules inside an imported
directory, so never drop helpers into `lua/plugins/`.

## Boot order

`init.lua` → `config.bigfile` (must exist before the first buffer is read) →
`config.lazy` (plugins, then `config.theme.switcher.setup()` applies the saved
theme) → `config.options` → `config.autocmds` → `config.keymaps`.

## Themes

`config/theme/init.lua` is the registry: one entry per `:colorscheme` name with the
`lua/themes/<module>.lua` that owns it. Each theme module exports:

- `M.palette(variant)` — the colors that chrome plugins read from
  `require("config.theme").current_theme` (bufferline, nvim-tree, alpha, incline,
  fzf-lua, blink, indent guides, notify, LspInlayHint). Returns `{}` when the
  colorscheme plugin isn't loaded yet; the registry then falls back to koda.
- `M.spec` — the colorscheme plugin's lazy spec with its highlight overrides.
- `M.background()` — only for material/evergarden, whose light/dark answer
  depends on a runtime setting.

`plugins/ui/colorscheme.lua` hands lazy the specs listed in `config.theme.modules`.
Theme modules must not require `config.theme` at the top level (the registry
requires them lazily; `config.theme.switcher` may be required inside callbacks).

Switching: `:Theme` (picker with live preview), `:Theme <key>`, `<leader>uc`, or a
plain `:colorscheme`. The choice is saved to `stdpath("state")/theme.json`.
`:MaterialStyle <style>` swaps material's variant.

**Adding a theme:** create `lua/themes/<name>.lua` following the contract at the top
of any existing one, add `"<name>"` to `M.modules` and an entry to `M.themes` in
`config/theme/init.lua`, run `:Lazy install`.

## Keymaps

Leader is `<Space>`. Where a map is defined:

- global editor maps → `config/keymaps.lua`
- plugin maps → the plugin's `keys = {}` table (keeps lazy-loading triggers)
- buffer-local language maps → the server's `on_attach` (`plugins/lang/*`, `lua/lsp/eslint.lua`)
- which-key only supplies group labels (`plugins/editor/which-key.lua`)

Prefixes: `<leader>f` find (fzf), `<leader>g` git, `<leader>l` LSP, `<leader>w`
window, `<leader>u` UI, `<leader>d` debug, `<leader>R` REST, `<leader>s` search /
splits / swap, `<leader>a` Claude Code, `<leader>c` code actions (buffer-local, TS /
eslint), `<leader>k` Kotlin (buffer-local). Rust maps are two-letter `<space>xx` chords set by rustaceanvim's on_attach (`plugins/lang/rust.lua`).

Known overlaps, left as-is on purpose:

- `<leader>co` / `<leader>sh`: `:copen` / `:split` in keymaps.lua until fzf-lua
  loads, then fzf `commands` / `search_history` win.
- `<leader>gb`: fzf `git_branches` globally, gitsigns `blame_line` in git buffers.
- `<leader>a*`: android-nvim-plugin (eager) and claudecode share the prefix.
- `<leader>f`, `<leader>m`, `<leader>d`, `<leader>p` are both a map and a prefix, so
  they wait for `timeoutlen`.

## Language servers

Servers are enabled in `plugins/lsp/lspconfig.lua`; per-server tables live in
`lua/lsp/servers/`. Mason installs the binaries (`plugins/lsp/mason.lua`).
TypeScript uses the native TS 7 server by default; set `vim.g.ts_lsp = "vtsls"` in
`options.lua` to switch. `vim.g.tsc_memory_limit` caps the TS server heap.

### PHP / Laravel

- **LSP**: intelephense on `php`. A licence key dropped at
  `~/intelephense/licence.txt` is picked up automatically; without one the free
  tier still covers completion, hover, diagnostics and goto.
  `:IntelephenseIndex` (buffer-local) re-indexes after a `composer install`.
- **Blade**: intelephense stays off `.blade.php` on purpose — it reads
  `@extends(...)` as a call to an undefined function and cannot see inside
  `{{ ... }}`, so it would only add noise. Views are served by the treesitter
  `blade` parser (which injects `php_only` and `html`) plus html-ls for tag and
  attribute completion, and blade-formatter on save.
- **Formatting**: `pint` for php, `blade-formatter` for blade, both through
  conform. Pint prefers the project's `vendor/bin/pint`, so `pint.json` and the
  project's own version win; Mason's copy is the fallback.
- **Debugging**: `<leader>dc` → "Listen for Xdebug (:9003)", then trigger the
  request. `php.ini` sets `xdebug.start_with_request=trigger`, so ordinary runs
  are not slowed down and a debug run needs the trigger:
  `XDEBUG_TRIGGER=1 php artisan ...` or `?XDEBUG_TRIGGER=1` on a URL. The other
  two configurations ("Debug current script", "Debug artisan command") set the
  trigger themselves. Xdebug settings live in
  `/opt/homebrew/etc/php/8.5/conf.d/20-xdebug-debug.ini`, outside this repo.
  For Sail/DDEV add a `pathMappings` entry — see the comment in
  `plugins/tools/dap.lua`.

## Tooling

- Format: `stylua .` (config in `stylua.toml`; the binary is at `~/.local/share/nvim/mason/bin/stylua`).
- `:checkhealth config` reports the external tools and servers this config expects.
- Never edit `lazy-lock.json` by hand; `:Lazy update` then commit it.
