local map = vim.keymap.set
local silent = { silent = true }

-- map('n', 'n', "<Cmd>silent execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', 'N', "<Cmd>silent execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', '*', "*<Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', '#', "#<Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', 'g*', "g*<Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', 'g#', "g#<Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', '<Esc>', '<Cmd>noh<CR>', silent)

map('n', '<C-k>', '<C-w><C-k>')
map('n', '<C-j>', '<C-w><C-j>')
map('n', '<C-l>', '<C-w><C-l>')
map('n', '<C-h>', '<C-w><C-h>')

map('n', '<C-s>', 'zH')
map('n', '<C-y>', 'zL')

-- why does this not work :(
--map('i', '<Esc>', 'pumvisible() ? "<C-e><Esc>" : "<Esc>"', { silent = true, expr = true } )
--map('i', '<C-c>', 'pumvisible() ? "<C-e><C-c>" : "<C-c>"', { silent = true, expr = true } )
--map('i', '<BS>', 'pumvisible() ? "<C-e><BS>" : "<BS>"', { silent = true, expr = true } )
--map('i', '<CR>', 'pumvisible() ? (complete_info().selected == -1 ? "<C-e><CR>" : "<C-y>") : "<CR>', { silent = true, expr = true } )
vim.cmd('ino <silent><expr> <Esc>   pumvisible() ? "\\<C-e><Esc>" : "\\<Esc>"')
vim.cmd('ino <silent><expr> <C-c>   pumvisible() ? "\\<C-e><C-c>" : "\\<C-c>"')
vim.cmd('ino <silent><expr> <BS>    pumvisible() ? "\\<C-e><BS>"  : "\\<BS>"')
vim.cmd('ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\\<C-e><CR>" : "\\<C-y>") : "\\<CR>"')

--map('n', '<leader>s', '<cmd>SwapSplit<CR>')

map('n', '<Esc>', function()
  vim.cmd.nohlsearch()
  require('noice').cmd('dismiss')
end, silent)

-- use <C-N> and <C-P> for next/prev.
map("n", "<C-N>", "<CMD>QNext<CR>")
map("n", "<C-P>", "<CMD>QPrev<CR>")
-- toggle the quickfix open/closed without jumping to it
map("n", "<leader>q", "<CMD>QFToggle!<CR>")
map("n", "<leader>l", "<CMD>LLToggle!<CR>")
