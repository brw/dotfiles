local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = true
  fn.system({ 'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim' }

    use {
      'folke/which-key.nvim',
      config = function()
        require('which-key').setup {
          window = { border = 'single' },
        }
      end,
    }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
      after = { 'nord.nvim' },
      config = function()
        local empty = {
          function()
            return ' '
          end,
          padding = 0,
          color = 'Normal',
        }
        require('lualine').setup {
          options = {
            theme = 'nord',
            component_separators = '|',
            section_separators = { left = '', right = '' },
            globalstatus = true,
          },
          sections = {
            lualine_a = {
              empty,
              empty,
              { 'mode', separator = { left = '' }, padding = { left = 1, right = 2 } },
            },
            lualine_b = {
              { 'filename' },
              -- TODO: figure out why the branch plugin only loads after a :PackerCompile
              -- { 'branch' },
              { 'b:gitsigns_head', icon = '' },
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
              empty,
              empty,
            },
          },
        }
      end,
    }

    use {
      'shaunsingh/nord.nvim',
      config = function()
        vim.g.nord_borders = true
        vim.g.nord_italic = false
        require('nord').set()
      end,
    }

    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    }

    use {
      'pwntester/octo.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require('octo').setup()
      end,
    }

    use {
      'andweeb/presence.nvim',
      config = function()
        require('presence'):setup({
          show_time = false,
          neovim_image_text = 'Neovim',
        })
      end,
    }

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
          -- ensure_installed = 'all',
          sync_install = false,
          auto_install = true,
          highlight = {
            enable = true,
            disable = { 'gitcommit' },
          },
          -- indent = {
          --   enable = true,
          -- },
        }
      end,
    }

    use {
      'nvim-treesitter/nvim-treesitter-textobjects',
      after = { 'nvim-treesitter' },
      config = function()
        require('nvim-treesitter.configs').setup {
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
      end,
    }

    use {
      'kevinhwang91/nvim-hlslens',
      config = function()
        require('hlslens').setup {
          calm_down = true,
        }
      end,
    }

    use {
      'petertriho/nvim-scrollbar',
      after = { 'nord.nvim', 'nvim-hlslens' },
      config = function()
        require('scrollbar').setup {
          handle = {
            color = require('nord.colors').nord2_gui,
          },
          handlers = {
            search = true,
          },
        }
      end,
    }

    -- use { 'tpope/vim-repeat' }
    use {
      -- 'tpope/vim-surround'
      'kylechui/nvim-surround',
      config = function()
        require('nvim-surround').setup()
      end,
    }

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    }

    use {
      'akinsho/toggleterm.nvim',
      config = function()
        require('toggleterm').setup {
          shade_terminals = false,
        }
      end,
    }

    use {
      'zegervdv/nrpattern.nvim',
      config = function()
        require('nrpattern').setup()
      end,
    }

    --[[ use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
          'neovim/nvim-lspconfig',
          'williamboman/mason.nvim',
          'williamboman/mason-lspconfig.nvim',

          'hrsh7th/nvim-cmp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'saadparwaiz1/cmp_luasnip',
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-nvim-lua',

          'L3MON4D3/LuaSnip',
          'rafamadriz/friendly-snippets',
        },
        config = function()
          local lsp = require('lsp-zero')

          lsp.preset('recommended')
          lsp.setup()
        end
      } ]]
    use {
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup()
      end,
    }

    use {
      'williamboman/mason-lspconfig.nvim',
      requires = { 'neovim/nvim-lspconfig', 'b0o/SchemaStore.nvim' },
      after = { 'coq_nvim', 'neodev.nvim', 'mason.nvim' },
      config = function()
        local lsp_formatting = function(bufnr)
          vim.lsp.buf.format({
            filter = function(client)
              return client.name == 'null-ls' or client.name == 'lua_ls' or client.name == 'tsserver' or
                  client.name == 'jsonnet_ls'
            end,
            bufnr = bufnr,
          })
        end
        local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
        local on_attach = function(client, bufnr)
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                if client.name ~= 'clangd' then
                  lsp_formatting(bufnr)
                end
              end,
            })
          end
        end
        local lsp_opts = {
          on_attach = on_attach,
          settings = {
            Lua = {
              format = {
                enable = true,
              },
              workspace = {
                library = {
                  '${3rd}/luassert/library',
                },
                checkThirdParty = false,
              },
            },
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        }
        local coq = require('coq')
        require('mason-lspconfig').setup()
        require('mason-lspconfig').setup_handlers {
          function(server_name)
            require('lspconfig')[server_name].setup(coq.lsp_ensure_capabilities(lsp_opts))
          end,
        }
      end,
    }

    use {
      'jayp0521/mason-nvim-dap.nvim',
      after = { 'mason.nvim', 'nvim-dap' },
      config = function()
        require('mason-nvim-dap').setup({
          ensure_installed = { 'cppdbg' },
          handlers = {
            function(config)
              require('mason-nvim-dap').default_setup(config)
            end,
            cppdbg = function(config)
              config.configurations = {
                {
                  name = 'Launch file',
                  type = 'cppdbg',
                  request = 'launch',
                  program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  end,
                  cwd = '${workspaceFolder}',
                  stopAtEntry = true,
                  MIMode = 'gdb',
                },
              }

              require('mason-nvim-dap').default_setup(config)
            end,
          },
        })
      end,
    }

    use {
      'ms-jpq/coq_nvim',
      requires = { 'ms-jpq/coq.artifacts' },
      config = function()
        vim.g.coq_settings = {
          auto_start = 'shut-up',
          display = { icons = { mode = 'short' } },
          limits = { completion_auto_timeout = 0.5 },
          keymap = { recommended = false },
        }
        require('coq')
      end,
    }

    use {
      'ms-jpq/coq.thirdparty',
      after = { 'coq_nvim' },
      config = function()
        require('coq_3p') {}
      end,
    }

    use {
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup()
      end,
    }

    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end,
    }

    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup {
          easing_function = 'quadratic',
        }
      end,
    }

    use {
      'rcarriga/nvim-notify',
      config = function()
        require('notify').setup {
          minimum_width = 16,
          max_width = 64,
          max_height = 10,
          on_open = function(win)
            vim.api.nvim_win_set_option(win, 'winblend', 40)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
            vim.api.nvim_win_set_option(win, 'wrap', true)
          end,
        }
        vim.notify = require('notify')
      end,
    }

    -- use {
    --   'lewis6991/impatient.nvim',
    --   config = function()
    --     require('impatient')
    --   end,
    -- }

    use { 'tpope/vim-sleuth' }

    -- use { 'JopjeKnopje/42header_codam' }
    use {
      'brw/42header_codam',
      branch = 'improve-ascii-art',
    }

    use {
      'sindrets/diffview.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    }

    use {
      'TimUntersberger/neogit',
      config = function()
        require('neogit').setup {
          commit_popup = {
            kind = 'floating',
          },
          popup = {
            kind = 'floating',
          },
        }
      end,
    }

    use {
      'folke/neodev.nvim',
      after = { 'nvim-lspconfig' },
      config = function()
        require('neodev').setup({})
      end,
    }

    use {
      'lewis6991/hover.nvim',
      config = function()
        require('hover').setup {
          init = function()
            require('hover.providers.lsp')
          end,
        }
        vim.keymap.set('n', 'K', require('hover').hover, { desc = 'hover.nvim' })
        vim.keymap.set('n', 'gK', require('hover').hover_select, { desc = 'hover.nvim select' })
      end,
    }

    use {
      'lambdalisue/suda.vim',
      config = function()
        vim.g.suda_smart_edit = true
      end,
    }

    use { 'cacharle/c_formatter_42.vim' }

    use { 'mfussenegger/nvim-dap' }

    use {
      'ldelossa/nvim-dap-projects',
      requires = { 'nvim-dap' },
      config = function()
        require('nvim-dap-projects').search_project_config()
      end,
    }

    use {
      'rcarriga/nvim-dap-ui',
      after = { 'nvim-dap' },
      config = function()
        require('dapui').setup()
      end,
    }

    use {
      'theHamsta/nvim-dap-virtual-text',
      config = function()
        require('nvim-dap-virtual-text').setup {}
      end,
    }

    use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        local null_ls = require('null-ls')
        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.prettierd,
          },
        })
      end,
    }

    use { 'gpanders/editorconfig.nvim' }

    use {
      'folke/trouble.nvim',
      requires = 'nvim-tree/nvim-web-devicons',
      config = function()
        require('trouble').setup {}
      end,
    }

    use {
      'akinsho/git-conflict.nvim',
      after = { 'nord.nvim' },
      config = function()
        require('git-conflict').setup {
          default_mappings = {
            ours = '<Leader>o',
            theirs = '<Leader>t',
            none = '<Leader>0',
            both = '<Leader>b',
            next = '<Leader>n',
            prev = '<Leader>p',
          },
        }
      end,
    }

    use { 'xorid/swap-split.nvim' }

    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    display = {
      -- open_cmd = 'vnew \\[packer\\]',
      open_fn = require('packer.util').float,
    },
  },
}
