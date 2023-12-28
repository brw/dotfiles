local map = vim.keymap.set
local silent = { silent = true }

-- map('n', 'n', "<Cmd>silent execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', 'N', "<Cmd>silent execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', '*', "*<Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', '#', "#<Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', 'g*', "g*<Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', 'g#', "g#<Cmd>lua require('hlslens').start()<CR>", silent)
-- map('n', '<Esc>', '<Cmd>noh<CR>', silent)

map("n", "<M-h>", "<Cmd>wincmd h<CR>")
map("n", "<M-j>", "<Cmd>wincmd j<CR>")
map("n", "<M-k>", "<Cmd>wincmd k<CR>")
map("n", "<M-l>", "<Cmd>wincmd l<CR>")

map("t", "<M-h>", "<Cmd>wincmd h<CR>")
map("t", "<M-j>", "<Cmd>wincmd j<CR>")
map("t", "<M-k>", "<Cmd>wincmd k<CR>")
map("t", "<M-l>", "<Cmd>wincmd l<CR>")

vim.cmd('ino <silent><expr> <Esc> pumvisible() ? "\\<C-e><Esc>" : "\\<Esc>"')
vim.cmd('ino <silent><expr> <C-c> pumvisible() ? "\\<C-e><C-c>" : "\\<C-c>"')
vim.cmd('ino <silent><expr> <BS> pumvisible() ? "\\<C-e><BS>"  : "\\<BS>"')
vim.cmd(
  'ino <silent><expr> <CR> pumvisible() ? (complete_info().selected == -1 ? "\\<C-e><CR>" : "\\<C-y>") : "\\<CR>"'
)

map("n", "<M-s>", "<cmd>SwapSplit<CR>")

map("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd.nohlsearch()
  else
    require("noice").cmd("dismiss")
  end
end, silent)
