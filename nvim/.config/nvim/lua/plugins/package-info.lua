---@type LazySpec
return {
  "vuki656/package-info.nvim",
  enabled = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local nord = require("nord.colors").palette

    require("package-info").setup({
      colors = {
        up_to_date = nord.polar_night.origin,
        outdated = nord.aurora.orange,
        error = nord.aurora.error,
      },
    })

    -- https://github.com/vuki656/package-info.nvim/issues/155
    vim.api.nvim_set_hl(0, "PackageInfoUpToDate", { fg = nord.polar_night.origin })
    vim.api.nvim_set_hl(0, "PackageInfoOutdated", { fg = nord.aurora.orange })
    vim.api.nvim_set_hl(0, "PackageInfoError", { fg = nord.aurora.error })
  end,
}
