---@type vim.lsp.Config
return {
  ---@type lsp.tsgo
  settings = {
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      tsserver = {
        experimental = {
          enableProjectDiagnostics = true,
        },
      },
    },
  },
}
