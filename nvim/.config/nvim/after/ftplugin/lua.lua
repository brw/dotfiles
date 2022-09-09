local opt = vim.opt_local
opt.formatoptions = opt.formatoptions - 'o'

-- set indentation for Lua until https://github.com/sumneko/lua-language-server/issues/1068 is fixed
opt.shiftwidth = 2
opt.softtabstop = 2

opt.suffixesadd:prepend('.lua')
opt.suffixesadd:prepend('init.lua')
opt.path:prepend(vim.fn.stdpath('config') .. '/lua')
