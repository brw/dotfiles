---@diagnostic disable: missing-fields
---@type LazySpec
return {
  "romgrk/barbar.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  keys = {
    { "<M-.>", "<Cmd>BufferNext<CR>", desc = "Buffer next" },
    { "<M-,>", "<Cmd>BufferPrevious<CR>", desc = "Buffer previous" },
    { "<M-d>", "<Cmd>BufferClose!<CR>", desc = "Buffer close" },
    { "<M-s-d>", "<Cmd>BufferRestore<CR>", desc = "Buffer restore" },
    { "<M-<>", "<Cmd>BufferMovePrevious<CR>", desc = "Buffer move previous" },
    { "<M->>", "<Cmd>BufferMoveNext<CR>", desc = "Buffer move next" },
    { "<M-p", "<Cmd>BufferPin<CR>", desc = "Buffer pin" },
    { "<C-p>", "<Cmd>BufferPick<CR>", desc = "Buffer pick" },
    { "<M-1>", "<Cmd>BufferGoto 1<CR>", desc = "Buffer goto 1" },
    { "<M-2>", "<Cmd>BufferGoto 2<CR>", desc = "Buffer goto 2" },
    { "<M-3>", "<Cmd>BufferGoto 3<CR>", desc = "Buffer goto 3" },
    { "<M-4>", "<Cmd>BufferGoto 4<CR>", desc = "Buffer goto 4" },
    { "<M-5>", "<Cmd>BufferGoto 5<CR>", desc = "Buffer goto 5" },
    { "<M-6>", "<Cmd>BufferGoto 6<CR>", desc = "Buffer goto 6" },
    { "<M-7>", "<Cmd>BufferGoto 7<CR>", desc = "Buffer goto 7" },
    { "<M-8>", "<Cmd>BufferGoto 8<CR>", desc = "Buffer goto 8" },
    { "<M-9>", "<Cmd>BufferGoto 9<CR>", desc = "Buffer goto 9" },
    { "<M-0>", "<Cmd>BufferLast<CR>", desc = "Buffer goto last" },
  },
  ---@type barbar.config.options
  opts = {
    auto_hide = 1,
    focus_on_close = "previous",
    no_name_title = "new",
  },
}
