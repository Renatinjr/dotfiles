-- Statusline: heirline.nvim with dynamic colorscheme-aware colors
return {
  "rebelot/heirline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "UiEnter",
  config = function()
    require("config.heirline")
  end,
}
