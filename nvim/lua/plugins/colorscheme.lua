-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },
  {
    "catppuccin",
    opts = {
      custom_highlights = function(colors)
        return {
          LspInlayHint = {
            fg = colors.overlay0, -- gris discret, fondu dans le fond
            bg = "NONE", -- pas de pastille/bordure
            style = { "italic" }, -- différencie du code réel sans attirer l'œil
          },
        }
      end,
    },
  },
}
