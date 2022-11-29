-- press q to close help
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  command = 'nmap <silent> <buffer> q :q<CR>',
})
