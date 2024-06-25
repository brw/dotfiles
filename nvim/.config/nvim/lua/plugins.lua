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
    opts = {
      window = {
        border = "single",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
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
                return require("lazy").stats().startuptime
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
      })
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
    "vonheikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "l3mon4d3/luasnip",
      "b0o/schemastore.nvim",
      {
        "zbirenbaum/copilot.lua",
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
              accept_word = "<M-L>",
              accept_line = "<M-l>",
              next = "<M-j>",
              prev = "<M-k>",
              dismiss = "<C-]>",
            },
          },
        },
      },
      -- { "zbirenbaum/copilot-cmp", config = true },
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      local lspconfig = require("lspconfig")
      local schemastore = require("schemastore")
      local cmp = require("cmp")
      local cmp_format = require("lsp-zero").cmp_format()

      cmp.setup({
        sources = {
          -- { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "lazydev", group_index = 0 },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        formatting = cmp_format,
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false,
        })
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
          "tsserver",
        },
        handlers = {
          lsp_zero.default_setup,

          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lua_opts.settings.Lua.format = {
              enable = false,
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
        },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff" },
        yaml = { "yamlfmt" },
        javascript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        sh = { "shfmt" },
        fish = { "fish_indent" },
      },
      format_on_save = {
        lsp_fallback = true,
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
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
      { "<C-t><C-b>", "<cmd>Telescope buffers<CR>", desc = "Telescope buffers" },
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
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          visible = true,
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
    enabled = true,
    config = function()
      require("presence"):setup({
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
    config = true,
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
  },

  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    config = true,
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
    config = true,
  },

  {
    "NMAC427/guess-indent.nvim",
    config = true,
  },

  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = { "*", "!lazy" },
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
      always_update = false,
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
    config = function()
      local config = require("session_manager.config")
      -- print(config.AutoloadMode.CurrentDir)

      require("session_manager").setup({
        autoload_mode = config.AutoloadMode.Disabled,
      })
    end,
  },

  {
    "chentoast/marks.nvim",
    config = true,
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
      copy_sync = {
        redirect_to_clipboard = true,
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
    config = function()
      require("dropbar").setup()

      vim.cmd.highlight("WinBar guibg=none")
      vim.cmd.highlight("WinBarNC guibg=none")
    end,
  },

  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      auto_hide = 1,
      focus_on_close = "previous",
      sidebar_filetypes = {
        ["neo-tree"] = { event = "BufWipeout" },
      },
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
