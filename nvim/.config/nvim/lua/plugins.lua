local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

vim.g.nord_borders = true -- border between splits
vim.g.nord_italic = false
vim.g.nord_bold = false

require("lazy").setup({
  install = {
    colorscheme = "nord",
  },

  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
      require("nord").set()
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function(plugin)
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
          lualine_c = {},
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
      "windwp/nvim-ts-autotag",
    },
    opts = {
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
        disable = { "gitcommit" },
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
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>s",
        function()
          require("treesj").toggle({ split = { recursive = true } })
        end,
        desc = "Toggle node (split/join)",
      },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 600,
    },
  },

  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    opts = {
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
          accept_word = "<M-,>",
          accept_line = "<M-.>",
          next = "<M-j>",
          prev = "<M-d>",
          dismiss = "<M-]>",
        },
      },
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<M-CR>",
        accept_word = "<M-.>",
        clear_suggestion = "<M-]>",
      },
    },
  },

  {
    "vonheikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
      "l3mon4d3/luasnip",
      "b0o/schemastore.nvim",
      "yioneko/nvim-vtsls",
      -- { "zbirenbaum/copilot-cmp", opts = {} },
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      local lspconfig = require("lspconfig")
      local schemastore = require("schemastore")
      local cmp = require("cmp")

      cmp.setup({
        sources = {
          -- { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "lazydev", group_index = 0 },
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

      lsp_zero.on_attach(function(client, bufnr)
        -- :h lsp-zero-keybindings
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false,
          exclude = { "gs" },
        })

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
      end)

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "jsonls",
          "yamlls",
          "jsonnet_ls",
          "bashls",
          "basedpyright",
          "ruff_lsp",
          "tailwindcss",
          "terraformls",
          "tflint",
          "vtsls",
        },
        handlers = {
          lsp_zero.default_setup,

          lua_ls = function()
            -- local lua_opts = lsp_zero.nvim_lua_ls()
            local lua_opts = {
              settings = {
                Lua = {
                  format = {
                    enable = false,
                  },
                },
              },
            }
            lspconfig.lua_ls.setup(lua_opts)
          end,

          jsonls = function()
            lspconfig.jsonls.setup({
              settings = {
                json = {
                  schemas = vim.list_extend(schemastore.json.schemas(), {
                    {
                      fileMatch = { "dodcker-compose*.json", "compose*.json" },
                      url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
                    },
                  }),
                  validate = { enable = true },
                },
              },
            })
          end,

          yamlls = function()
            lspconfig.yamlls.setup({
              settings = {
                yaml = {
                  schemaStore = {
                    enable = false,
                    url = "",
                  },
                  schemas = vim.tbl_extend("force", schemastore.yaml.schemas(), {
                    kubernetes = { "manifests/*.yaml" },
                  }),
                },
                validate = { enable = true },
              },
            })
          end,

          tailwindcss = function()
            lspconfig.tailwindcss.setup({
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
            })
          end,

          vtsls = function()
            lspconfig.vtsls.setup({
              settings = {
                javascript = {
                  updateImportsOnFileMove = "always",
                },
                typescript = {
                  updateImportsOnFileMove = "always",
                },
                vtsls = {
                  enableMoveToFileCodeAction = true,
                },
              },
            })
          end,
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
    opts = {},
  },

  {
    "luckasRanarison/tailwind-tools.nvim",
    enabled = false,
    ---@module "tailwind-tools"
    ---@type TailwindTools.Option
    opts = {},
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "Format", "FormatDisable", "FormatEnable", "FormatToggle" },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
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
    },
    config = function(_, opts)
      require("conform").setup(opts)

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
    ---@module "lazydev"
    ---@type lazydev.Config
    opts = {
      ---@type lazydev.Library.spec[]
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },

  --TODO: configure
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble" },
    keys = {
      { "<leader>t", "<Cmd>Trouble<CR>" },
    },
    opts = {},
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
      --{ '<leader>dl', '<cmd>Telescope diagnostics<CR>', desc = 'Telescope diagnostics' },
    },
    opts = {
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
    },
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
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
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
    },
  },

  {
    "echasnovski/mini.files",
    enabled = false,
    keys = {
      { "<C-h>", "<cmd>lua if not MiniFiles.close() then MiniFiles.open() end<CR>", desc = "Toggle MiniFiles" },
    },
    opts = {
      mappings = {
        close = "<Esc>",
      },
    },
  },

  {
    "stevearc/oil.nvim",
    opts = {
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
      watch_for_changes = true,
    },
  },

  {
    "folke/noice.nvim",
    dependencies = {
      "muniftanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "smjonas/inc-rename.nvim",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = {
          enabled = false,
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },

  { "stevearc/dressing.nvim" },

  {
    "andweeb/presence.nvim",
    -- enabled = false,
    opts = {
      show_time = false,
      neovim_image_text = "Neovim",
      -- log_level = "debug",
    },
  },

  {
    "stevearc/qf_helper.nvim",
    keys = {
      { "<C-n>", "<Cmd>QNext<CR>" },
      { "<C-p>", "<Cmd>QPrev<CR>" },
      { "<leader>q", "<Cmd>QFToggle!<CR>" },
      { "<leader>l", "<Cmd>LLToggle!<CR>" },
    },
    opts = {},
  },

  {
    "yorickpeterse/nvim-pqf",
    opts = {},
  },

  {
    "petertriho/nvim-scrollbar",
    dependencies = { "kevinhwang91/nvim-hlslens" },
    opts = function()
      return {
        handle = {
          color = require("nord.colors").nord2_gui,
        },
        handlers = {
          -- search = true,
        },
      }
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
    opts = {},
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = "<C-q>",
      shading_factor = "0",
      winbar = {
        enabled = true,
      },
    },
  },

  {
    "ethanholz/nvim-lastplace",
    opts = {},
  },

  {
    "kylechui/nvim-surround",
    opts = {},
  },

  {
    "numtostr/comment.nvim",
    opts = {},
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
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  {
    "karb94/neoscroll.nvim",
    opts = {
      easing_function = "quadratic",
    },
  },

  { "JopjeKnopje/42header_codam" },

  { "cacharle/c_formatter_42.vim" },

  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      fastwarp = {
        faster = true,
      },
    },
  },

  {
    "TimUntersberger/neogit",
    opts = {
      commit_popup = {
        kind = "floating",
      },
      popup = {
        kind = "floating",
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "abecodes/tabout.nvim",
    opts = {},
  },

  {
    "NMAC427/guess-indent.nvim",
    opts = {},
  },

  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
    main = "colorizer",
    opts = {
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
    },
  },

  {
    "brenoprata10/nvim-highlight-colors",
    enabled = true,
    opts = {
      render = "virtual",
      enable_tailwind = true,
    },
  },

  {
    "xorid/swap-split.nvim",
    opts = {
      ignore_filetypes = { "NvimTree", "notify", "toggleterm", "Trouble", "qf" },
    },
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
      local dap, dapui = require("dap"), require("dapui")

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
    dependencies = { "nvim-lua/plenary.nvim" },
    main = "session_manager",
    opts = function()
      local config = require("session_manager.config")

      return {
        autoload_mode = { config.AutoloadMode.GitSession, config.AutoloadMode.CurrentDir },
      }
    end,
  },

  {
    "chentoast/marks.nvim",
    opts = {},
  },

  {
    "jinh0/eyeliner.nvim",
    opts = {
      highlight_on_key = true,
      dim = true,
    },
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
    opts = {
      navigation = {
        enable_default_keybindings = false,
      },
      resize = {
        enable_custom_bindings = false,
        resize_step_x = 5,
        resize_step_y = 5,
      },
    },
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
    opts = {},
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
    opts = {
      auto_hide = 1,
      focus_on_close = "previous",
      no_name_title = "new",
    },
  },

  {
    "tzachar/highlight-undo.nvim",
    init = function()
      local nord = require("nord.named_colors")

      vim.api.nvim_set_hl(0, "HighlightUndo", {
        bg = nord.light_gray,
        fg = nord.white,
      })
    end,
    opts = {},
  },
})
