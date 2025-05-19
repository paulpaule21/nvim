return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -----------------------------------------------------------------------
      -- REQUIRED (Neovim 0.11+)
      -----------------------------------------------------------------------
      modules = {},
      sync_install = false,
      ignore_install = {},
      auto_install = true,

      -----------------------------------------------------------------------
      -- FEATURES
      -----------------------------------------------------------------------
      highlight = { enable = true, },
      indent = { enable = true, },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },

      -----------------------------------------------------------------------
      -- PARSERS
      -----------------------------------------------------------------------
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "json",
        "yaml",
        "dockerfile",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "proto",
      },
    })
  end,
}
