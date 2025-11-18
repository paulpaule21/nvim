-- ========================================================================
-- paulgolde.theme: Complete Theme Engine
-- ========================================================================

local M = {}

---------------------------------------------------------------------------
-- PALETTES
---------------------------------------------------------------------------

M.palettes = {
  dark = {
    -- TokyoNight Storm core colors
    bg = "#24283b",      -- main background
    bg_alt = "#1f2335",  -- sidebar / floats
    bg_high = "#292e42", -- cursorline, visual selection

    -- Foreground
    fg = "#c0caf5",      -- main text
    fg_dark = "#a9b1d6", -- punctuation, namespaces
    fg_dim = "#565f89",  -- subtle text

    -- Comments
    comment = "#565f89",

    -- TokyoNight diagnostics
    error = "#f7768e",
    warn = "#e0af68",
    info = "#7aa2f7",
    hint = "#9ece6a",

    -- Accents (core TokyoNight)
    accent = "#7aa2f7",     -- purple
    accent_alt = "#7aa2f7", -- blue

    -- UI elevations
    float_bg = "#1f2335",
    float_border = "#3b4261",

    -- Visual selection color
    visual_bg = "#3b4261",
  },
  light = {
    -- Blue-gray Tokyo × Nordic × ergonomic
    bg = "#f2f4f7",      -- main background (soft, no glare)
    bg_alt = "#e8ecf2",  -- sidebars, floats
    bg_high = "#d7dde6", -- cursorline, selected areas

    fg = "#2a2f3a",      -- main text
    fg_dark = "#1b1f27", -- strong identifiers / namespaces
    fg_dim = "#606b80",  -- comments & low-contrast text

    comment = "#7b8697", -- subdued but readable

    -- Diagnostics (light-theme safe)
    error = "#d9534f", -- red but not neon
    warn = "#c7851f",  -- warm amber
    info = "#1e78c7",  -- Tokyo-ish blue
    hint = "#3f8f3a",  -- Nordic green

    -- Accents (mapped to dark theme hues)
    accent = "#7d4cc2",     -- analogous to dark.c099ff (functions)
    accent_alt = "#2d7bba", -- analogous to dark.65bcff (strings)

    -- New UI additions
    float_bg = "#eef1f6",
    float_border = "#cfd6e2",
    visual_bg = "#c6d2e3", -- visual mode selection
  },
}

---------------------------------------------------------------------------
-- BASE EDITOR UI
---------------------------------------------------------------------------

local function apply_base(p)
  local set = vim.api.nvim_set_hl

  set(0, "Normal", { fg = p.fg, bg = p.bg })
  set(0, "NormalFloat", { fg = p.fg, bg = p.float_bg })
  set(0, "FloatBorder", { fg = p.float_border, bg = p.float_bg })

  set(0, "LineNr", { fg = p.fg_dim })
  set(0, "CursorLine", { bg = p.bg_high })
  set(0, "CursorLineNr", { fg = p.accent })
  set(0, "Visual", { bg = p.visual_bg })

  set(0, "Search", { bg = p.accent_alt, fg = p.bg })
  set(0, "IncSearch", { bg = p.accent, fg = p.bg })

  set(0, "Pmenu", { bg = p.bg_alt, fg = p.fg })
  set(0, "PmenuSel", { bg = p.bg_high })

  set(0, "Comment", { fg = p.comment, italic = true })
  set(0, "WinSeparator", { fg = p.float_border })

  -- Diagnostics
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
-- TREESITTER SYNTAX
---------------------------------------------------------------------------

