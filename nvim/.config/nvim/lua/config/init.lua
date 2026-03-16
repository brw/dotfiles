-- autocmds can be loaded lazily when not opening a file
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require("config.autocmds")
end

local group = vim.api.nvim_create_augroup("SetupVeryLazy", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  callback = function()
    if lazy_autocmds then
      require("config.autocmds")
    end
    require("config.keymaps")
  end,
})

require("config.lazy")
