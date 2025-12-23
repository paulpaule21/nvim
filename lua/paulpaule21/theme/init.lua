-- FULL UPDATED THEME ENGINE WITH GITHUB LIGHT PALETTE (OPTION B)
-- This file completely replaces your previous theme engine.
-- Only the LIGHT theme uses GitHub Light official colors.
-- Dark theme stays as-is.
-- Theme enforcing is enabled so plugins cannot override your colors.

local M = {}

-------------------------------------------------------------------------------
-- PALETTES (Dark unchanged, Light = GitHub Light Default OFFICIAL)
-------------------------------------------------------------------------------
M.palettes = {
  -----------------------------------------------------------------------------
  -- DARK THEME (unchanged)
  -----------------------------------------------------------------------------
  dark = {
    bg = "#24283b",
    bg_alt = "#1f2335",
    bg_high = "#292e42",

    -- Text
    fg = "#c8d3f5",      -- soft light gray
    fg_dark = "#a5b0d4", -- dimmer
    fg_dim = "#5b6391",  -- comments / inactive

    -- Comments
    comment = "#5b6391",

    -- Code coloring
    strings = "#e1eaa0",       -- pale yellow-green
    constant = "#ff9e64",      -- orange
    object = "#7dcfff",        -- light cyan
    keyword_lilac = "#c792ea", -- purple
    keyword_pink = "#f7768e",  -- pink
    function_blue = "#82aaff", -- soft light blue function color
    type = "#ffffff",

    -- Diagnostics
    error = "#ff5370",
    warn = "#ffcb6b",
    info = "#82aaff",
    hint = "#01b4ce",

    -- UI
    accent = "#82aaff",
    accent_alt = "#7dcfff",
    float_bg = "#0b1120",
    float_border = "#1d2c43",
    visual_bg = "#24364c", -- selection highlight

    -- Git signs
    git_add = "#4fd6be",
    git_change = "#ffcb6b",
    git_delete = "#ff5370",
  },

  -----------------------------------------------------------------------------
  -- LIGHT THEME — GITHUB LIGHT DEFAULT (Official Colors)
  -----------------------------------------------------------------------------
  light = {
    -- Base background layers
    bg = "#ffffff",      -- main editor
    bg_alt = "#f6f8fa",  -- sidebars, menus
    bg_high = "#eaeef2", -- cursorline, highlights

    -- Foregrounds
    fg = "#24292f",      -- main text
    fg_dark = "#1b1f24", -- headings, stronger
    fg_dim = "#6e7781",  -- inactive, comments
    strings = "#0a3069", -- dark navy

    -- Comments
    comment = "#6e7781",

    -- Official GitHub diagnostic colors
    error = "#cf222e", -- red
    warn = "#d4a72c",  -- yellow
    info = "#0969da",  -- blue
    hint = "#1a7f37",  -- green

    -- Accents
    accent = "#0969da",     -- GitHub blue
    accent_alt = "#218bff", -- bright blue

    -- UI
    float_bg = "#ffffff",
    float_border = "#d0d7de", -- subtle border
    visual_bg = "#ddf4ff",    -- selection highlight

    -- Code colors
    constant = "#953800", -- GitHub orange
    object = "#0550ae",   -- blue objects

    -- Keywords
    keyword_lilac = "#8250df",
    keyword_pink = "#cf222e",

    -- GitHub additional fields
    border_soft = "#d0d7de",
    border_hard = "#8c959f",
    git_add = "#1a7f37",
    git_change = "#d4a72c",
    git_delete = "#cf222e",

    function_blue = "#5973AE", -- REPLACE with your desired function color
    type = "#000000",
  },
}

-------------------------------------------------------------------------------
-- HELPER FUNCTION
-------------------------------------------------------------------------------
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function applyOverride(palette, overrides)
  if not overrides then
    return
  end
  for group, opts in pairs(overrides) do
    hl(group, opts)
  end
end

local function applyTransparency(p)
  p.bg = "NONE"
  p.bg_alt = "NONE"
  p.bg_high = "NONE"
  p.float_bg = "NONE"
end

-------------------------------------------------------------------------------
-- BASE UI
-------------------------------------------------------------------------------
local function applyBase(p)
  hl("Normal", { fg = p.fg, bg = p.bg })
  hl("NormalFloat", { fg = p.fg, bg = p.float_bg })
  hl("FloatBorder", { fg = p.float_border, bg = p.float_bg })

  hl("LineNr", { fg = p.fg_dim })
  hl("CursorLineNr", { fg = p.accent })
  hl("CursorLine", { bg = p.bg_high })
  hl("Visual", { bg = p.visual_bg })

  hl("Comment", { fg = p.comment, italic = true })

  hl("Pmenu", { fg = p.fg, bg = p.bg_alt })
  hl("PmenuSel", { bg = p.bg_high })

  hl("WinSeparator", { fg = p.border_soft })

  hl("DiagnosticError", { fg = p.error })
  hl("DiagnosticWarn", { fg = p.warn })
  hl("DiagnosticInfo", { fg = p.info })
  hl("DiagnosticHint", { fg = p.hint })
