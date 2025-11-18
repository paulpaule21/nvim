-- ========================================================================
-- paulgolde.theme: Complete Theme Engine
-- ========================================================================

local M = {}

---------------------------------------------------------------------------
-- PALETTES
---------------------------------------------------------------------------

M.palettes = {
  dark = {
    -- Nordic × TokyoNight × ergonomics
    bg = "#1a1b26",
    bg_alt = "#161722",
    bg_high = "#232433",

    fg = "#c7d1e6",
    fg_dark = "#8fa0b8",
    fg_dim = "#9caac2",

    comment = "#5c6f8f",

    error = "#f7768e",
    warn = "#e0af68",
    info = "#7dcfff",
    hint = "#9ece6a",

    accent = "#ffb454",
    accent_alt = "#e6a043",
  },

  light = {
    -- Ergonomic, medium contrast, no glare
    bg = "#f6f7f9",
    bg_alt = "#eef1f4",
    bg_high = "#e0e4e8",

    fg = "#2a303b",
    fg_dark = "#1b2027",
    fg_dim = "#505868",

    comment = "#6c7380",

    error = "#c53030",
    warn = "#b7791f",
    info = "#0a75bb",
    hint = "#3f8f2f",

    accent = "#c87b00",
    accent_alt = "#a56800",
  },
}

---------------------------------------------------------------------------
-- APPLY BASE HIGHLIGHTS
---------------------------------------------------------------------------

local function apply_base(p)
  local set = vim.api.nvim_set_hl

  -- Core editor
  set(0, "Normal", { fg = p.fg, bg = p.bg })
  set(0, "NormalFloat", { fg = p.fg, bg = p.bg_alt })
  set(0, "FloatBorder", { fg = p.fg_dim, bg = p.bg_alt })
  set(0, "LineNr", { fg = p.fg_dim })
  set(0, "CursorLine", { bg = p.bg_high })
  set(0, "CursorLineNr", { fg = p.accent })
  set(0, "Visual", { bg = p.bg_high })
  set(0, "Search", { bg = p.accent_alt, fg = p.bg })
  set(0, "IncSearch", { bg = p.accent, fg = p.bg })
  set(0, "Pmenu", { bg = p.bg_alt, fg = p.fg })
  set(0, "PmenuSel", { bg = p.bg_high })
  set(0, "WinSeparator", { fg = p.bg_high })
  set(0, "Comment", { fg = p.comment, italic = true })

  -- Errors & warnings
  set(0, "DiagnosticError", { fg = p.error })
  set(0, "DiagnosticWarn", { fg = p.warn })
  set(0, "DiagnosticInfo", { fg = p.info })
  set(0, "DiagnosticHint", { fg = p.hint })

  set(0, "DiagnosticUnderlineError", { undercurl = true, sp = p.error })
  set(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = p.warn })
  set(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = p.info })
  set(0, "DiagnosticUnderlineHint", { undercurl = true, sp = p.hint })
end

---------------------------------------------------------------------------
-- TREESITTER
---------------------------------------------------------------------------

local function apply_treesitter(p)
  local set = vim.api.nvim_set_hl

  set(0, "@comment", { link = "Comment" })
  set(0, "@string", { fg = p.accent_alt })
  set(0, "@number", { fg = p.accent })
  set(0, "@boolean", { fg = p.accent })
  set(0, "@keyword", { fg = p.info })
  set(0, "@keyword.function", { fg = p.info })
  set(0, "@variable", { fg = p.fg })
  set(0, "@variable.builtin", { fg = p.accent })
  set(0, "@function", { fg = p.hint })
  set(0, "@function.builtin", { fg = p.hint })
  set(0, "@type", { fg = p.fg_dark })
  set(0, "@constant", { fg = p.warn })
end

---------------------------------------------------------------------------
-- PLUGINS
---------------------------------------------------------------------------

local function apply_plugins(p)
  local set = vim.api.nvim_set_hl

  -- Telescope
  set(0, "TelescopeNormal", { bg = p.bg_alt, fg = p.fg })
  set(0, "TelescopeBorder", { bg = p.bg_alt, fg = p.bg_high })
  set(0, "TelescopeSelection", { bg = p.bg_high })
  set(0, "TelescopeMatching", { fg = p.accent })

  -- CMP
  set(0, "CmpItemKind", { fg = p.accent })
  set(0, "CmpItemAbbrMatch", { fg = p.info })

  -- GitSigns
  set(0, "GitSignsAdd", { fg = p.hint })
  set(0, "GitSignsChange", { fg = p.warn })
  set(0, "GitSignsDelete", { fg = p.error })

  -- NvimTree
  set(0, "NvimTreeNormal", { bg = p.bg_alt, fg = p.fg })
  set(0, "NvimTreeRootFolder", { fg = p.accent, bold = true })
  set(0, "NvimTreeFolderName", { fg = p.fg })
  set(0, "NvimTreeOpenedFolderName", { fg = p.info })

  -- Statusline (you can override later in lualine)
  set(0, "StatusLine", { bg = p.bg_alt, fg = p.fg })
end

---------------------------------------------------------------------------
-- MAIN APPLY FUNCTION
---------------------------------------------------------------------------

function M.apply(palette)
  vim.cmd("highlight clear")
  vim.cmd("syntax reset")

  apply_base(palette)
  apply_treesitter(palette)
  apply_plugins(palette)

  -- Store for persistence
  vim.g.paulgolde_current_theme = palette.name
end

---------------------------------------------------------------------------
-- LOAD THEME
---------------------------------------------------------------------------

function M.load(name)
  if name == "tokyo" then
    vim.cmd("colorscheme tokyonight")
    vim.g.paulgolde_current_theme = "tokyo"
    return
  end

  local palette = vim.deepcopy(M.palettes[name])
  palette.name = name

  M.apply(palette)
end

---------------------------------------------------------------------------
-- RESTORE ON STARTUP
---------------------------------------------------------------------------

function M.setup_autoload()
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local theme = vim.g.paulgolde_current_theme or "dark"
      require("paulgolde.theme").load(theme)
    end,
  })
end

---------------------------------------------------------------------------
-- USER COMMANDS
---------------------------------------------------------------------------

vim.api.nvim_create_user_command("Theme", function(opts)
  require("paulgolde.theme").load(opts.args)
end, {
  nargs = 1,
  complete = function()
    return { "dark", "light", "tokyo" }
  end,
})

---------------------------------------------------------------------------
return M
