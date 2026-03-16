local augroup = vim.api.nvim_create_augroup("treesitter", { clear = true })

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "fish",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "diff",
        "json",
        "markdown",
        "markdown_inline",
        "latex",
        "typst",
        "regex",
        "python",
        "ruby",
        "c",
        "go",
        "elixir",
        "rust",
        "toml",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        group = augroup,
        callback = function(event)
          function treesitter_install()
            -- local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
            local filetype = event.match

            local ok, treesitter = pcall(require, "nvim-treesitter")
            if not ok then
              vim.defer_fn(treesitter_install, 1000)
              return
            end

            ---@diagnostic disable-next-line: redefined-local
            local ok, parsers = pcall(require, "nvim-treesitter.parsers")
            if not ok or not parsers[filetype] then
              return
            end

            ---@diagnostic disable-next-line: param-type-mismatch, redefined-local
            if not pcall(treesitter.install, filetype) then
              vim.defer_fn(treesitter_install, 1000)
              return
            end

            if filetype == "" or not vim.treesitter.language.add(filetype) then
              return
            end

            vim.treesitter.start()
          end

          treesitter_install()
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function()
      ---@diagnostic disable-next-line: need-check-nil
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
        },
        move = {
          enable = true,
          set_jumps = true,
        },
      })

      local keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@comment.outer",
        ["ic"] = "@comment.outer",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }

      for keys, selector in pairs(keymaps) do
        vim.keymap.set({ "x", "o" }, keys, function()
          require("nvim-treesitter-textobjects.select").select_textobject(selector, "textobjects")
        end)
      end
    end,
  },

  {
    "RRethy/nvim-treesitter-endwise",
  },
}
