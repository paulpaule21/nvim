return {
  "paulpaule21/life.nvim",
  dependencies = {
    "nvim-orgmode/orgmode",
    "chipsenkbeil/org-roam.nvim",
  },
  config = function()
    require("org-roam").setup({
      directory = "~/.notes/roam",
      templates = {
        i = {
          description = "Idea",
          template = require("life.templates").quick_capture(),
          target = "ideas/%[slug].org",
        },
        j = {
          description = "Daily Journal",
          template = require("life.templates").daily_journal(),
          target = "journal/%<%Y-%m-%d>.org",
        },
        w = {
          description = "Weekly Review",
          template = require("life.templates").weekly_review(),
          target = "reviews/weekly/%<%Y-W%V>.org",
        },
        m = {
          description = "Monthly Review",
          template = require("life.templates").monthly_review(),
          target = "reviews/monthly/%<%Y-%m>.org",
        },
        y = {
          description = "Yearly Review",
          template = require("life.templates").yearly_review(),
          target = "reviews/yearly/%<%Y>.org",
        },
        p = {
          description = "Person",
          template = require("life.templates").person_note(),
          target = "people/%[slug].org",
        },
      },
    })
  end,
}

