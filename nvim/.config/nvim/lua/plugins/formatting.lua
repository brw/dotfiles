---@type LazySpec
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo", "Format", "FormatDisable", "FormatEnable", "FormatToggle" },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil

      if args.count ~= -1 then
        local end_line = assert(vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1])

        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end

      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, {})

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      bang = true,
      desc = "Disable autoformat on save (bang to disable for current buffer only)",
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat on save",
    })

    vim.api.nvim_create_user_command("FormatToggle", function()
      if vim.g.disable_autoformat then
        vim.g.disable_autoformat = false
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Toggle autoformat on save",
    })
  end,
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      javascript = { "oxfmt", "prettier" },
      javascriptreact = { "oxfmt", "prettier" },
      typescript = { "oxfmt", "prettier" },
      typescriptreact = { "oxfmt", "prettier" },
      html = { "oxfmt", "prettier" },
      css = { "oxfmt", "prettier" },
      graphql = { "oxfmt", "prettier" },
      sh = { "shfmt" },
      fish = { "fish_indent" },
      go = { "gofmt" },
      json = { "oxfmt", "prettier" },
      jsonc = { "oxfmt", "prettier" },
      xml = { "xmllint" },
      -- systemd = {"systemdlinter"} -- TODO: setup
      ["*"] = { "trim_newlines", "trim_whitespace" },
    },
    log_level = vim.log.levels.DEBUG,
    default_format_opts = {
      stop_after_first = true,
      timeout_ms = 2000,
    },
    -- format_on_save = function(bufnr)
    format_after_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      -- local bufname = vim.api.nvim_buf_get_name(bufnr)
      -- if bufname:match("/node_modules/") then
      --   return
      -- end

      return { lsp_format = "fallback" }
    end,
  },
}
