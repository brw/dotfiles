---@diagnostic disable
---@type LazySpec
return {
  -- "hrsh7th/nvim-cmp",
  "iguanacucumber/magazine.nvim",
  enabled = false,
  name = "nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- "hrsh7th/cmp-nvim-lsp",
    -- "hrsh7th/cmp-path",
    { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp" },
    { "https://codeberg.org/FelipeLema/cmp-async-path", name = "cmp-path" },
    { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      sources = {
        -- { name = "copilot" },
        {
          name = "nvim_lsp",
          ---@param entry cmp.Entry
          entry_filter = function(entry)
            return entry:get_kind() ~= cmp.lsp.CompletionItemKind.Text
          end,
        },
        { name = "lazydev", group_index = 0 },
        { name = "path" },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)
          local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
          item = require("lspkind").cmp_format({
            -- before = require("tailwind-tools.cmp").lspkind_format,
          })(entry, item)
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
          return item
        end,
        expandable_indicator = true,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    })
  end,
}
