---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "Myzel394/jsonfly.nvim",
    },
    cmd = { "Telescope" },
    keys = {
      { "<C-t><C-l>", "<cmd>Telescope resume<CR>", desc = "Telescope resume" },
      { "<C-t><C-p>", "<cmd>Telescope find_files<CR>", desc = "Telescope find files" },
      { "<C-t><C-t>", "<cmd>Telescope buffers<CR>", desc = "Telescope buffers" },
      { "<C-t><C-g>", "<cmd>Telescope live_grep<CR>", desc = "Telescope grep" },
      { "<C-t><C-k>", "<cmd>Telescope help_tags<CR>", desc = "Telescope help" },
      { "<C-t><C-m>", "<cmd>Telescope man_pages<CR>", desc = "Telescope man" },
      --{ 'gd', '<cmd>Telescope lsp_definitions<CR>', desc = 'Telescope definitions' },
      --{ 'gi', '<cmd>Telescope implementations<CR>', desc = 'Telescope implementations' },
      { "<C-t><C-d>", "<cmd>Telescope diagnostics<CR>", desc = "Telescope diagnostics" },
      { "<C-t><C-f>", "<cmd>Telescope file_browser<CR>", desc = "Telescope file browser" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          file_ignore_patterns = { "%.git/" },
          mappings = {
            i = {
              ["<C-f>"] = require("telescope.actions").to_fuzzy_refine,
            },
          },
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
      })
    end,
  },

  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          undo = {
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.6,
            },
            mappings = {
              i = {
                ["<CR>"] = require("telescope-undo.actions").restore,
                ["C-y"] = require("telescope-undo.actions").yank_additions,
                ["C-s"] = require("telescope-undo.actions").yank_deletions,
              },
            },
          },
        },
      })

      require("telescope").load_extension("undo")
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
}
