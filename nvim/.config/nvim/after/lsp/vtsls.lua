---@type vim.lsp.Config
return {
  ---@type lsp.vtsls
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
      -- inlayHints = {
      --   parameterNames = { enabled = "all" },
      --   parameterTypes = { enabled = true },
      --   variableTypes = { enabled = true },
      --   propertyDeclarationTypes = { enabled = true },
      --   functionLikeReturnTypes = { enabled = true },
      --   enumMemberValues = { enabled = true },
      -- },
    },
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        enableProjectDiagnostics = true,
      },
    },
  },
}
