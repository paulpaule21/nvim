return {
  "paulpaule21/life.nvim",
  dependencies = {
    "nvim-orgmode/orgmode",
    "chipsenkbeil/org-roam.nvim",
  },
  config = function()
    require("life").setup()
  end,
}

