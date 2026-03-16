---@type LazySpec
return {
  "saghen/blink.cmp",
  -- version = "*",
  event = { "InsertEnter", "CmdlineEnter" },
  build = "cargo build --release",
  dependencies = {
    "L3MON4D3/LuaSnip",
    dependencies = { "kmarius/jsregexp" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-Space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "none",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },

      ["<C-d>"] = { "scroll_documentation_up", "fallback" },
      ["<C-u>"] = { "scroll_documentation_down", "fallback" },

      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    ---@diagnostic disable-next-line: missing-fields
    sources = {
      default = { "lsp", "path", "snippets" },
    },

    ---@diagnostic disable-next-line: missing-fields
    appearance = {},

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    ---@diagnostic disable-next-line: missing-fields
    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },

    ---@diagnostic disable-next-line: missing-fields
    snippets = {
      preset = "luasnip",
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
    },

    signature = {
      enabled = false,
    },

    completion = {
      ---@diagnostic disable-next-line: missing-fields
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      ---@diagnostic disable-next-line: missing-fields
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        ---@diagnostic disable-next-line: missing-fields
        window = {
          border = "bold",
        },
      },
      ---@diagnostic disable-next-line: missing-fields
      menu = {
        border = "none",
        draw = {
          padding = 0,
          gap = 1,
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                elseif ctx.kind == "Color" then
                  icon = "██"
                else
                  icon = require("lspkind").symbol_map[ctx.kind] or ""
                end

                return icon .. ctx.icon_gap
              end,

              -- Optionally, use the highlight groups from nvim-web-devicons
              -- You can also add the same function for `kind.highlight` if you want to
              -- keep the highlight groups in sync with the icons.
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
          },
        },
      },
    },
  },
}
