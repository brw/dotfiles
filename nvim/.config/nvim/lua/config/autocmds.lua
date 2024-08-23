local group = vim.api.nvim_create_augroup("yeet", { clear = true })

-- press q to close help
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "nmap <silent> <buffer> q :q<CR>",
  group = group,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = ".envrc*",
  command = "set filetype=bash",
  group = group,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "Normal",
      timeout = 200,
    })
  end,
  group = group,
})
