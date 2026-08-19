-- ~/.config/nvim/lua/plugins/latex-luasnip.lua
return {
  "L3MON4D3/LuaSnip",
  config = function(_, opts)
    require("luasnip").setup(opts)
    require("luasnip").config.setup({ enable_autosnippets = true })
  end,
}
