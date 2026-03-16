---@type vim.lsp.Config
return {
  ---@type lsp.cssls
  settings = {
    css = {
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
}
