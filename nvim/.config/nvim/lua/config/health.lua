-- Health check module for :checkhealth config
local M = {}

local health = vim.health

local function check_version()
  health.start("Neovim Version")
  if vim.fn.has("nvim-0.10") == 1 then
    health.ok("Neovim >= 0.10 (" .. tostring(vim.version()) .. ")")
  else
    health.error("Neovim >= 0.10 is required, found " .. tostring(vim.version()))
  end
end

local function check_external_tools()
  health.start("External Tools")
  local tools = {
    { cmd = "git",     name = "Git" },
    { cmd = "rg",      name = "ripgrep (rg)" },
    { cmd = "fd",      name = "fd" },
    { cmd = "node",    name = "Node.js" },
    { cmd = "python3", name = "Python 3" },
    { cmd = "cargo",   name = "Cargo (Rust)" },
    { cmd = "go",      name = "Go" },
  }
  for _, tool in ipairs(tools) do
    if vim.fn.executable(tool.cmd) == 1 then
      health.ok(tool.name .. " found")
    else
      health.warn(tool.name .. " not found (optional)")
    end
  end
end

local function check_formatters()
  health.start("Formatters & Linters")
  local formatters = {
    { cmd = "prettier",  name = "Prettier" },
    { cmd = "stylua",    name = "StyLua" },
    { cmd = "black",     name = "Black" },
    { cmd = "isort",     name = "isort" },
    { cmd = "gofumpt",   name = "gofumpt" },
    { cmd = "goimports", name = "goimports" },
    { cmd = "shfmt",     name = "shfmt" },
  }
  for _, fmt in ipairs(formatters) do
    if vim.fn.executable(fmt.cmd) == 1 then
      health.ok(fmt.name .. " found")
    else
      health.warn(fmt.name .. " not found")
    end
  end
end

local function check_lazy()
  health.start("Plugin Manager (lazy.nvim)")
  local ok, lazy = pcall(require, "lazy")
  if ok then
    local stats = lazy.stats()
    health.ok(string.format("lazy.nvim loaded (%d/%d plugins)", stats.loaded, stats.count))
  else
    health.error("lazy.nvim is not installed")
  end
end

local function check_mason()
  health.start("Mason")
  local ok, mason_registry = pcall(require, "mason-registry")
  if ok then
    local installed = mason_registry.get_installed_packages()
    local names = {}
    for _, pkg in ipairs(installed) do
      table.insert(names, pkg.name)
    end
    if #names > 0 then
      health.ok(string.format("Mason has %d packages installed: %s", #names, table.concat(names, ", ")))
    else
      health.warn("Mason has no packages installed")
    end
  else
    health.warn("Mason is not installed or not loaded yet")
  end
end

local function check_lsp_servers()
  health.start("LSP Servers")
  local servers = {
    { cmd = "lua-language-server",    name = "lua_ls" },
    { cmd = "gopls",                  name = "gopls" },
    { cmd = "typescript-language-server", name = "ts_ls" },
    { cmd = "pyright-langserver",     name = "pyright" },
    { cmd = "rust-analyzer",          name = "rust_analyzer" },
    { cmd = "templ",                  name = "templ" },
    { cmd = "tailwindcss-language-server", name = "tailwindcss" },
  }
  for _, server in ipairs(servers) do
    if vim.fn.executable(server.cmd) == 1 then
      health.ok(server.name .. " found")
    else
      health.warn(server.name .. " not found in PATH or Mason")
    end
  end
end

M.check = function()
  check_version()
  check_external_tools()
  check_formatters()
  check_lazy()
  check_mason()
  check_lsp_servers()
end

return M
