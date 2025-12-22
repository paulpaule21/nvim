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

    vim.keymap.set("n", "<leader>rt", function()
      require("paulgolde.plugins.theme").apply_theme("light", require("paulgolde.plugins.theme")._opts)
    end, { desc = "Reload theme" })
  end,
}
