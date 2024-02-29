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

local lsp_fmt_group = vim.api.nvim_create_augroup('LspFormattingGroup', {})

vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function(ev)
    local efm = vim.lsp.get_active_clients({ name = 'efm', bufnr = ev.buf })

    if vim.tbl_isempty(efm) then
      return
    end

    vim.lsp.buf.format({ name = 'efm' })
  end,
  group = lsp_fmt_group,
})
