local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

---@diagnostic disable-next-line: missing-fields
---@type LazyConfig
local lazy_config = {
  spec = {
    { import = "plugins" },
  },
  install = {
    colorscheme = { "nord" },
  },
  dev = {
    path = "~/dev",
    patterns = { "brw" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  profiling = {
    loader = true,
    require = true,
  },
}

---@diagnostic disable-next-line: undefined-field
require("lazy").setup(lazy_config)
