local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

vim.g.nord_borders = true -- border between splits
vim.g.nord_italic = false
vim.g.nord_bold = false

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = {
    colorscheme = { "nord" },
  },
  checker = {
    enabled = true,
  },
})
