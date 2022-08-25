-- fix blinking cursor after exiting Neovim in Windows Terminal
vim.cmd('au VimLeave * set guicursor=a:block-blinkon1')

-- press q to close help
vim.cmd('au FileType help nmap <silent> <buffer> q :q<CR>')

-- detect jsonnet files
vim.cmd('au BufRead,BufNewFile *.jsonnet,*.libsonnet set filetype=jsonnet')

-- vim.cmd('au FileType c set tabstop=4<CR>')
