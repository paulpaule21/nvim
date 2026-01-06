return {
  "paulpaule21/life.nvim",
  dependencies = {
    "nvim-orgmode/orgmode",
    "chipsenkbeil/org-roam.nvim",
  },
  config = function()
    require("life").setup({
      leader = "<Leader>l",

      notes_dir = "~/.notes",
      roam_dir = "~/.notes/roam",
      journal_dir = "~/.notes/journal",
      tasks_dir = "~/.notes/tasks",
      reviews_dir = "~/.notes/reviews",

      enable_agenda_on_start = true,
    })
  end,
}

