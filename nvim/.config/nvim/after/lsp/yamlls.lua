---@type vim.lsp.Config
return {
  ---@type lsp.yamlls
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
        kubernetes = { "manifests/*.yaml" },
        ["https://schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
      }),
    },
    validate = { enable = true },
  },
}
