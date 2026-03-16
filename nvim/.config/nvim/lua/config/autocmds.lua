local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  vim.api.nvim_create_augroup("Setup" .. name, { clear = true })
end

autocmd("FileType", {
  group = augroup("CloseWindow"),
  pattern = {
    "help",
    "notify",
    "checkhealth",
    "grug-far",
    "lazy",
    "qf",
    "snacks_notif_history",
  },
  desc = "Close window",
  callback = function(event)
    function close()
      vim.api.nvim_win_close(0, true)
      pcall(function()
        vim.api.nvim_buf_delete(event.buf, { force = true })
      end)
    end

    vim.keymap.set("n", "q", close, {
      desc = "Close buffer",
      buffer = event.buf,
    })

    vim.keymap.set("n", "<Esc>", close, {
      desc = "Close buffer",
      buffer = event.buf,
    })
  end,
})

autocmd({ "BufReadPre", "BufNew" }, {
  group = augroup("EnvrcBashFiletype"),
  pattern = ".envrc*",
  command = "set filetype=bash",
})

autocmd("TextYankPost", {
  group = augroup("HighlightYank"),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "PmenuSel",
      timeout = 200,
    })
  end,
})

autocmd("FileType", {
  group = augroup("FormatOptions"),
  pattern = "*",
  callback = function()
    -- never continue comment on pressing o or O in normal mode
    vim.opt.formatoptions:remove("o")
  end,
})

-- insert blank line after git commit message area
autocmd("VimEnter", {
  group = augroup("GitCommitInsertLine"),
  pattern = "COMMIT_EDITMSG",
  callback = function()
    if vim.fn.getline(1) == "" then
      vim.fn.append(1, "")
    end
  end,
})
