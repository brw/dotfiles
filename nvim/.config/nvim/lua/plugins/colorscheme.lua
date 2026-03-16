---@type LazySpec
return {
  "gbprod/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("nord").setup({
      diff = {
        mode = "fg",
      },
      errors = {
        mode = "none", -- doesn't seem to do anything?
      },
      on_highlights = function(hi, c)
        -- hi.DiffAdd = vim.tbl_extend("force", hi.DiffAdd, { bg = "" })
        -- hi.DiffDelete = vim.tbl_extend("force", hi.DiffDelete, { bg = "" })
        -- hi.DiffChange = vim.tbl_extend("force", hi.DiffChange, { bg = "" })
        -- hi.DiffText = vim.tbl_extend("force", hi.DiffText, { bg = "" })
      end,
    })
    vim.cmd.colorscheme("nord")
  end,
}
