---@type LazySpec
return {
  {
    "gbprod/nord.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("nord").setup({
        diff = {
          mode = "fg",
        },
        errors = {
          mode = "none", -- doesn't seem to do anything?
        },
        on_highlights = function(hi, c)
          hi.DiffAdd = vim.tbl_extend("force", hi.DiffAdd, { bg = "" })
          hi.DiffDelete = vim.tbl_extend("force", hi.DiffDelete, { bg = "" })
          hi.DiffChange = vim.tbl_extend("force", hi.DiffChange, { bg = "" })
          hi.DiffText = vim.tbl_extend("force", hi.DiffText, { bg = "" })
        end,
      })
      vim.cmd.colorscheme("nord")
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        preset = "modern",
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "yavorski/lualine-macro-recording.nvim",
    },
    config = function()
      local lualine = require("lualine")
      local startuptime_visible = true
      -- hide startup time after 3 seconds
      vim.defer_fn(function()
        startuptime_visible = false
      end, 3000)

      lualine.setup({
        options = {
          theme = "nord",
          component_separators = "|",
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              function()
                return " "
              end,
              padding_left = 1,
              color = "Normal",
            },
            { "mode", separator = { left = "" } },
          },
          lualine_b = {
            { "filename" },
            { "branch" },
            { "diff" },
            { "diagnostics" },
          },
          lualine_c = {
            "macro_recording",
          },
          lualine_x = {
            {
              function()
                return math.floor(require("lazy").stats().startuptime) .. "ms"
              end,
              icon = "󱎫",
              cond = function()
                return startuptime_visible
              end,
            },
          },
          lualine_y = {
            { "filetype" },
            { "fileformat", icons_enabled = false },
            { "progress" },
          },
          lualine_z = {
            { "location", separator = { right = "" } },
            {
              function()
                return " "
              end,
              padding_right = 1,
              color = "Normal",
            },
          },
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-endwise",
      {
        "windwp/nvim-ts-autotag",
        config = true,
      },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "fish",
          "diff",
          "json",
          "jsonc",
          "markdown",
          "markdown_inline",
          "regex",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "python",
          "ruby",
          "c",
          "go",
          "elixir",
          "rust",
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@comment.outer",
              ["ic"] = "@comment.outer",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
            selection_modes = {
              ["@function.outer"] = "V",
              ["@function.inner"] = "V",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
            },
          },
        },
        endwise = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
      })
    end,
  },

  {
    "wansmer/treesj",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>s",
        function()
          require("treesj").toggle({ split = { recursive = true } })
        end,
        desc = "Toggle node (split/join)",
      },
    },
    ---@class TreeSJ.Settings
    ---@field use_default_keymaps boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
    ---@field check_syntax_error boolean Node with syntax error will not be formatted
    ---@field max_join_length number If line after join will be longer than max value, node will not be formatted
    ---Cursor behavior:
    ---hold - cursor follows the node/place on which it was called
    ---start - cursor jumps to the first symbol of the node being formatted
    ---end - cursor jumps to the last symbol of the node being formatted
    ---@field cursor_behavior 'hold'|'start'|'end'
    ---@field notify boolean Notify about possible problems or not
    ---@field langs table Presets for languages
    ---@field dot_repeat boolean Use `dot` for repeat action
    ---@field on_error nil|function Callback for treesj error handler. func (err_text, level, ...)
    opts = {
      use_default_keymaps = false,
      -- max_join_length = 600,
    },
  },

  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    config = function()
      require("copilot").setup({
        filetypes = {
          gitcommit = true,
          markdown = true,
          yaml = true,
        },
        panel = {
          enabled = false,
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<M-CR>",
            accept_word = "<M-.>",
            accept_line = "<M-.>",
            next = "<M-j>",
            prev = "<M-d>",
            dismiss = "<M-]>",
          },
        },
      })
    end,
  },

  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<M-CR>",
          accept_word = "<M-.>",
          clear_suggestion = "<M-]>",
        },
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    config = true,
  },

  {
    "folke/neoconf.nvim",
    config = true,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
      "b0o/schemastore.nvim",
      "yioneko/nvim-vtsls",
      "folke/neoconf.nvim",
      {
        "vonheikemen/lsp-zero.nvim",
        branch = "v4.x",
      },
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      -- add tmux lsp
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tmux",
        callback = function()
          vim.lsp.start({
            name = "tmux",
            cmd = { "tmux-language-server" },
          })
        end,
      })

      local on_attach = function(client, bufnr)
        -- lsp_zero.highlight_symbol(client, bufnr)

        -- :h lsp-zero-keybindings
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false,
          exclude = { "gs" },
        })

        vim.keymap.set("n", "gl", function()
          vim.diagnostic.open_float()
        end, { desc = "Show diagnostics", silent = true, buffer = bufnr })

        vim.keymap.set(
          "n",
          "gk",
          "<cmd>lua vim.lsp.buf.signature_help()<cr>",
          { desc = "Show function signature", silent = true, buffer = bufnr }
        )

        if client.name == "vtsls" then
          vim.keymap.set(
            "n",
            "gs",
            "<cmd>VtsExec goto_source_definition<cr>",
            { desc = "Goto source definition", silent = true, buffer = bufnr }
          )
        end
      end

      lsp_zero.extend_lspconfig({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        lsp_attach = on_attach,
        sign_text = true,
        float_border = "rounded",
      })

      -- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      --
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      --   local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
      --   -- vim.api.nvim_set_option_value("signcolumn", "no", { win = winnr })
      --   vim.api.nvim_set_option_value("filetype", "markdown", { buf = bufnr })
      --   return bufnr, winnr
      -- end

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "jsonls",
          "yamlls",
          "bashls",
          "basedpyright",
          "ruff_lsp",
          "tailwindcss",
          "terraformls",
          "tflint",
          "vtsls",
        },
        handlers = {
          function(server)
            require("lspconfig")[server].setup({})
          end,

          lua_ls = function()
            ---@diagnostic disable: missing-fields
            ---@type lspconfig.options.lua_ls
            local lua_opts = {
              settings = {
                Lua = {
                  format = {
                    enable = false,
                  },
                  diagnostics = {
                    workspaceDelay = -1,
                    workspaceEvent = "None",
                  },
                  workspace = {
                    checkThirdParty = false,
                  },
                  codeLens = {
                    enable = true,
                  },
                  completion = {
                    callSnippet = "Both",
                  },
                  doc = {
                    privateName = { "^_" },
                  },
                  hint = {
                    enable = true,
                    setType = false,
                    paramType = true,
                    paramName = "Disable",
                    semicolon = "Disable",
                    arrayIndex = "Disable",
                  },
                },
              },
            }
            require("lspconfig").lua_ls.setup(lua_opts)
          end,

          jsonls = function()
            ---@diagnostic disable: missing-fields
            ---@type lspconfig.options.jsonls
            local jsonls_opts = {
              settings = {
                json = {
                  schemas = vim.list_extend(require("schemastore").json.schemas(), {
                    {
                      fileMatch = { "docker-compose*.json", "compose*.json" },
                      url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
                    },
                  }),
                  validate = { enable = true },
                },
              },
            }
            require("lspconfig").jsonls.setup(jsonls_opts)
          end,

          yamlls = function()
            ---@diagnostic disable: missing-fields
            ---@type lspconfig.options.yamlls
            local yamlls_opts = {
              settings = {
                yaml = {
                  schemaStore = {
                    enable = false,
                    url = "",
                  },
                  schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
                    kubernetes = { "manifests/*.yaml" },
                  }),
                },
                validate = { enable = true },
              },
            }
            require("lspconfig").yamlls.setup(yamlls_opts)
          end,

          tailwindcss = function()
            ---@diagnostic disable: missing-fields
            ---@type lspconfig.options.tailwindcss
            local tailwindcss_opts = {
              settings = {
                tailwindCSS = {
                  experimental = {
                    classRegex = {
                      { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                      { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                    },
                  },
                },
              },
            }
            require("lspconfig").tailwindcss.setup(tailwindcss_opts)
          end,

          vtsls = function()
            ---@diagnostic disable: missing-fields
            ---@type lspconfig.options.vtsls
            local vtsls_opts = {
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
                vtsls = {
                  enableMoveToFileCodeAction = true,
                },
              },
              -- handlers = {
              --   ---@diagnostic disable: redundant-parameter
              --   ---@param err lsp.ResponseError?
              --   ---@param result lsp.PublishDiagnosticsParams
              --   ---@param ctx lsp.HandlerContext
              --   ---@param config? vim.diagnostic.Opts Configuration table (see |vim.diagnostic.config()|).
              --   ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              --     if not result.diagnostics then
              --       return
              --     end
              --
              --     for _, diagnostic in ipairs(result.diagnostics) do
              --       local json = vim.fn.json_encode({
              --         range = diagnostic.range,
              --         message = diagnostic.message,
              --         code = diagnostic.code,
              --         severity = diagnostic.severity,
              --         source = diagnostic.source,
              --       })
              --       local proc = vim.system(
              --         { "pretty-ts-errors-markdown" },
              --         { text = true, stdin = true },
              --         function(obj)
              --           diagnostic.message = obj.stdout
              --           vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
              --         end
              --       )
              --       proc:write(json)
              --       proc:write(nil)
              --     end
              --   end,
              -- },
            }
            require("lspconfig").vtsls.setup(vtsls_opts)
          end,
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
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
  },

  {
    "antosha417/nvim-lsp-file-operations",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = true,
  },

  {
    "luckasRanarison/tailwind-tools.nvim",
    enabled = false,
    config = true,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "Format", "FormatDisable", "FormatEnable", "FormatToggle" },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          yaml = { "yamlfmt" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          graphql = { "prettierd", "prettier", stop_after_first = true },
          sh = { "shfmt" },
          fish = { "fish_indent" },
        },
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          return { lsp_format = "fallback" }
        end,
        format_after_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          return { lsp_format = "fallback" }
        end,
      })

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
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
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = function()
      require("lazydev").setup({
        ---@type lazydev.Library.spec[]
        library = {
          { path = "luvit-meta/library" },
        },
      })
    end,
  },

  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },

  --TODO: configure
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Trouble" },
    keys = {
      { "<leader>t", "<Cmd>Trouble<CR>" },
    },
    config = true,
  },

  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<C-t><C-r>", "<cmd>Telescope resume<CR>", desc = "Telescope resume" },
      { "<C-t><C-p>", "<cmd>Telescope find_files<CR>", desc = "Telescope find files" },
      { "<C-t><C-f>", "<cmd>Telescope buffers<CR>", desc = "Telescope buffers" },
      { "<C-t><C-g>", "<cmd>Telescope live_grep<CR>", desc = "Telescope grep" },
      { "<C-t><C-c>", "<cmd>Telescope help_tags<CR>", desc = "Telescope help" },
      { "<C-t><C-m>", "<cmd>Telescope man_pages<CR>", desc = "Telescope man" },
      --{ 'gd', '<cmd>Telescope lsp_definitions<CR>', desc = 'Telescope definitions' },
      --{ 'gi', '<cmd>Telescope implementations<CR>', desc = 'Telescope implementations' },
      { "<C-t><C-d>", "<cmd>Telescope diagnostics<CR>", desc = "Telescope diagnostics" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          file_ignore_patterns = { ".git/" },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            hidden = true,
          },
          buffers = {
            theme = "dropdown",
          },
          live_grep = {
            theme = "dropdown",
          },
          help_tags = {
            theme = "dropdown",
          },
          man_pages = {
            theme = "dropdown",
          },
        },
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    event = { "BufEnter" },
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "muniftanjim/nui.nvim",
    },
    keys = {
      { "<C-h>", "<cmd>Neotree toggle<CR>", desc = "Toggle Neotree" },
      { "<leader>fh", "<cmd>Neotree reveal<CR>", desc = "Reveal file in Neotree" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          filtered_items = {
            visible = true,
            never_show = {
              "..",
              "node_modules",
            },
          },
          find_command = "fd",
          find_args = {
            fd = {
              "--exclude",
              ".git",
              "--exclude",
              "node_modules",
            },
          },
          hijack_netrw_behavior = "disabled",
          use_libuv_file_watcher = true,
        },
        event_handlers = {
          -- {
          --   event = "file_opened",
          --   handler = function()
          --     require("neo-tree.command").execute({ action = "close" })
          --   end,
          -- },
        },
        window = {
          mappings = {
            ["P"] = { "toggle_preview", config = { use_float = false } },
          },
        },
      })
    end,
  },

  {
    "echasnovski/mini.files",
    enabled = false,
    keys = {
      { "<C-h>", "<cmd>lua if not MiniFiles.close() then MiniFiles.open() end<CR>", desc = "Toggle MiniFiles" },
    },
    config = function()
      require("mini.files").setup({
        mappings = {
          close = "<Esc>",
        },
      })
    end,
  },

  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = false,
        watch_for_changes = true,
      })
    end,
  },

  {
    "rcarriga/nvim-notify",
    priority = 500,
    config = function()
      require("notify").setup({
        stages = "static",
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
      })
    end,
  },

  {
    "folke/noice.nvim",
    dependencies = {
      "muniftanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "smjonas/inc-rename.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          progress = {
            enabled = false,
          },
          hover = {
            silent = true,
          },
        },
        presets = {
          bottom_search = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },
        popupmenu = {
          backend = "nui", -- cmp seems broken?
        },
      })
    end,
  },

  { "stevearc/dressing.nvim" },

  {
    "andweeb/presence.nvim",
    -- enabled = false,
    config = function()
      require("presence").setup({
        show_time = false,
        neovim_image_text = "Neovim",
        -- log_level = "debug",
      })
    end,
  },

  {
    "stevearc/qf_helper.nvim",
    keys = {
      { "<C-n>", "<Cmd>QNext<CR>" },
      { "<C-p>", "<Cmd>QPrev<CR>" },
      { "<leader>q", "<Cmd>QFToggle!<CR>" },
      { "<leader>l", "<Cmd>LLToggle!<CR>" },
    },
    config = true,
  },

  {
    "yorickpeterse/nvim-pqf",
    config = true,
  },

  {
    "petertriho/nvim-scrollbar",
    dependencies = {
      "kevinhwang91/nvim-hlslens",
    },
    config = function()
      require("scrollbar").setup({
        handle = {
          color = require("nord.colors").palette.polar_night.brighter,
        },
        handlers = {
          -- search = true,
        },
      })
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    enabled = false,
    keys = {
      { "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>" },
      { "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>" },
      { "*", "*<Cmd>lua require('hlslens').start()<CR>" },
      { "#", "#<Cmd>lua require('hlslens').start()<CR>" },
      { "g*", "g*<Cmd>lua require('hlslens').start()<CR>" },
      { "g#", "g#<Cmd>lua require('hlslens').start()<CR>" },
    },
    config = true,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-q>", desc = "Toggle terminal" },
    },
    config = function()
      require("toggleterm").setup({
        open_mapping = "<C-q>",
        shading_factor = "0",
        winbar = {
          enabled = true,
        },
      })
    end,
  },

  {
    "ethanholz/nvim-lastplace",
    config = true,
  },

  {
    "kylechui/nvim-surround",
    config = true,
  },

  {
    "numtostr/comment.nvim",
    config = true,
  },

  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", "<Cmd>lua require('dial.map').manipulate('increment', 'normal')<CR>", mode = { "n", "v" } },
      { "<C-x>", "<Cmd>lua require('dial.map').manipulate('decrement', 'normal')<CR>", mode = { "n", "v" } },
      { "g<C-a>", "<Cmd>lua require('dial.map').manipulate('increment', 'gnormal')<CR>", mode = { "n", "v" } },
      { "g<C-x>", "<Cmd>lua require('dial.map').manipulate('decrement', 'gnormal')<CR>", mode = { "n", "v" } },
    },
    config = function()
      local augend = require("dial.augend")

      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.constant.alias.bool,
        },
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    config = true,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        easing_function = "quadratic",
      })
    end,
  },

  { "JopjeKnopje/42header_codam" },

  { "cacharle/c_formatter_42.vim" },

  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("ultimate-autopair").setup({
        fastwarp = {
          faster = true,
        },
      })
    end,
  },

  {
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup({
        commit_popup = {
          kind = "floating",
        },
        popup = {
          kind = "floating",
        },
      })
    end,
  },

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },

  {
    "abecodes/tabout.nvim",
    config = true,
  },

  {
    "NMAC427/guess-indent.nvim",
    config = true,
  },

  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
    main = "colorizer",
    config = function()
      require("colorizer").setup({
        filetypes = { "*", "!lazy" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = false, -- "Name" codes like Blue or blue
          RRGGBBAA = false, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background",
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = "both",
          sass = {
            enable = true,
            parsers = { "css" },
          },
          virtualtext = "■",
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = true,
        },
      })
    end,
  },

  {
    "brenoprata10/nvim-highlight-colors",
    enabled = true,
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual",
        enable_tailwind = true,
        exclude_filetypes = { "gitcommit", "lazy", "help" },
      })
    end,
  },

  {
    "xorid/swap-split.nvim",
    config = function()
      require("swap-split").setup({
        ignore_filetypes = { "NvimTree", "neo-tree", "notify", "toggleterm", "Trouble", "qf" },
      })
    end,
  },

  {
    "lambdalisue/suda.vim",
    init = function()
      vim.g.suda_smart_edit = true
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      {
        "ldelossa/nvim-dap-projects",
        config = function()
          require("nvim-dap-projects").search_project_config()
        end,
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  {
    "Shatur/neovim-session-manager",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    main = "session_manager",
    opts = function()
      local config = require("session_manager.config")
      ---@module "plenary"
      ---@class SessionManager.Settings
      ---@field sessions_dir Path The directory where the session files will be saved.
      ---@field session_filename_to_dir function(string): Path Function that replaces symbols into separators and colons to transform filename into a session directory.
      ---@field dir_to_session_filename function(string): Path Function that replaces separators and colons into special symbols to transform session directory into a filename. Should use `vim.uv.cwd()` if the passed `dir` is `nil`.
      ---@field autoload_mode ('Disabled'|'CurrentDir'|'LastSession'|'GitSession')[] Define what to do when Neovim is started without arguments. See "Autoload mode" section below.
      ---@field autosave_last_session boolean Automatically save last session on exit and on session switch.
      ---@field autosave_ignore_not_normal boolean Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
      ---@field autosave_ignore_dirs string[] A list of directories where the session will not be autosaved.
      ---@field autosave_ignore_filetypes string[] All buffers of these file types will be closed before the session is saved.
      ---@field autosave_ignore_buftypes string[] All buffers of these bufer types will be closed before the session is saved.
      ---@field autosave_only_in_session boolean Always autosaves session. If true, only autosaves after a session is active.
      ---@field max_path_length number Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
      return {
        autoload_mode = { config.AutoloadMode.GitSession, config.AutoloadMode.CurrentDir },
        autosave_ignore_dirs = { "~" },
      }
    end,
  },

  {
    "chentoast/marks.nvim",
    config = true,
  },

  {
    "jinh0/eyeliner.nvim",
    config = function()
      require("eyeliner").setup({
        highlight_on_key = true,
        dim = true,
      })
    end,
  },

  {
    "bfredl/nvim-luadev",
    cmd = { "Luadev" },
    keys = {
      { mode = "n", "<leader>rl", "<Plug>(Luadev-RunLine)", desc = "Execute line" },
      { mode = { "n", "v" }, "<leader>rr", "<Plug>(Luadev-Run)", desc = "Execute movement/object" },
      { mode = "n", "<leader>rw", "<Plug>(Luadev-RunWord)", desc = "Execute word" },
    },
  },

  {
    "aserowy/tmux.nvim",
    keys = {
      { "<M-h>", "<Cmd>lua require('tmux').move_left()<CR>", desc = "Move left", mode = { "n", "t" } },
      { "<M-j>", "<Cmd>lua require('tmux').move_bottom()<CR>", desc = "Move bottom", mode = { "n", "t" } },
      { "<M-k>", "<Cmd>lua require('tmux').move_top()<CR>", desc = "Move top", mode = { "n", "t" } },
      { "<M-l>", "<Cmd>lua require('tmux').move_right()<CR>", desc = "Move right", mode = { "n", "t" } },
      { "<M-H>", "<Cmd>lua require('tmux').resize_left()<CR>", desc = "Resize left", mode = { "n", "t" } },
      { "<M-J>", "<Cmd>lua require('tmux').resize_bottom()<CR>", desc = "Resize bottom", mode = { "n", "t" } },
      { "<M-K>", "<Cmd>lua require('tmux').resize_top()<CR>", desc = "Resize top", mode = { "n", "t" } },
      { "<M-L>", "<Cmd>lua require('tmux').resize_right()<CR>", desc = "Resize right", mode = { "n", "t" } },
    },
    config = function()
      require("tmux").setup({
        navigation = {
          enable_default_keybindings = false,
        },
        resize = {
          enable_custom_bindings = false,
          resize_step_x = 5,
          resize_step_y = 5,
        },
      })
    end,
  },

  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    init = function()
      vim.cmd.highlight("WinBar guibg=none")
      vim.cmd.highlight("WinBarNC guibg=none")
    end,
    config = true,
  },

  {
    "romgrk/barbar.nvim",
    lazy = false,
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<M-.>", "<Cmd>BufferNext<CR>", desc = "Buffer next" },
      { "<M-,>", "<Cmd>BufferPrevious<CR>", desc = "Buffer previous" },
      { "<M-d>", "<Cmd>BufferClose<CR>", desc = "Buffer close" },
      { "<M-<>", "<Cmd>BufferMovePrevious<CR>", desc = "Buffer move previous" },
      { "<M->>", "<Cmd>BufferMoveNext<CR>", desc = "Buffer move next" },
      { "<M-p", "<Cmd>BufferPin<CR>", desc = "Buffer pin" },
      { "<C-p>", "<Cmd>BufferPick<CR>", desc = "Buffer pick" },
      { "<M-1>", "<Cmd>BufferGoto 1<CR>", desc = "Buffer goto 1" },
      { "<M-2>", "<Cmd>BufferGoto 2<CR>", desc = "Buffer goto 2" },
      { "<M-3>", "<Cmd>BufferGoto 3<CR>", desc = "Buffer goto 3" },
      { "<M-4>", "<Cmd>BufferGoto 4<CR>", desc = "Buffer goto 4" },
      { "<M-5>", "<Cmd>BufferGoto 5<CR>", desc = "Buffer goto 5" },
      { "<M-6>", "<Cmd>BufferGoto 6<CR>", desc = "Buffer goto 6" },
      { "<M-7>", "<Cmd>BufferGoto 7<CR>", desc = "Buffer goto 7" },
      { "<M-8>", "<Cmd>BufferGoto 8<CR>", desc = "Buffer goto 8" },
      { "<M-9>", "<Cmd>BufferGoto 9<CR>", desc = "Buffer goto 9" },
      { "<M-0>", "<Cmd>BufferLast<CR>", desc = "Buffer goto last" },
    },
    config = function()
      require("barbar").setup({
        auto_hide = 1,
        focus_on_close = "previous",
        no_name_title = "new",
      })
    end,
  },

  {
    "tzachar/highlight-undo.nvim",
    init = function()
      local nord = require("nord.colors").palette

      vim.api.nvim_set_hl(0, "HighlightUndo", {
        bg = nord.polar_night.brighter,
        fg = nord.snow_storm.brightest,
      })
    end,
    config = true,
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    enabled = false,
    config = true,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    }, -- if you prefer nvim-web-devicons
    config = function()
      require("render-markdown").setup({
        preset = "lazy",
        overrides = {
          buftype = {
            nofile = {
              code = { left_pad = 0, right_pad = 0 },
            },
          },
        },
      })
    end,
  },

  {
    "nvimdev/indentmini.nvim",
    init = function()
      local nord = require("nord.colors").palette

      vim.cmd.highlight("IndentLine guifg=" .. nord.polar_night.brighter)
      vim.cmd.highlight("IndentLineCurHide guifg=" .. nord.polar_night.brighter)
      vim.cmd.highlight("IndentLineCurrent guifg=" .. nord.polar_night.light)
    end,
    config = function()
      require("indentmini").setup({
        char = "▎",
        exclude = { "gitcommit" },
      })
    end,
    enabled = true,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = true,
    enabled = false,
  },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = true,
      })
    end,
  },
}
