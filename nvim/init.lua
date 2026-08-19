-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.env.PATH = vim.env.PATH:gsub(vim.fn.expand("~/.local/share/nvim/mason/bin") .. ":?", "")
  end,
})
