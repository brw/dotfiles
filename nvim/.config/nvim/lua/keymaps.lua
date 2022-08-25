local map = vim.keymap.set
local silent = { silent = true }
local expr = { expr = true }

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

--map('i', '<Esc>', 'pumvisible() ? "<C-e><Esc>" : "<Esc>"', { silent = true, expr = true } )
--map('i', '<C-c>', 'pumvisible() ? "<C-e><C-c>" : "<C-c>"', { silent = true, expr = true } )
--map('i', '<BS>', 'pumvisible() ? "<C-e><BS>" : "<BS>"', { silent = true, expr = true } )
map('i', '<BS>', '\\<lt>BS>', { expr = true } )

--map('i', '<CR>', 'pumvisible() ? (complete_info().selected == -1 ? "<C-e><CR>" : "<C-y>") : "<CR>', { silent = true, expr = true } )
