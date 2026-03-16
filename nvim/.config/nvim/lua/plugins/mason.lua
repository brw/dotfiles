---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- lsp/linters
        "emmylua_ls",
        "clangd",
        "jsonls",
        "yamlls",
        "bashls",
        "ruff",
        "tailwindcss",
        "terraformls",
        "vtsls",
        -- "tsgo",
        -- "oxlint",
        "css-lsp",
        "html-lsp",
        "gopls",
        "tombi",
        "gh-actions-language-server",
        "jdtls",
        "rust-analyzer",
        "jsonnet-language-server",
        "lemminx",
        "stylua",
        "systemd-lsp",
        "shellcheck",
        "actionlint",
        "systemdlint",
        "tflint",
        "fish-lsp",
        "svelte-language-server",

        -- formatters
        "stylua",
        "yamlfmt",
        "prettier",
        "shfmt",

        -- debuggers
        "js-debug-adapter",
      },
      auto_update = true,
      -- debounce_hours = 1,
    },
  },
}
