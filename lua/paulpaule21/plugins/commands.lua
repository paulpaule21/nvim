return {
  dir = vim.fn.stdpath("config") .. "/lua/paulpaule21",
  name = "qfexec-commands",
  lazy = false,

  config = function()
    local qfexec = require("paulpaule21.qfexec")

    local function grep_word(p)
      local grepprg = vim.api.nvim_get_option_value("grepprg", {})
      local cmd = vim.fn.split(grepprg)
      vim.list_extend(cmd, p.fargs)

      if not vim.tbl_contains(p.fargs, ".") then
        table.insert(cmd, ".")
      end

      qfexec.exec(cmd, false)
    end

    local function grep_file(p)
      local pattern = p.args

      -- rg --files --glob '*pattern*'
      local cmd = {
        "rg",
        "--files",
        "--hidden",
        "--glob",
        "*" .. pattern .. "*",
      }

      qfexec.exec(cmd, false)
    end


    local function make(p)
      local makeprg = vim.api.nvim_get_option_value("makeprg", {})
      local cmd = vim.fn.split(makeprg)
      vim.list_extend(cmd, p.fargs)
      qfexec.exec(cmd, true)
    end

    local function term(p)
      qfexec.exec(p.fargs, true)
    end

    vim.api.nvim_create_user_command("GrepWord", grep_word, {
      nargs = "+",
      desc = "Search for word in files (rg --vimgrep)",
    })

    vim.api.nvim_create_user_command("GrepFile", grep_file, {
      nargs = 1,
      desc = "Search for file names",
    })

    vim.api.nvim_create_user_command("Make", make, {
      nargs = "*",
      desc = "Run makeprg and send to quickfix",
    })

    vim.api.nvim_create_user_command("Term", term, {
      nargs = "+",
      desc = "Run shell command and send to quickfix",
    })
  end,
}
