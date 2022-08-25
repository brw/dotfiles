-- options
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.cursorline = true
opt.title = true
opt.timeoutlen = 1000
opt.ttimeoutlen = 10
opt.splitbelow = true
opt.splitright = true
opt.laststatus = 3
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.scrolloff = 8
opt.undofile = true
opt.clipboard = 'unnamedplus'
opt.inccommand = 'split'
opt.formatoptions = opt.formatoptions - 'o'
opt.termguicolors = true
opt.tabstop = 4
opt.shiftwidth = 4

local g = vim.g
g.mapleader = ' '
