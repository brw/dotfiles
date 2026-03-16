---@type vim.lsp.Config
return {
  ---@type lsp.tailwindcss
  settings = {
    tailwindCSS = {
      classAttributes = {
        "class",
        "className",
        "modifiersClassNames",
        "appearance",
        "toastOptions",
      },
      classFunctions = { "cn", "tv" },
      -- experimental = {
      --   classRegex = {
      --     { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
      --     { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
      --     { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
      --   },
      -- },
    },
  },
}
