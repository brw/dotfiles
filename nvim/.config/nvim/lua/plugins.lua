local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = true
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

require('packer').startup({function(use)
  use 'wbthomason/packer.nvim'
  use 'shaunsingh/nord.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons'
    }
  }
  use 'folke/which-key.nvim'
  -- use 'andweeb/presence.nvim'
  use 'WilliamWelsh/presence.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'kevinhwang91/nvim-hlslens'
  use 'petertriho/nvim-scrollbar'
  -- use 'tpope/vim-surround'
  use 'kylechui/nvim-surround'
  use 'tpope/vim-repeat'
  use 'numtostr/comment.nvim'
  use 'akinsho/toggleterm.nvim'
  use 'zegervdv/nrpattern.nvim'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'ms-jpq/coq_nvim'
  use 'ms-jpq/coq.artifacts'
  use 'ms-jpq/coq.thirdparty'
  use 'j-hui/fidget.nvim'
  -- use 'github/copilot.vim'
  use 'lewis6991/gitsigns.nvim'
  use 'karb94/neoscroll.nvim'
  use 'rcarriga/nvim-notify'
  use 'lewis6991/impatient.nvim'
  use 'tpope/vim-sleuth'
  use 'JopjeKnopje/42header_codam'

  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_cmd = 'vnew \\[packer\\]',
  }
}})

local plugins_no_config = { 'which-key', 'Comment', 'toggleterm', 'nrpattern', 'gitsigns', 'fidget', 'octo', 'nvim-surround' }
for _, plugin in pairs(plugins_no_config) do
  require(plugin).setup()
end

local nord_options = {
  borders = true,
  italic = false,
}

for option, value in pairs(nord_options) do
  vim.g['nord_' .. option] = value
end

require('nord').set()

require('lualine').setup {
  options = {
    theme = 'nord',
    -- component_separators = {left = '', right = ''},
    -- section_separators = {left = '', right = ''},
    globalstatus = true
  }
}

require('presence'):setup({
 show_time = false,
 neovim_image_text = 'Neovim'
})

require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  sync_install = false,
  highlight = {
    enable = true
  }
}

require('toggleterm').setup {
  shade_terminals = false
}

require('scrollbar').setup {
  handle = {
    color = require('nord.colors').nord2_gui
  },
  handlers = {
    search = true
  }
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local lsp_opts = {
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path
        },
        diagnostics = {
          globals = { 'vim' }
        },
        workspace = {
          library = {
            [fn.expand("$VIMRUNTIME/lua")] = true,
            [fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = 'space',
            indent_size = '2'
          }
        }
      }
    }
  }
}

vim.g.coq_settings = {
  auto_start = 'shut-up',
  display = { icons = { mode = 'short' } },
  limits = { completion_auto_timeout = 0.5 },
  keymap = { recommended = false },
}

-- Copilot is bugged with Node 18
-- vim.g.copilot_node_command = '/home/bas/.asdf/installs/nodejs/17.9.0/bin/node'

local lsp_installer = require("nvim-lsp-installer")
local coq = require('coq')

lsp_installer.on_server_ready(function(server)
  local opts = lsp_opts[server.name] or {}

  server:setup(coq.lsp_ensure_capabilities(opts))
end)

require('coq_3p') {
  -- { src = "copilot", short_name = "COP", accept_key = "<c-f>" },
  { src = "nvimlua", short_name = "nLUA" }
}

require('neoscroll').setup {
  easing_function = 'quadratic'
}

require('notify').setup {
  minimum_width = 16,
  on_open = function(win)
    vim.api.nvim_win_set_option(win, 'winblend', 40)
    vim.api.nvim_win_set_config(win, { zindex = 100 })
  end
}

vim.notify = require('notify')
