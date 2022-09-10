-- press q to close help
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = 'nmap <silent> <buffer> q :q<CR>',
})

-- prevent fidget from throwing a fit if you exit it while it's doing shit
vim.api.nvim_create_autocmd('VimLeavePre', { command = [[silent! FidgetClose]] })
