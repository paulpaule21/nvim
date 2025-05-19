return {
  name = "paulpaule21-theme",
  dir = vim.fn.stdpath("config") .. "/lua/paulpaule21", -- LOCAL path
  lazy = false,
  priority = 1000,

  config = function()
    require("paulpaule21.theme").setup({
      theme = "dark",
      transparent = false,
      override = {},
    })
  end,
}
