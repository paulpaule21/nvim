return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    require("Comment").setup({
      -----------------------------------------------------------------------
      -- REQUIRED (Neovim 0.11+ type completeness)
      -----------------------------------------------------------------------
      padding = true,
      sticky = true,
      ignore = function()
        return ""
      end,

      mappings = {
        basic = true,
        extra = true,
      },

      toggler = {
        line = "gcc",
        block = "gbc",
      },

      opleader = {
        line = "gc",
        block = "gb",
      },

      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },

      post_hook = function(c)
      end,

      -----------------------------------------------------------------------
      -- CONTEXT-AWARE COMMENTING
      -----------------------------------------------------------------------
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim")
          .create_pre_hook(),
    })
  end,
}
