vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.mousemoveevent = true
vim.o.cursorline = true
vim.o.title = true
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 10
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.laststatus = 3
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 8
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.undoreload = 100000
-- vim.o.clipboard = 'unnamedplus'
vim.o.inccommand = "split"
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.foldenable = false
vim.o.backupcopy = "yes"
-- https://github.com/VoidAlone/nihilvim/blob/fbe1f1f455bd3cbea24a11c425684d2458b5ceaa/lua/core/options.lua#L15
vim.o.linebreak = true
vim.o.showbreak = "↪ "

vim.opt.sessionoptions:append("winpos,localoptions,globals")

vim.g.mapleader = ","
vim.g.maplocalleader = " "

vim.g.man_hardwrap = false

vim.g.user42 = "bvan-den"
vim.g.mail42 = "bvan-den@student.codam.nl"

-- https://github.com/tmux/tmux/pull/4190
if vim.env.SSH_TTY then
  -- local function paste()
  --   return {
  --     vim.split(vim.fn.getreg(""), "\n"),
  --     vim.fn.getregtype(""),
  --   }
  -- end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      -- ["+"] = paste,
      -- ["*"] = paste,
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
