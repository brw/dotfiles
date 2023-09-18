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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
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
        lualine_x = {},
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
    },
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
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      local lspconfig = require("lspconfig")
      local schemastore = require("schemastore")
      local cmp = require("cmp")

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
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
                  schemas = schemastore.json.schemas(),
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
        lsp_as_default_formatter = false,
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
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Telescope grep" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Telescope help" },
      { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Telescope man" },
      --{ 'gd', '<cmd>Telescope lsp_definitions<cr>', desc = 'Telescope definitions' },
      --{ 'gi', '<cmd>Telescope implementations<cr>', desc = 'Telescope implementations' },
      --{ '<leader>dl', '<cmd>Telescope diagnostics<cr>', desc = 'Telescope diagnostics' },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "muniftanjim/nui.nvim",
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
    enabled = false,
    config = function()
      require("presence"):setup({
        show_time = false,
        neovim_image_text = "Neovim",
        log_level = "debug",
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
    config = function()
      require("scrollbar").setup({
        handle = {
          color = require("nord.colors").nord2_gui,
        },
        handlers = {
          search = true,
        },
      })
    end,
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
})
