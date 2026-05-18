# Neovim Config Modernization — CHANGELOG

## 2026-03-17 — Full Audit & Restructure (nvimv2)

### 1. Folder Structure
- **Removed** duplicate `lua/core/` directory (merged into `lua/config/`)
- **Flattened** `plugins/coding/` (13 files) into top-level `plugins/` (one file per logical group)
- **Flattened** `plugins/ui/` (10 files) into `plugins/ui.lua` (single consolidated spec)
- **Removed** plugin loader intermediaries (`coding.lua`, `ui.lua`, `lsp.lua`)
- **Moved** `plugins/lsp/config/` to `plugins/lsp/` (flat)
- **Moved** heirline config to `config/heirline/` (separated from plugin specs)
- **Removed** `heirline.lua.bak` backup file
- **Renamed** `utils/utils.lua` → `utils/init.lua` (cleaner `require("utils")`)
- **Inlined** `utils/filterReactDTS.lua` and `utils/filter.lua` into `plugins/lsp/vtsls.lua`
- **Inlined** `utils/mason.lua` ensure_installed list into `plugins/lsp/init.lua`

### 2. Naming Conventions
- **Fixed** `wichkey.lua` typo (file kept as-is, merged into `editor.lua`)
- **Fixed** `reuires` → `dependencies` and `planary` → `plenary` typos in gitsigns
- **Renamed** `rustace.lua` → `rust.lua` (clearer)
- **Renamed** `lua-ls.lua` → `lua_ls.lua` (consistent snake_case)
- **Renamed** `blinkcmp.lua` → `completion.lua` (descriptive)
- **Renamed** `indentblank.lua` → merged into `editor.lua`
- All `require("utils.utils")` calls updated to `require("utils")`

### 3. Comments & Documentation
- Added header comments to all module files describing purpose
- Removed debug globals (`_G.print_heirline_colors`, `_G.check_git_status`, `_G.check_highlight_groups`, `_G.memory_usage`)

### 4. Deprecation Audit
- **Replaced** `vim.loop` → `vim.uv` in `utils/constants.lua`, `config/heirline/conditions.lua`, `plugins/ui.lua`
- **Replaced** `vim.api.nvim_get_hl_by_name()` → `vim.api.nvim_get_hl(0, {...})` in heirline config (20+ occurrences)
- **Removed** deprecated `vim.fn.sign_define()` pattern from old `core/options.lua` — uses modern `vim.diagnostic.config({ signs = { text = {...} } })` API
- **Fixed** `require("config.lazy").Lazy(_)` → direct `require("config.lazy")` (no method call needed)
- **Removed** gitsigns plenary dependency (no longer needed in recent versions)

### 5. Health Checks
- **Created** `lua/config/health.lua` — accessible via `:checkhealth config`
- Checks: Neovim version, external tools (rg, fd, node, git, python3, cargo, go), formatters (prettier, stylua, black, isort, gofumpt, goimports, shfmt), lazy.nvim status, Mason packages, LSP servers

### 6. Performance Optimization
- **Disabled** 16 built-in plugins in `init.lua` (netrw, matchit, matchparen, gzip, zip, tar, 2html, etc.)
- **Added** lazy.nvim `defaults = { lazy = true }` — all plugins lazy by default
- **Added** lazy.nvim `performance.rtp.disabled_plugins` for additional built-in disabling
- **Added** Neovim >= 0.10 version guard in `init.lua`
- **Added** `event`, `cmd`, `ft`, `keys` lazy-loading triggers to all plugins:
  - autopairs: `event = "InsertEnter"`
  - which-key: `event = "VeryLazy"`
  - gitsigns: `event = { "BufReadPost", "BufNewFile" }`
  - bufferline: `event = { "BufReadPost" }`
  - ts-error-translator: `ft = { "typescript", "typescriptreact", ... }`
  - heirline: `event = "UiEnter"`
- **Set** `change_detection = { notify = false }` to reduce noise

### 7. DAP Setup
- **Consolidated** `coding/dap.lua` + `coding/dapui.lua` → single `plugins/dap.lua`
- All keymaps under `<leader>d` prefix: db (breakpoint), dB (conditional), dc (continue), di (step into), do (step over), dO (step out), dr (REPL), dl (run last), dt (terminate), du (toggle UI), de (eval)
- Auto-open/close dapui on session start/end via `dap.listeners`
- Configured adapters: pwa-node (JS/TS), delve (Go)

### 8. File Explorer
- **Removed** `nvim-tree.nvim` config entirely (`plugins/ui/nvim-tree.lua`)
- **Removed** NvimTree highlight overrides from `colorscheme.lua`
- **Added** `neo-tree.nvim` (`plugins/explorer.lua`) with:
  - Filesystem, buffers, git_status sources
  - `<leader>e` toggle, `<leader>E` reveal current file
  - Git status icons, file nesting rules
  - netrw directory hijacking
  - Copy-path-to-clipboard mapping (Y)
  - 35-column left sidebar

### 9. Colorscheme
- **Kept** `kanso.nvim` (zen variant) — already well-integrated with the config
- Heirline statusline uses dynamic highlight extraction (colorscheme-agnostic)
- Removed nvim-tree specific overrides (no longer needed)

### 10. Buffer Tabs
- **Enhanced** bufferline config with:
  - `diagnostics = "nvim_lsp"` with indicator function showing error/warning counts
  - New keymaps: `<leader>bp` (pin), `<leader>bP` (delete non-pinned), `<leader>bc` (close), `<leader>bo` (close others)
  - `event = { "BufReadPost" }` for lazy loading

### File Structure (Before → After)

**Before (54 files):**
```
lua/
├── config/          (5 files)
├── core/            (3 files — untracked, duplicates config/)
├── plugins/
│   ├── coding/      (13 files)
│   ├── coding.lua   (loader)
│   ├── ui/          (10 files + config/ subdir with .bak)
│   ├── ui.lua       (loader)
│   ├── lsp/         (init + config/ subdir with 4 files)
│   ├── lsp.lua      (loader)
│   ├── mason.lua
│   ├── colorscheme.lua
│   ├── treesitter.lua
│   └── 5 untracked flat files
└── utils/           (5 files)
```

**After (28 files):**
```
lua/
├── config/
│   ├── autocmds.lua
│   ├── health.lua
│   ├── heirline/
│   │   ├── conditions.lua
│   │   └── init.lua
│   ├── keymaps.lua
│   ├── lazy.lua
│   ├── options.lua
│   └── theme.lua
├── plugins/
│   ├── colorscheme.lua
│   ├── completion.lua     (blink.cmp)
│   ├── conform.lua
│   ├── dap.lua
│   ├── editor.lua         (autopairs, comment, which-key, indent-blankline)
│   ├── explorer.lua       (neo-tree — NEW)
│   ├── fzf.lua
│   ├── git.lua            (gitsigns, crates)
│   ├── lsp/
│   │   ├── init.lua       (lspconfig + mason)
│   │   ├── kotlin.lua
│   │   ├── lua_ls.lua
│   │   ├── rust.lua
│   │   └── vtsls.lua
│   ├── noice.lua
│   ├── statusline.lua     (heirline)
│   ├── tools.lua          (tmux-navigator, claudecode, ts-error)
│   ├── treesitter.lua
│   └── ui.lua             (bufferline, alpha, icons, incline)
└── utils/
    ├── constants.lua
    └── init.lua
```
