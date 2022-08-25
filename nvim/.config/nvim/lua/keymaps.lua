local map = vim.keymap.set
local silent = { silent = true }

map('n', 'n', "<Cmd>silent execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>", silent)
map('n', 'N', "<Cmd>silent execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>", silent)
map('n', '*', "*<Cmd>lua require('hlslens').start()<CR>", silent)
map('n', '#', "#<Cmd>lua require('hlslens').start()<CR>", silent)
map('n', 'g*', "g*<Cmd>lua require('hlslens').start()<CR>", silent)
map('n', 'g#', "g#<Cmd>lua require('hlslens').start()<CR>", silent)
map('n', '<Esc>', ':noh<CR>', silent)

map('n', '<C-k>', '<C-w><C-k>')
map('n', '<C-j>', '<C-w><C-j>')
map('n', '<C-l>', '<C-w><C-l>')
map('n', '<C-h>', '<C-w><C-h>')
