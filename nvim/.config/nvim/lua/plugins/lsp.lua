---@type LazySpec
return {
  {
    "yioneko/nvim-vtsls",
    enabled = true,
  },

  {
    "brw/tsc.nvim",
    enabled = false, -- enable once tsgo watch mode performance improves
    opts = {
      bin_name = "tsgo",
      auto_start_watch_mode = true,
      use_diagnostics = true,
      auto_open_qflist = false,
      enable_progress_notifications = false,
      enable_error_notifications = false,
      flags = {
        watch = true,
      },
    },
  },

  -- {
  --   "folke/lazydev.nvim",
  --   ft = "lua",
  --   enabled = false,
  --   config = function()
  --     require("lazydev").setup({
  --       ---@type lazydev.Library.spec[]
  --       library = {
  --         { path = "luvit-types/library" },
  --         -- { path = "neoconf.nvim/types/lua" },
  --         -- { path = "neoconf.nvim/types/lsp.lua" },
  --       },
  --     })
  --   end,
  -- },

  {
    "mrjones2014/codesettings.nvim",
    opts = {},
    lazy = true,
    -- ft = { "json", "jsonc", "lua" },
    -- ---@type CodesettingsOverridableConfig
    -- ---@diagnostic disable-next-line: missing-fields
    -- opts = {
    --   lua_ls_integration = true,
    -- },
  },

  {
    "Bilal2453/luvit-meta",
    ft = "lua",
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "onsails/lspkind.nvim",
      "b0o/schemastore.nvim",
      -- "folke/neoconf.nvim",
      {
        "artemave/workspace-diagnostics.nvim",
      },
    },
    config = function()
      -- -- add tmux lsp
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "tmux",
      --   callback = function()
      --     vim.lsp.start({
      --       name = "tmux",
      --       cmd = { "tmux-language-server" },
      --     })
      --   end,
      -- })

      -- -- old lsp-zero on_attach stuff
      -- local on_attach = function(client, bufnr)
      --   lsp_zero.highlight_symbol(client, bufnr)
      --
      --   -- :h lsp-zero-keybindings
      --   lsp_zero.default_keymaps({
      --     buffer = bufnr,
      --     preserve_mappings = false,
      --     exclude = { "gs" },
      --   })
      --
      --   vim.keymap.set("n", "gl", function()
      --     vim.diagnostic.open_float()
      --   end, { desc = "Show diagnostics", silent = true, buffer = bufnr })
      --
      --   vim.keymap.set(
      --     "n",
      --     "<M-i>",
      --     "<cmd>LspToggleInlayHints<cr>",
      --     { desc = "Toggle inlay hints", silent = true, buffer = bufnr }
      --   )
      --
      --   vim.keymap.set(
      --     "n",
      --     "gk",
      --     "<cmd>lua vim.lsp.buf.signature_help()<cr>",
      --     { desc = "Show function signature", silent = true, buffer = bufnr }
      --   )
      -- end

      -- lsp_zero.extend_lspconfig({
      --   capabilities = require("blink.cmp").get_lsp_capabilities(),
      --   -- capabilities = require("cmp_nvim_lsp").default_capabilities(),
      --   lsp_attach = on_attach,
      --   sign_text = true,
      --   float_border = "rounded",
      -- })

      -- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      --
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      --   local bufnr, winnr = orig_util_open_floating_preview(contents, syntax, opts, ...)
      --   -- vim.api.nvim_set_option_value("signcolumn", "no", { win = winnr })
      --   vim.api.nvim_set_option_value("filetype", "markdown", { buf = bufnr })
      --   return bufnr, winnr
      -- end

      -- -- pretty-ts-errors
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

      vim.diagnostic.config({
        update_in_insert = false,
        severity_sort = true,
        signs = {
          text = {
            -- [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.ERROR] = "󰅙",
          },
        },
        underline = {
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },
        },
        -- virtual_text = {
        --   virt_text_hide = true,
        --   severity = {
        --     vim.diagnostic.severity.ERROR,
        --     vim.diagnostic.severity.WARN,
        --   },
        -- },
        virtual_text = false,
        float = {
          source = true,
        },
      })

      local lsp_group = vim.api.nvim_create_augroup("bas.lsp", {})

      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_group,
        desc = "Register LSP keymaps and commands",
        callback = function(event)
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

          if not client then
            return
          end

          vim.keymap.set("n", "gl", vim.diagnostic.open_float, {
            desc = "Show diagnostics under the cursor",
            silent = true,
            buffer = event.buf,
          })

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            desc = "Go to definition",
            silent = true,
            buffer = event.buf,
          })

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
            desc = "Go to declaration",
            silent = true,
            buffer = event.buf,
          })

          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {
            desc = "Renames all references to the symbol under the cursor",
            silent = true,
            buffer = event.buf,
          })

          vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, {
            desc = "Select a code action at cursor position",
            silent = true,
            buffer = event.buf,
          })

          vim.api.nvim_buf_create_user_command(event.buf, "LspToggleInlayHints", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
          end, {
            desc = "Toggle inlay hints",
          })

          if client.name == "vtsls" then
            vim.keymap.set("n", "gs", "<cmd>VtsExec goto_source_definition<cr>", {
              desc = "Go to source definition",
              silent = true,
              buffer = event.buf,
            })

            vim.api.nvim_buf_create_user_command(event.buf, "OrganizeImports", function()
              vim.lsp.buf.code_action({
                context = {
                  only = {
                    "source.organizeImports",
                  },
                },
                apply = true,
              })
            end, {
              desc = "Organize imports using vtsls",
            })
          elseif client.name == "jsonls" then
            -- local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
            --
            -- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            --   if result and result.uri:match("%.jsonc$") and result.diagnostics then
            --     -- Iterate backward so table.remove is safe
            --     for i = #result.diagnostics, 1, -1 do
            --       if result.diagnostics[i].code == 519 then
            --         table.remove(result.diagnostics, i)
            --       end
            --     end
            --   end
            --   -- Pass the filtered diagnostics back to Neovim
            --   orig_handler(err, result, ctx, config)
            -- end
          end
        end,
      })

      local serversWithoutWorkspaceDiagnostics = { "oxlint", "tsgo" }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_group,
        desc = "Populate workspace diagnostics",
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if not client then
            return
          end

          if vim.list_contains(serversWithoutWorkspaceDiagnostics, client.name) then
            -- vim.notify("called workspace diagnostics for " .. client.id)
            -- client.notify is deprecated
            vim.deprecate = function() end
            require("workspace-diagnostics").populate_workspace_diagnostics(client, event.buf)
          else
            vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
          end
        end,
      })

      local installedPacks = require("mason-registry").get_installed_packages()
      local lspConfigNames = vim.iter(installedPacks):fold({}, function(acc, pack)
        table.insert(acc, pack.spec.neovim and pack.spec.neovim.lspconfig)
        return acc
      end)
      vim.lsp.enable(lspConfigNames)
      vim.lsp.enable("oxlint")
    end,
  },

  {
    "Myzel394/config-lsp.nvim",
    event = "VeryLazy",
    opts = {
      inject_lsp = true,
      add_filetypes = true,
    },
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls.builtins.code_actions.gitrebase"),
          require("null-ls.builtins.code_actions.gitsigns"),
        },
      })
    end,
  },

  {
    "altermo/ultimate-autopair.nvim",
    enabled = true,
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
    "windwp/nvim-ts-autotag",
    enabled = true,
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close_on_slash = true,
        },
      })
    end,
  },

  {
    "saghen/blink.pairs",
    version = "*",
    enabled = false,
    dependencies = { "saghen/blink.download" },
    ---@diagnostic disable-next-line: type-not-found
    ---@type blink.pairs.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ---@diagnostic disable-next-line: missing-fields
      mappings = {
        cmdline = false,
      },
      ---@diagnostic disable-next-line: missing-fields
      highlights = {
        enabled = false,
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    enabled = false,
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        fast_wrap = {},
      })
    end,
  },

  {
    "tronikelis/ts-autotag.nvim",
    enabled = false,
    config = function()
      require("ts-autotag").setup({
        auto_rename = {
          enabled = true,
        },
      })
    end,
  },

  {
    "wansmer/treesj",
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
    "antosha417/nvim-lsp-file-operations",
    requires = {
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
    "chrisgrieser/nvim-rulebook",
    config = true,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    opts = {
      preset = "modern",
      options = {
        -- Display the source of diagnostics (e.g., "lua_ls", "pyright")
        show_source = {
          enabled = true, -- Enable showing source names
          if_many = true, -- Only show source if multiple sources exist for the same diagnostic
        },

        -- Use icons from vim.diagnostic.config instead of preset icons
        use_icons_from_diagnostic = false,

        -- Color the arrow to match the severity of the first diagnostic
        set_arrow_to_diag_color = true,

        -- Throttle update frequency in milliseconds to improve performance
        -- Higher values reduce CPU usage but may feel less responsive
        -- Set to 0 for immediate updates (may cause lag on slow systems)
        throttle = 20,

        -- Minimum number of characters before wrapping long messages
        softwrap = 30,

        -- Control how diagnostic messages are displayed
        -- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
        --       If you want them to always be displayed, you can also set multilines.always_show = true.
        add_messages = {
          messages = true, -- Show full diagnostic messages
          display_count = true, -- Show diagnostic count instead of messages when cursor not on line
          use_max_severity = true, -- When counting, only show the most severe diagnostic
          show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
        },

        -- Settings for multiline diagnostics
        multilines = {
          enabled = true, -- Enable support for multiline diagnostic messages
          always_show = true, -- Always show messages on all lines of multiline diagnostics
          trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
          tabstop = 4, -- Number of spaces per tab when expanding tabs
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
          }, -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
        },

        -- Show all diagnostics on the current cursor line, not just those under the cursor
        show_all_diags_on_cursorline = true,

        -- Only show diagnostics when the cursor is directly over them, no fallback to line diagnostics
        show_diags_only_under_cursor = false,

        -- Display related diagnostics from LSP relatedInformation
        show_related = {
          enabled = true, -- Enable displaying related diagnostics
          max_count = 3, -- Maximum number of related diagnostics to show per diagnostic
        },

        -- Enable diagnostics display in insert mode
        -- May cause visual artifacts; consider setting throttle to 0 if enabled
        enable_on_insert = false,

        -- Enable diagnostics display in select mode (e.g., during auto-completion)
        enable_on_select = false,

        -- Handle messages that exceed the window width
        overflow = {
          mode = "wrap", -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
          padding = 0, -- Extra characters to trigger wrapping earlier
        },

        -- Break long messages into separate lines
        break_line = {
          enabled = false, -- Enable automatic line breaking
          after = 30, -- Number of characters before inserting a line break
        },

        -- Custom function to format diagnostic messages
        -- Receives diagnostic object, returns formatted string
        -- Example: function(diag) return diag.message .. " [" .. diag.source .. "]" end
        format = nil,

        -- Virtual text display priority
        -- Higher values appear above other plugins (e.g., GitBlame)
        virt_texts = {
          priority = 2048,
        },

        -- Filter diagnostics by severity levels
        -- Remove severities you don't want to display
        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
        },

        -- Events that trigger attaching diagnostics to buffers
        -- Default is {"LspAttach"}; change only if plugin doesn't work with your LSP setup
        overwrite_events = nil,

        -- Automatically disable diagnostics when opening diagnostic float windows
        override_open_float = true, -- doesn't seem to work?
      },
    },
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    enabled = false,
    config = true,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
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
    "OXY2DEV/markview.nvim",
    enabled = false,
    ---@type markview.config
    opts = {
      preview = {
        icon_provider = "devicons",
      },
    },
  },

  {
    "nvimdev/indentmini.nvim",
    enabled = false,
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
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    main = "ibl",
    config = true,
  },

  {
    "sontungexpt/better-diagnostic-virtual-text",
    enabled = false,
    event = "LspAttach",
    config = function(_)
      require("better-diagnostic-virtual-text").setup()
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    lazy = false,
    opts = {},
  },

  {
    "wasabeef/bufferin.nvim",
    opts = {
      show_window_layout = true,
    },
  },

  {
    "marilari88/twoslash-queries.nvim",
    opts = {
      multi_line = true,
    },
  },
}
