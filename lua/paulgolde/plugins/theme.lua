return {
  name = "paulgolde-theme",
  dir = vim.fn.stdpath("config") .. "/lua/paulgolde", -- LOCAL path
  lazy = false,
  priority = 1000,

  config = function()
    require("paulgolde.theme").setup({
      theme = "dark",
      transparent = false,
      override = {},
    })
  end,
}
