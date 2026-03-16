---@type LazySpec
return {
  {
    "nvim-lua/plenary.nvim",
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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
    enabled = true,
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<M-CR>",
          accept_word = "<M-.>",
          clear_suggestion = "<M-]>",
        },
        ignore_filetypes = { "grug-far" },
      })
    end,
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
    "nvim-neo-tree/neo-tree.nvim",
    event = { "BufEnter" },
    branch = "v3.x",
    dependencies = {
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
        renderers = {
          directory = {
            { "indent" },
            { "icon" },
            { "current_filter" },
            {
              "container",
              content = {
                { "name", zindex = 10 },
                {
                  "symlink_target",
                  zindex = 10,
                  highlight = "NeoTreeSymbolicLinkTarget",
                },
                { "clipboard", zindex = 10 },
                { "diagnostics", errors_only = false, zindex = 20, align = "right", hide_when_expanded = true },
                { "git_status", zindex = 10, align = "right", hide_when_expanded = true },
                { "file_size", zindex = 10, align = "right" },
                { "type", zindex = 10, align = "right" },
                { "last_modified", zindex = 10, align = "right" },
                { "created", zindex = 10, align = "right" },
              },
            },
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
    event = "VeryLazy",
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
    enabled = false,
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
          vim.api.nvim_set_option_value("wrap", true, { scope = "local", win = win })
        end,
        merge_duplicates = false,
      })
    end,
  },

  {
    "folke/noice.nvim",
    enabled = true,
    dependencies = {
      "muniftanjim/nui.nvim",
      "smjonas/inc-rename.nvim",
    },
    ---@type NoiceConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      routes = {
        {
          view = "notify",
          filter = {
            event = "msg_show",
            kind = { "", "echo", "echomsg", "lua_print", "list_cmd" },
          },
        },
      },
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
      ---@diagnostic disable-next-line: missing-fields
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      popupmenu = {
        backend = "nui", -- cmp seems broken?
      },
    },
  },

  { "stevearc/dressing.nvim" },

  {
    -- "andweeb/presence.nvim",
    "jiriks74/presence.nvim",
    enabled = true,
    config = function()
      require("presence").setup({
        show_time = true,
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
    "mrcjkb/nvim-lastplace",
  },

  {
    "kylechui/nvim-surround",
    ---@type user_options
    opts = {
      surrounds = {
        ["k"] = {
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "af" })
          end,
        },
      },
    },
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
    event = "VeryLazy",
    config = true,
  },

  {
    "JopjeKnopje/42header_codam",
    enabled = false,
    cmd = { "Stdheader" },
    keys = {
      { "<F1>", "<Cmd>Stdheader<CR>", desc = "Insert Codam header" },
    },
  },

  {
    "cacharle/c_formatter_42.vim",
    enabled = false,
    cmd = { "CFormatter42" },
    keys = {
      { "<F2>", "<Cmd>CFormatter42<CR>", desc = "Format C code" },
    },
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
        enable_tailwind = false,
        exclude_filetypes = { "gitcommit", "lazy", "help" },
      })
    end,
  },

  {
    "xorid/swap-split.nvim",
    config = function()
      require("swap-split").setup({
        ignore_filetypes = { "NvimTree", "neo-tree", "notify", "snacks_notif", "toggleterm", "Trouble", "qf" },
      })
    end,
  },

  {
    "lambdalisue/vim-suda",
    init = function()
      vim.g.suda_smart_edit = true
      vim.g.suda_nopass = true
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
    enabled = false,
    main = "session_manager",
    opts = function()
      local config = require("session_manager.config")
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
    "rmagatti/auto-session",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/downloads" },
      args_allow_single_directory = false,
      session_lens = {
        previewer = "summary",
        picker = "telescope",
        picker_opts = {
          preview = true,
        },
      },
    },
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
        copy_sync = {
          sync_clipboard = false,
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
    "nanozuki/tabby.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("tabby").setup({})
    end,
  },

  {
    "tzachar/highlight-undo.nvim",
    keys = { "u", "<C-r>", "p", "P" },
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
    "OXY2DEV/helpview.nvim",
    enabled = false,
    ft = "help",
  },

  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 38
      vim.g.undotree_DiffpanelHeight = 14
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_DiffCommand = "diff"
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    opts = {
      debug = false,
      default_mappings = true, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
      list_opener = "copen", -- command or function to open the conflicts list
      highlights = { -- They must have background color, otherwise the default color will be used
        incoming = "DiffAdd",
        current = "DiffText",
        ancestor = "DiffChange",
      },
    },
  },

  {
    "MagicDuck/grug-far.nvim",
    ---@type grug.far.OptionsOverride
    opts = {
      windowCreationCommand = "split",
      transient = true,
    },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  {
    "DNLHC/glance.nvim",
    config = true,
  },

  {
    "stevearc/aerial.nvim",
    config = true,
  },

  {
    "isak102/ghostty.nvim",
    config = true,
  },

  {
    "chrisgrieser/nvim-recorder",
    config = true,
  },

  {
    "mcauley-penney/tidy.nvim",
    config = true,
  },

  {
    "saghen/blink.indent",
    init = function()
      ---@type Nord.Palette
      local nord = require("nord.colors").palette

      vim.api.nvim_set_hl(0, "BlinkIndent", { fg = nord.polar_night.brighter })
      vim.api.nvim_set_hl(0, "BlinkIndentScope", { fg = nord.polar_night.light })
    end,
    opts = {
      static = {
        char = "▏",
      },
      scope = {
        char = "▏",
        highlights = { "BlinkIndentScope" },
      },
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      notifier = {
        enabled = true,
        timeout = 5000,
        keep = function(_notif)
          return vim.fn.getcmdpos() > 0
        end,
      },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
      terminal = {},
    },
  },

  {
    "HawkinsT/pathfinder.nvim",
    opts = {},
  },

  {
    "relf108/nvim-unstack",
    opts = {},
  },

  {
    "kokusenz/deltaview.nvim",
    opts = {},
  },
}
