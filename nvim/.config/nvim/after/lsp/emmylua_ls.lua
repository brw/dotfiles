---@type vim.lsp.Config
return {
  ---@type lsp.emmylua_ls
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        requirePattern = {
          "lua/?.lua",
          "lua/?/init.lua",
          "?/lua/?.lua",
          "?/lua/?/init.lua",
          "?/lsp/?.lua",
        },
      },
      workspace = {
        library = vim.list_extend({
          "$VIMRUNTIME",
          "$LLS_Addons/luvit",
          "$HOME/.local/share/nvim/lazy",
        }, vim.api.nvim_get_runtime_file("", true)),
        ignoreGlobs = { "**/*_spec.lua" },
      },
    },
  },
}
