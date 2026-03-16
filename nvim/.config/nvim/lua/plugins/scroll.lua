---@type LazySpec
return {
  {
    "karb94/neoscroll.nvim",
    enabled = false,
    keys = {
      {
        "<C-u>",
        function()
          require("neoscroll").ctrl_u({ duration = 150 })
        end,
        desc = "Scroll up",
        mode = { "n", "v", "x" },
      },
      {
        "<C-d>",
        function()
          require("neoscroll").ctrl_d({ duration = 150 })
        end,
        desc = "Scroll down",
        mode = { "n", "v", "x" },
      },
      {
        "<C-y>",
        function()
          require("neoscroll").scroll(-0.1, { duration = 50 })
        end,
        desc = "Scroll up slightly",
        mode = { "n", "v", "x" },
      },
      {
        "<C-e>",
        function()
          require("neoscroll").scroll(0.1, { duration = 50 })
        end,
        desc = "Scroll down slightly",
        mode = { "n", "v", "x" },
      },
    },
    config = function()
      require("neoscroll").setup({
        easing_function = "quadratic",
        mappings = {},
        ignored_events = {},
      })
    end,
  },

  {
    "lewis6991/satellite.nvim",
    enabled = false,
  },

  -- {
  --   "petertriho/nvim-scrollbar",
  --   dependencies = {
  --     "kevinhwang91/nvim-hlslens",
  --   },
  --   config = function()
  --     require("scrollbar").setup({
  --       folds = false,
  --       handle = {
  --         color = require("nord.colors").palette.polar_night.brighter,
  --       },
  --       handlers = {
  --         -- search = true,
  --       },
  --     })
  --   end,
  -- },
  --
  -- {
  --   "dstein64/nvim-scrollview",
  --   config = function()
  --     require("scrollview").setup({
  --       winblend_gui = 20,
  --       excluded_filetypes = { "neo-tree" },
  --       floating_windows = true,
  --     })
  --   end,
  -- },
  --
  -- {
  --   "kevinhwang91/nvim-hlslens",
  --   keys = {
  --     { "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>" },
  --     { "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>" },
  --     { "*", "*<Cmd>lua require('hlslens').start()<CR>" },
  --     { "#", "#<Cmd>lua require('hlslens').start()<CR>" },
  --     { "g*", "g*<Cmd>lua require('hlslens').start()<CR>" },
  --     { "g#", "g#<Cmd>lua require('hlslens').start()<CR>" },
  --   },
  --   config = true,
  -- },
}
