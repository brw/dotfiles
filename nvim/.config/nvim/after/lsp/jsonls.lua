---@type vim.lsp.Config
return {
  ---@type lsp.jsonls
  settings = {
    json = {
      schemas = vim.list_extend(require("schemastore").json.schemas(), {
        {
          fileMatch = { "docker-compose*.json", "compose*.json" },
          url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
        },
      }),
      validate = {
        enable = true, -- required
      },
    },
  },
}
