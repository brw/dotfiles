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

require("lazy").setup({
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    init = function()
      vim.g.nord_borders = true -- border between splits
      vim.g.nord_italic = false
    end,
    config = function()
      vim.cmd.colorscheme("nord")
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
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/noice.nvim" },
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
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
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
        -- indent = {
        --   enable = true,
        -- },
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
    keys = {
      {
        "<leader>s",
        function()
          require("treesj").toggle({ split = { recursive = true } })
        end,
        desc = "Toggle node (split/join)",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
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

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup({
        sources = {
          -- { name = "copilot" },
          { name = "nvim_lsp" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        formatting = cmp_format,
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
        ensure_installed = { "lua_ls", "clangd", "jsonls", "yamlls", "jsonnet_ls" },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls())
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
                  schemas = schemastore.yaml.schemas(),
                },
              },
            })
          end,
        },
      })
    end,
  },

  {
    "nvimdev/guard.nvim",
    dependencies = {
      "nvimdev/guard-collection",
    },
    config = function()
      local ft = require("guard.filetype")

      ft("typescript,javascript,typescriptreact,json,css,html"):fmt("prettier")
      ft("lua"):fmt("stylua")
      ft("fish"):fmt("fish_indent")

      require("guard").setup({
        fmt_on_save = true,
        lsp_as_default_formatter = true,
      })
    end,
  },

  {
    "folke/neodev.nvim",
    opts = {
      override = function(root_dir, library)
        library.enabled = true
        library.plugins = true
      end,
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>t", "<Cmd>TroubleToggle<CR>" },
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
      { "<C-t><C-b>", "<cmd>Telescope buffers<CR>", desc = "Telescope buffers" },
      { "<C-t><C-g>", "<cmd>Telescope live_grep<CR>", desc = "Telescope grep" },
      { "<C-t><C-t>", "<cmd>Telescope help_tags<CR>", desc = "Telescope help" },
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
      { "<C-t><C-n>", "<cmd>Neotree toggle<CR>", desc = "Toggle Neotree" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          visible = true,
        },
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
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
  },

  {
    "stevearc/dressing.nvim",
  },

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
          search = true,
        },
      }
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
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
      persist_size = false,
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
    "zegervdv/nrpattern.nvim",
    config = function() -- for some reason `config = true` isn't enough here
      require("nrpattern").setup()
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = true,
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

  {
    "JopjeKnopje/42header_codam",
  },

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
    "abecodes/tabout.nvim",
    config = true,
  },

  {
    "NMAC427/guess-indent.nvim",
    config = true,
  },
})