local function apply_treesitter(p)
  local set = vim.api.nvim_set_hl

  set(0, "@comment", { link = "Comment" })

  set(0, "@string", { fg = p.accent_alt })
  set(0, "@number", { fg = p.warn })
  set(0, "@boolean", { fg = p.warn })

  -- ===============================
  -- TOKYONIGHT STORM KEYWORD COLORS
  -- ===============================

  -- 1) Logic / control keywords → lilac
  set(0, "@keyword", { fg = "#bb9af7" })          -- func, return, if, switch, case
  set(0, "@keyword.function", { fg = "#bb9af7" }) -- func
  set(0, "@keyword.operator", { fg = "#bb9af7" }) -- in, as, etc.

  -- 2) Structure / declaration keywords → pinkish
  set(0, "@keyword.type", { fg = "#f7768e" })      -- type, struct, interface
  set(0, "@keyword.import", { fg = "#f7768e" })    -- import, package
  set(0, "@keyword.storage", { fg = "#f7768e" })   -- var, const
  set(0, "@keyword.repeat", { fg = "#f7768e" })    -- for, range
  set(0, "@keyword.coroutine", { fg = "#bb9af7" }) -- go, defer (Tokyonight lilac)

  -- switch-case (not always isolated TS groups)
  set(0, "@conditional", { fg = "#bb9af7" })      -- if, switch
  set(0, "@conditional.loop", { fg = "#f7768e" }) -- for, range

  -- Object fields, props, member access (teal)
  set(0, "@property", { fg = "#7dcfff" })
  set(0, "@field", { fg = "#7dcfff" })
  set(0, "@variable.member", { fg = "#7dcfff" }) -- JS/TS/Lua/etc.
  set(0, "@method.call", { fg = "#7dcfff" })     -- method calls also teal

  -- Functions & builtin functions (match TokyoNight Storm)
  set(0, "@function", { fg = p.accent_alt, bold = false })
  set(0, "@function.builtin", { fg = p.accent_alt, bold = false })

  -- Types unchanged
  set(0, "@type", { fg = p.fg_dark })

  -- Constants (orange, match screenshot exactly)
  set(0, "@constant", { fg = "#ff9e64" })
  set(0, "@constant.builtin", { fg = "#ff9e64" })
  set(0, "@constant.macro", { fg = "#ff9e64" })

  -- Storm punctuation = purple
  set(0, "@punctuation", { fg = p.accent })
  set(0, "@punctuation.bracket", { fg = p.accent })
end

---------------------------------------------------------------------------
-- PLUGINS UI (Telescope, NvimTree, CMP, GitSigns)
---------------------------------------------------------------------------

local function apply_plugins(p)
  local set = vim.api.nvim_set_hl

  ---------------------------------------------------------------------------
  -- Telescope (Storm)
  ---------------------------------------------------------------------------
  set(0, "TelescopeNormal", { bg = p.float_bg, fg = p.fg })
  set(0, "TelescopeBorder", { bg = p.float_bg, fg = p.float_border })
  set(0, "TelescopePromptNormal", { bg = p.bg_alt, fg = p.fg })
  set(0, "TelescopePromptBorder", { bg = p.bg_alt, fg = p.float_border })
  set(0, "TelescopeSelection", { bg = p.bg_high, fg = p.fg })
  set(0, "TelescopeMatching", { fg = p.accent_alt, bold = true })

  ---------------------------------------------------------------------------
  -- CMP
  ---------------------------------------------------------------------------
  set(0, "CmpItemKind", { fg = p.accent })
  set(0, "CmpItemAbbrMatch", { fg = p.info })

  ---------------------------------------------------------------------------
  -- GitSigns
  ---------------------------------------------------------------------------
  set(0, "GitSignsAdd", { fg = p.hint })
  set(0, "GitSignsChange", { fg = p.warn })
  set(0, "GitSignsDelete", { fg = p.error })

  ---------------------------------------------------------------------------
  -- NvimTree
  ---------------------------------------------------------------------------
  set(0, "NvimTreeNormal", { bg = p.bg_alt, fg = p.fg })
  set(0, "NvimTreeRootFolder", { fg = p.accent, bold = true })
  set(0, "NvimTreeFolderName", { fg = p.fg })
  set(0, "NvimTreeOpenedFolderName", { fg = p.info })

  set(0, "StatusLine", { bg = p.bg_alt, fg = p.fg })

  -- Punctuation (general)
  set(0, "@punctuation.special", { fg = p.accent_alt })
end

---------------------------------------------------------------------------
-- FULL TOKYONIGHT UI LAYER (Storm)
---------------------------------------------------------------------------

