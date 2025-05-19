return {
  dir = vim.fn.stdpath("config") .. "/lua/paulpaule21",
  name = "qfexec-commands",
  event = "VeryLazy",
  config = function()
    local qfexec = require("paulpaule21.qfexec")

    local function grep(p)
      local grepprg = vim.api.nvim_get_option_value("grepprg", {})
      qfexec.exec({ grepprg, p.args }, false)
    end

    local function make(p)
      local makeprg = vim.api.nvim_get_option_value("makeprg", {})
      qfexec.exec({ makeprg, p.args }, true)
    end

    local function exec(p)
      qfexec.exec({ p.args }, true)
    end

    vim.api.nvim_create_user_command("Grep", grep, {
      nargs = "+",
      complete = "file",
      desc = "Run grepprg and send to quickfix",
    })

    vim.api.nvim_create_user_command("Make", make, {
      nargs = "*",
      desc = "Run makeprg and send to quickfix",
    })

    vim.api.nvim_create_user_command("Term", exec, {
      nargs = "+",
      desc = "Run shell command and send to quickfix",
    })
  end,
}
