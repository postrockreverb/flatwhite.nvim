-- flatwhite.nvim
-- A flat, warm, light Neovim colorscheme. No dependencies.
--
-- This is a hand-written port of the original Lush-based `flatwhite` theme,
-- with the `lush.nvim` dependency removed.

local M = {}

M.palette = require("flatwhite.palette")

-- Build the highlight-group table from a palette.
-- Kept as a function so it's easy to derive variants later if wanted.
function M.highlights(p)
  return {
    -- UI ---------------------------------------------------------------------
    Cursor        = { fg = p.base1, bg = p.base7, reverse = true },
    CurSearch     = { fg = p.orange_text, bg = p.orange_bg },
    Directory     = { bold = true },
    FoldColumn    = { fg = p.base4 },
    SignColumn    = { fg = p.base4 },
    LineNr        = { fg = p.base3 },
    MatchParen    = { fg = p.orange_text, bg = p.orange_bg },
    Normal        = { fg = p.base1, bg = p.base7 },
    NormalFloat   = { bg = p.base5 },
    QuickFixLine  = { fg = p.orange_text, bg = p.orange_bg },
    Search        = { fg = p.orange_text, bg = p.orange_bg },
    StatusLine    = { bg = p.base5 },
    StatusLineNC  = { bg = p.base6 },
    Visual        = { fg = p.base6, bg = p.base2 },

    -- Syntax -----------------------------------------------------------------
    String        = { fg = p.green_text, bg = p.green_bg },
    Identifier    = { fg = p.base1 },
    Function      = { bold = true },
    Statement     = { fg = p.purple_text, bg = p.purple_bg },
    Operator      = {}, -- cleared: renders like Normal
    Special       = {}, -- cleared: renders like Normal
    Delimiter     = { bold = true },

    -- Tree-sitter ------------------------------------------------------------
    ["@constant.builtin"] = { fg = p.blue_text, bg = p.blue_bg },
    ["@variable"]         = {}, -- cleared: renders like Normal
    ["@type"]             = {}, -- cleared: renders like Normal
    ["@module"]           = { fg = p.teal_text, bg = p.teal_bg },
  }
end

function M.setup()
  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.background = "light"
  vim.g.colors_name = "flatwhite"

  local set_hl = vim.api.nvim_set_hl
  for group, spec in pairs(M.highlights(M.palette)) do
    set_hl(0, group, spec)
  end
end

return M
