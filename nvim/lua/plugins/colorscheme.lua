return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm", -- ou "night", "moon", "day"
      on_highlights = function(hl, c)
        hl.Function = { fg = c.green }
        hl["@function"] = { fg = c.green }
        hl["@function.call"] = { fg = c.green }
        hl.Keyword = { fg = c.green1 }
        hl["@keyword"] = { fg = c.green1 }
        hl.String = { fg = c.green2 }
        hl["@string"] = { fg = c.green2 }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
