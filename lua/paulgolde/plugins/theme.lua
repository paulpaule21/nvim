return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,

  config = function()
    require("paulgolde.theme").setup_autoload()
  end,
}