local function apply_tokyo_ui(p)
  local set = vim.api.nvim_set_hl

  -- Statusline / Tabline
  set(0, "StatusLine", { fg = p.fg, bg = p.bg_alt })
  set(0, "StatusLineNC", { fg = p.fg_dim, bg = p.bg_alt })

  set(0, "TabLine", { fg = p.fg_dim, bg = p.bg_alt })
  set(0, "TabLineFill", { fg = p.fg, bg = p.bg })
  set(0, "TabLineSel", { fg = p.fg, bg = p.bg_high, bold = true })

  -- Popup
  set(0, "PmenuSbar", { bg = p.bg_high })
  set(0, "PmenuThumb", { bg = p.fg_dim })

  -- Matching
  set(0, "MatchParen", { fg = p.accent_alt, bold = true })

  -- Folds
  set(0, "Folded", { fg = p.fg_dim, bg = p.bg_alt })
  set(0, "FoldColumn", { fg = p.fg_dim, bg = p.bg })

  -- Diff
  set(0, "DiffAdd", { bg = "#2f3333" })
  set(0, "DiffChange", { bg = "#252a3f" })
  set(0, "DiffDelete", { bg = "#3f2d3d" })
  set(0, "DiffText", { bg = "#394b70" })

  -- LSP references
  set(0, "LspReferenceText", { bg = p.bg_high })
  set(0, "LspReferenceRead", { bg = p.bg_high })
  set(0, "LspReferenceWrite", { bg = p.bg_high })
end

---------------------------------------------------------------------------
-- GO-SPECIFIC SEMANTIC HIGHLIGHTING (Your custom logic preserved)
---------------------------------------------------------------------------

local function apply_go_semantics(p)
  local set = vim.api.nvim_set_hl

  set(0, "@namespace.go", { fg = p.fg_dark, bold = true })
  set(0, "@type.qualifier.go", { fg = p.fg_dark, bold = true })
  set(0, "@operator.pointer.go", { fg = p.fg })
  set(0, "@type.pointer.go", { fg = p.fg, bold = true })
  set(0, "@field.go", { fg = "#7dcfff" })
  set(0, "@variable.member.go", { fg = "#7dcfff" })
  set(0, "@variable.member.exported.go", { fg = "#7dcfff", bold = true })
  set(0, "@function.exported.go", { fg = p.accent, bold = true })
  set(0, "@type.exported.go", { fg = p.accent_alt, bold = true })

  set(0, "@variable.builtin.error.go", { fg = p.error, bold = true })
  set(0, "@operator.error_compare.go", { fg = p.error, bold = true })
  -- Go: func keyword (lilac)
  set(0, "@keyword.function.go", { fg = "#bb9af7", bold = false })

  -- Go: return (lilac)
  set(0, "@keyword.return.go", { fg = "#bb9af7" })

  -- Go: if, switch, case (lilac)
  set(0, "@keyword.conditional.go", { fg = "#bb9af7" })

  -- Go: var, const, type, struct, interface (pinkish)
  set(0, "@keyword.type.go", { fg = "#f7768e" })
  set(0, "@keyword.storage.go", { fg = "#f7768e" })

  -- Go: for, range (pinkish)
  set(0, "@keyword.repeat.go", { fg = "#f7768e" })

  set(0, "@keyword.return.error.go", { fg = p.error, bold = true })

  set(0, "@variable.unused.go", { fg = p.error, underline = true })
  set(0, "@variable.parameter.unused.go", { fg = p.error, underline = true })

  set(0, "@type.builtin.go", { fg = p.hint })
  set(0, "@function.go", {
    fg = p.accent_alt,
    bold = false, -- to match TokyoNight exactly
  })
  set(0, "@method.call.go", { fg = p.accent_alt })
end

---------------------------------------------------------------------------
-- APPLY ALL
---------------------------------------------------------------------------

function M.apply(palette)
  vim.cmd("highlight clear")
  vim.cmd("syntax reset")

  apply_base(palette)
  apply_treesitter(palette)
  apply_plugins(palette)
  apply_tokyo_ui(palette)
  apply_go_semantics(palette)

  vim.g.paulgolde_current_theme = palette.name
end

---------------------------------------------------------------------------
-- LOAD
---------------------------------------------------------------------------

function M.load(name)
  if name == "tokyo" then
    vim.cmd("colorscheme tokyonight")
    vim.g.paulgolde_current_theme = "tokyo"
    return
  end

  local p = vim.deepcopy(M.palettes[name])
  p.name = name

  M.apply(p)
end

---------------------------------------------------------------------------
-- AUTOLOAD ON STARTUP
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
-- :Theme COMMAND
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
