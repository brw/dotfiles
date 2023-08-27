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

local empty_section = {
  function()
    return ' '
  end,
  padding = 1,
  color = 'Normal',
}

require('lazy').setup({
  {
    'shaunsingh/nord.nvim',
    priority = 1000,
    init = function()
      vim.g.nord_borders = true -- border between splits
      vim.g.nord_italic = false
    end,
    config = function()
      vim.cmd([[colorscheme nord]])
    end
  },

  {
    'folke/which-key.nvim',
    opts = {
      window = {
        border = 'single'
      }
    }
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'nord',
        component_separators = '|',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          empty_section,
          { 'mode', separator = { left = '' }, padding = { left = 1, right = 2 } },
        },
        lualine_b = {
          { 'filename' },
          { 'branch' },
          { 'diff' },
          { 'diagnostics' },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          { 'filetype' },
          { 'fileformat', icons_enabled = false },
          { 'progress' },
        },
        lualine_z = {
          { 'location', separator = { right = '' } },
          empty_section,
        },
      },
    }
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'lua', 'vim', 'vimdoc', 'bash', 'fish', 'diff', 'git_config',
          'git_rebase', 'json', 'jsonc', 'markdown', 'markdown_inline', 'regex'
        },
        auto_install = true,
        highlight = {
          enable = true,
          disable = { 'gitcommit' },
        },
        --[[
        indent = {
          enable = true,
        },
        ]]
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@comment.outer',
            },
            selection_modes = {
              ['@function.outer'] = 'V',
              ['@function.inner'] = 'V',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
            },
          },
        },
      }
    end
  },

  {
    'wansmer/treesj',
    keys = {
      {
        '<leader>s',
        function()
          require('treesj').toggle({ split = { recursive = true } })
        end,
        desc = 'Toggle node (split/join)',
      },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 600,
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Telescope find files' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Telescope buffers' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Telescope grep' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Telescope help' },
      { '<leader>fm', '<cmd>Telescope man_pages<cr>', desc = 'Telescope man' },
      { 'gd', '<cmd>Telescope lsp_definitions<cr>', desc = 'Telescope definitions' },
      { 'gi', '<cmd>Telescope implementations<cr>', desc = 'Telescope implementations' },
      { '<leader>dl', '<cmd>Telescope diagnostics<cr>', desc = 'Telescope diagnostics' },
    }
  },

  {
    'folke/noice.nvim',
    dependencies = {
      'muniftanjim/nui.nvim',
      'rcarriga/nvim-notify',
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
        inc_rename = true
      }
    },
  },

  {
    'andweeb/presence.nvim',
    enabled = false,
    config = function()
      require('presence'):setup({
        show_time = false,
        neovim_image_text = 'Neovim',
        log_level = 'debug'
      })
    end,
  },

  {
    'petertriho/nvim-scrollbar',
    opts = function()
      require('scrollbar').setup {
        handle = {
          color = require('nord.colors').nord2_gui,
        },
        handlers = {
          search = true,
        },
      }
    end,
  },

  {
    'kylechui/nvim-surround',
    config = true,
  },

  {
    'numtostr/comment.nvim',
    config = true,
  },

  {
    'zegervdv/nrpattern.nvim',
    config = true,
  },

  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = true,
  },

  {
    'lewis6991/gitsigns.nvim',
    config = true,
  },

  {
    'karb94/neoscroll.nvim',
    opts = {
      easing_function = 'quadratic',
    }
  },

  {
    'JopjeKnopje/42header_codam',
  }
})