end

-------------------------------------------------------------------------------
-- TREESITTER
-------------------------------------------------------------------------------

local function applyTreesitter(p)
  -- Comments
  hl("@comment", { fg = p.comment, italic = true })

  -- Strings (GitHub = dark navy)
  hl("@string", { fg = p.strings })

  -- Numbers / Constants = GitHub dark orange
  hl("@number", { fg = p.constant })
  hl("@constant", { fg = p.constant })
  hl("@constant.builtin", { fg = p.hint })

  -- Keywords = GitHub red
  hl("@keyword", { fg = p.keyword_lilac })

  -- Types (struct, interface, custom types) = GitHub purple
  hl("@type", { fg = p.type })
  hl("@type.builtin", { fg = p.hint }) -- NEW (makes map, string, int32 green)

  -- Functions (definitions + calls) = BLACK (GitHub uses plain text color)
  hl("@function", { fg = p.function_blue })
  hl("@function.call", { fg = p.function_blue })
  hl("@method", { fg = p.function_blue })
  hl("@method.call", { fg = p.function_blue })
  hl("@function.builtin.go", { fg = p.hint })

  -- Variables = Black
  hl("@variable", { fg = p.fg })
  hl("@variable.builtin", { fg = p.fg })

  -- Fields / Properties = Black (GitHub does NOT use blue)
  hl("@field", { fg = p.fg })
  hl("@property", { fg = p.fg })
  hl("@variable.member", { fg = p.fg })

  -- Imports / Module paths = GitHub blue
  hl("@module", { fg = p.accent })
  hl("@namespace", { fg = p.accent })

  -- Operators = plain text color (black)
  hl("@operator", { fg = p.fg })

  -- Punctuation
  hl("@punctuation", { fg = p.fg_dark })
  hl("@punctuation.bracket", { fg = p.fg_dark })
  hl("@punctuation.delimiter", { fg = p.fg_dark })
end

-------------------------------------------------------------------------------
-- PLUGINS (GitHub-Light styled)
-------------------------------------------------------------------------------
local function applyPlugins(p)
  -- Telescope
  hl("TelescopeNormal", { bg = p.float_bg, fg = p.fg })
  hl("TelescopeBorder", { bg = p.float_bg, fg = p.border_soft })
  hl("TelescopeSelection", { bg = p.bg_high })
  hl("TelescopeMatching", { fg = p.accent_alt, bold = true })

  -- GitSigns
  hl("GitSignsAdd", { fg = p.git_add })
  hl("GitSignsChange", { fg = p.git_change })
  hl("GitSignsDelete", { fg = p.git_delete })

  -- NvimTree (GitHub-like sidebar)
  hl("NvimTreeNormal", { fg = p.fg, bg = p.bg_alt })
  hl("NvimTreeNormalNC", { fg = p.fg, bg = p.bg_alt })
  hl("NvimTreeFolderIcon", { fg = p.accent_alt })
  hl("NvimTreeFolderName", { fg = p.fg })
  hl("NvimTreeOpenedFolderName", { fg = p.accent, bold = true })
  hl("NvimTreeRootFolder", { fg = p.accent, bold = true })
  hl("NvimTreeIndentMarker", { fg = p.fg_dim })
  hl("NvimTreeGitDirty", { fg = p.git_change })
  hl("NvimTreeGitNew", { fg = p.git_add })
  hl("NvimTreeGitDeleted", { fg = p.git_delete })
  hl("NvimTreeCursorLine", { bg = p.bg_high })
end

-------------------------------------------------------------------------------
-- FORCE THEME AFTER PLUGINS LOAD
-------------------------------------------------------------------------------
local function enforceTheme(name, opts)
  vim.api.nvim_create_autocmd({
    "ColorScheme",
    "BufWinEnter",
    "UIEnter",
    "LspAttach",
    "WinNew",
    "VimResume",
  }, {
    callback = function()
      M.apply_theme(name, opts)
    end,
  })
end

-------------------------------------------------------------------------------
-- MAIN APPLY
-------------------------------------------------------------------------------
function M.apply_theme(name, opts)
  opts = opts or {}
  local base = M.palettes[name]
  if not base then
    vim.notify("Theme '" .. name .. "' does not exist", vim.log.levels.ERROR)
    return
  end

  local p = vim.deepcopy(base)
  if opts.transparent then
    applyTransparency(p)
  end

  vim.cmd("highlight clear")
  vim.cmd("syntax reset")

  applyBase(p)
  applyTreesitter(p)
  applyPlugins(p)
  applyOverride(p, opts.override)

  vim.g.paulpaule21_current_theme = name
end

-------------------------------------------------------------------------------
-- PUBLIC SETUP
-------------------------------------------------------------------------------
function M.setup(opts)
  opts = opts or {}
  local theme = opts.theme or "dark"

  M._opts = opts
  M.apply_theme(theme, opts)
  enforceTheme(theme, opts)

  vim.api.nvim_create_user_command("Theme", function(cmd)
    M.apply_theme(cmd.args, M._opts)
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(M.palettes)
    end,
  })
end

return M
