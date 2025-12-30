local M = {}

local job = {
  id = -1,
  cmd = "",
  last_line = "",
  started = nil,
  autoscroll = true,
  files_only = false,
}

local function on_job_output(id, data, _)
  if id ~= job.id then
    return
  end

  if #data == 1 and data[1] == "" and job.last_line == "" then
    return
  end

  local lines = { job.last_line .. data[1] }
  job.last_line = ""

  if #data > 1 then
    for i = 2, #data - 1 do
      table.insert(lines, data[i])
    end
    job.last_line = data[#data]
  end

  local need_scroll = job.autoscroll and vim.fn.line(".") == vim.fn.line("$")

  if job.files_only then
    local items = {}
    for _, line in ipairs(lines) do
      if line ~= "" then
        table.insert(items, {
          filename = line,
          lnum = 1,
        })
      end
    end

    if #items > 0 then
      vim.fn.setqflist({}, "a", { items = items })
    end
  else
    vim.fn.setqflist({}, "a", { lines = lines })
  end

  if need_scroll then
    vim.cmd("cbottom")
  end
end

local function on_job_exit(id, code, _)
  if id ~= job.id then
    return
  end

  local last_line = ""
  if code == 0 then
    local dur = vim.fn.reltime(job.started)
    local took = string.gsub(vim.fn.reltimestr(dur), "%s+", "")
    last_line = "# command finished in " .. took .. "s"
  else
    local sigs = {
      "SIGHUP", "SIGINT", "SIGQUIT", "SIGILL", "SIGTRAP", "SIGABRT",
      "SIGBUS", "SIGFPE", "SIGKILL", "SIGUSR1", "SIGSEGV", "SIGUSR2",
      "SIGPIPE", "SIGALRM", "SIGTERM", nil, "SIGCHLD", "SIGCONT",
      "SIGSTOP", "SIGTSTP", "SIGTTIN", "SIGTTOU", "SIGURG", "SIGXCPU",
      "SIGXFSZ", "SIGVTALRM", "SIGPROF", "SIGWINCH", "SIGIO",
      "SIGPWR", "SIGSYS",
    }

    local sig = sigs[code - 128]
    if sig then
      last_line = "# command exited by " .. sig
    else
      last_line = "# command exited with code " .. code
    end
  end

  local need_scroll = job.autoscroll and vim.fn.line(".") == vim.fn.line("$")
  vim.fn.setqflist({}, "a", {
    title = job.cmd .. "  (done)",
    lines = { " ", last_line },
  })

  if need_scroll then
    vim.cmd("cbottom")
  end

  job.id = -1
  job.last_line = ""
  job.started = nil
  job.files_only = false
end

function M.terminate()
  if job.id > 0 then
    vim.fn.jobstop(job.id)
  end
end

function M.exec(command, autoscroll, files_only)
  M.terminate()

  job.cmd = table.concat(command, " ")
  job.last_line = ""
  job.autoscroll = autoscroll
  job.files_only = files_only or false

  job.id = vim.fn.jobstart(command, {
    on_exit = on_job_exit,
    on_stdout = on_job_output,
    on_stderr = on_job_output,
  })

  if job.id <= 0 then
    error("Failed to start job: " .. job.cmd)
  end

  job.started = vim.fn.reltime()
  vim.fn.setqflist({}, "r", {
    title = job.cmd .. " (running)",
    lines = {},
  })

  vim.cmd("copen")
end

-- Ctrl-C to terminate job in quickfix
vim.api.nvim_create_augroup("Quickfix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "Quickfix",
  pattern = "qf",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<C-c>", "", {
      callback = M.terminate,
      desc = "Terminate running quickfix command",
    })
  end,
})

return M
