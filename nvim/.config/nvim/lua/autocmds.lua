-- fix blinking cursor after exiting Neovim in Windows Terminal
vim.cmd('au VimLeave * set guicursor=a:block-blinkon1')
-- TODO: figure out why this doesn't work
-- vim.api.nvim_create_autocmd('VimLeave', { command = 'set guicursor=a:block-blinkon1' })

-- press q to close help
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = 'nmap <silent> <buffer> q :q<CR>',
})

-- prevent fidget from throwing a fit if you exit it while it's doing shit
vim.api.nvim_create_autocmd('VimLeavePre', { command = [[silent! FidgetClose]] })
