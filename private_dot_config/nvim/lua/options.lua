-- Needed for nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neovide
vim.o.guifont = "Hack,Noto_Color_Emoji:h10:b" -- text below applies for VimScript

-- vim
vim.cmd([[setlocal spell spelllang=en_us]])

-- Set up line numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 4

-- Handle indentation
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true

-- Bottom line
vim.o.showmode = true
vim.o.showcmd = true
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.o.ruler = true
vim.o.cursorline = true

-- Searching
vim.o.hlsearch = true
vim.o.incsearch = true

-- Folding
vim.opt.foldmethod = "manual"
vim.opt.foldenable = false

-- Misc
vim.o.wrap = true
vim.o.mouse = "a"
vim.o.visualbell = true
vim.o.foldmethod = "indent"
vim.o.background = "dark"
vim.o.autoread = true
vim.o.encoding = "utf-8"
vim.o.syntax = "on"
vim.o.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.scrolloff = 3
vim.opt.sidescroll = 3
vim.opt.updatetime = 100

vim.cmd.colorscheme("catppuccin")

vim.opt.termguicolors = true
