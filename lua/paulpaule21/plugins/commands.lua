return {
  dir = vim.fn.stdpath("config") .. "/lua/paulpaule21",
  name = "qfexec-commands",
  lazy = false,

  config = function()
    local qfexec = require("paulpaule21.qfexec")

    -- Search for word in files (content)
    local function grep_word(p)
      local grepprg = vim.api.nvim_get_option_value("grepprg", {})
      local cmd = vim.fn.split(grepprg)

      vim.list_extend(cmd, p.fargs)
      table.insert(cmd, ".") -- search root

      qfexec.exec(cmd, false, false)
    end

    -- Search for file names
    local function grep_file(p)
      local pattern = p.args

      local cmd = {
        "rg",
        "--files",
        "--glob",
        "*" .. pattern .. "*",
      }

      qfexec.exec(cmd, false, true)
    end

    -- make
    local function make(p)
      local makeprg = vim.api.nvim_get_option_value("makeprg", {})
      local cmd = vim.fn.split(makeprg)
      vim.list_extend(cmd, p.fargs)

      qfexec.exec(cmd, true, false)
    end

    -- term
    local function term(p)
      qfexec.exec(p.fargs, true, false)
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

    local keymap = vim.keymap

    -- Grep word (prompt)
    keymap.set("n", "<leader>fw", function()
      vim.ui.input({ prompt = "Grep word: " }, function(input)
        if input and input ~= "" then
          vim.cmd("GrepWord " .. input)
        end
      end)
    end, { desc = "Grep word (quickfix)" })

    -- Grep file name (prompt)
    keymap.set("n", "<leader>ff", function()
      vim.ui.input({ prompt = "Grep file: " }, function(input)
        if input and input ~= "" then
          vim.cmd("GrepFile " .. input)
        end
      end)
    end, { desc = "Find file (quickfix)" })

    -- Make
    keymap.set("n", "<leader>fm", function()
      vim.cmd("Make")
    end, { desc = "Run make (quickfix)" })

    -- Term (prompt)
    keymap.set("n", "<leader>ft", function()
      vim.ui.input({ prompt = "Shell command: " }, function(input)
        if input and input ~= "" then
          vim.cmd("Term " .. input)
        end
      end)
    end, { desc = "Run shell command (quickfix)" })
  end,
}
