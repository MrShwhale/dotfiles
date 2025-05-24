require("config.lazy")

-- Needed for nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Transparent background
-- vim.api.nvim_create_autocmd({"ColorScheme"},
-- {
--   pattern = {"*"},
--   command = "highlight Normal ctermbg=NONE guibg=NONE",
-- })

-- lvim.autocommands = {
--     {
--         "FileType",
--         {
--             pattern = { "*.norg" },
--             command = "setlocal expandtab\nsetlocal tabstop = 2\nsetlocal shiftwidth = 2",
--         }
--     }
-- }

-- List of swappable headers
-- local headers = {
--     SCP = {
--         "                 ,#############,                  ",
--         "                 ##           ##                  ",
--         "             m####             ####m              ",
--         "          m##*'        mmm        '*##m           ",
--         "        ###'         mm###mm         '###         ",
--         "      ###        m#############m        ###       ",
--         "     ##       m####*'  ###  '*####        ##      ",
--         "    ##      m####      ###      ####m      ##     ",
--         "   ##      ####      #######      ####      ##    ",
--         "  m#      ###'        #####        '###      #m   ",
--         "  ##     ####           #           ####     ##   ",
--         "  ##     ###    wwwwwwww wwwwwwww    ###     ##   ",
--         "  ##     ###m    ######   ######    m###     ##   ",
--         ",###     '### m#######     #######m ###'     ###, ",
--         "##'      m######'   *       *   '######m      '## ",
--         " ##     *#*'######             ######'*#*     ##  ",
--         "  ##         '#######m     m#######'         ##   ",
--         "   *#m          '###############'          m#*    ",
--         "     ##m ,m,        ''*****''        ,m, m##      ",
--         "      *##'*###m                   m###*'##*       ",
--         "            '*#######m     m#######*'             ",
--         "                   '*#######*'                    ",
--     },
--     Miku_Logo = {
--         "             --------------                               -------------                                                                               ",
--         "             --..........--                               -..........--                                                                               ",
--         "        -------..######..--------------------             -..######..--             ----                                                              ",
--         "        -------..######..----------------------------------..######..----------- ----------                                                           ",
--         "        -:..------=###----...:---------------..-..:-----------=###----------...---...--...--                                                          ",
--         "        -:.#################.#################....############################..-..######..-                                                          ",
--         "        -:.#################.#################....############################..-..######..-                                                          ",
--         "        -:..###############..#################....###########################..--..######..-------------------------    ----------------------------- ",
--         "        ----....+########-....#:#####...######.........:#####*.....######..........######.........................:-- ---..........................---",
--         "        ---...=########-....###+######..######.#################################*..##############################+..---...########################=..-",
--         "       --:..-########=....#####+######..######.##################################..###############################..-...###########################..-",
--         "     --:..:########=....#######-######..######.#################################...##############################.....#############################..-",
--         "   ---...#############-.######..######..######.......##################.........-...............................:-..########+................######..-",
--         " ---...########+.#######=###....######..######..---..#####################*..-------------------------------------..######+..--------------..######..-",
--         "--...########+...#########......######..######..---..#######################:..---...-------------------------:.....####+..--         ---...#######..-",
--         "-..########+..-..###########....######..######..---..######---------=########:..--..############################....##+..---        ---...########...-",
--         "-..######*..---..###########+...######..######..---..###############+..:######..--..############################....-..---        ---...########...---",
--         "-..#####..--- -..######.####+...######..######..---..#################..######..--...--------------------------......---        ---...########...---  ",
--         "-..###..---   -..######...##+...######..######..---..################+..######..----------------------------------.---        ---...########...---    ",
--         "-..-..---     -..######.........######..######..---..######............#######..-.................................--        ---...########...---      ",
--         "-...---       -..######..--.....######..######..---..########################..--..##############################..--     ---...########...---        ",
--         "-.---         -..######..----...######..######..---..#######################..---..###############################..-   ---...########...---          ",
--         "---           -..######..-  --..######..######..---..####################...-----..###############################..- ---...########:..---            ",
--         "-             -..........-  --..................---.....................:----  --...........................######..---...########-..---              ",
--         "              ------------  ----------------------------------------------     --------------------------...######..-...########-..---                ",
--         "                                                                                                        -...######....########-..---                  ",
--         "                                                                                                        -...######..########=..---                    ",
--         "                                                                                                        -...##### ########=..---                      ",
--         "        ##  ##  ####  ######  ####  ##  ## ##  ## ######        ##   ## ###### ##  ## ##  ##            -...##* ########=..---                        ",
--         "        ##  ## ##  ##   ##   ##     ##  ## ### ## ##            ### ###   ##   ## ##  ##  ##            -...-.########+..---                          ",
--         "        ###### ######   ##    ####  ##  ## ## ### ####          ## # ##   ##   ####   ##  ##            --...#######+..---                            ",
--         "        ##  ## ##  ##   ##       ## ##  ## ##  ## ##            ##   ##   ##   ## ##  ##  ##             --...####+..:--                              ",
--         "        ##  ## ##  ##   ##    ####   ####  ##  ## ######        ##   ## ###### ##  ##  ####                --...+..:--                                ",
--         "                                                                                                            ---...--                                  ",
--         "                                                                                                              ----                                    ",
--     }
-- }

-- -- Selected header
-- local header = "Miku_Logo"

-- lvim.builtin.alpha.dashboard.section.header.val = headers[header]

-- -- Bindings
-- vim.g.maplocalleader = "-"

-- lvim.lazy.setup(
--     {
--         git = {
--             throttle = {
--                 enabled = true, -- not enabled by default
--                 -- max 2 ops every 5 seconds
--                 rate = 1,
--                 duration = 15 * 1000, -- in ms
--             },
--         },
--     })

-- lvim.plugins = {
--     -- Formatting
--     {
--         'stevearc/conform.nvim',
--         opts = {},
--     },
--     -- needed for neorg
--     {
--         "vhyrro/luarocks.nvim",
--         lazy = false,
--         priority = 1000,
--         config = true,
--     },
--     -- neorg things
--     {
--         "nvim-neorg/neorg",
--         dependencies = { "luarocks.nvim", "nvim-lua/plenary.nvim" },
--         lazy = false,   -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
--         tag = "v8.9.0", -- Pin Neorg to the latest release available to LunarVim
--         -- build = ":Neorg sync-parsers",
--         config = function()
--             require("neorg").setup {
--                 load = {
--                     ["core.defaults"] = {},
--                     ["core.concealer"] = {},
--                     ["core.integrations.treesitter"] = {},
--                     ["core.autocommands"] = {},
--                     ["core.summary"] = {},
--                     ["core.dirman"] = {
--                         config = {
--                             workspaces = {
--                                 notes = "~/Documents/Neorg/",
--                             },
--                             default_workspace = "notes",
--                         },
--                     },
--                     ["core.ui"] = {},
--                     ["core.ui.calendar"] = {}
--                 },
--             }

--             vim.wo.foldlevel = 99
--             vim.wo.conceallevel = 2
--         end,
--     },
-- }

-- -- Markdown settings
-- require("markdown").setup({
--     mappings = {
--         inline_surround_toggle = "gs",
--         inline_surround_toggle_line = "gss",
--         inline_surround_delete = "ds",
--         inline_surround_change = "cs",
--         link_add = "gl",
--         link_follow = "gx",
--         go_curr_heading = "]c",
--         go_parent_heading = "]p",
--         go_next_heading = "]]",
--         go_prev_heading = "[[",
--     },
--     inline_surround = {
--         emphasis = {
--             key = "i",
--             txt = "*",
--         },
--         strong = {
--             key = "b",
--             txt = "**",
--         },
--         strikethrough = {
--             key = "s",
--             txt = "~~",
--         },
--         code = {
--             key = "c",
--             txt = "`",
--         },
--     },
--     link = {
--         paste = {
--             enable = true,
--         },
--     },
--     toc = {
--         omit_heading = "toc omit heading",
--         omit_section = "toc omit section",
--         markers = { "-" },
--     },
--     hooks = {
--         follow_link = nil,
--     },
--     on_attach = nil,
-- })

local coq = require('coq')

vim.lsp.config('pyright', coq.lsp_ensure_capabilities())
vim.lsp.enable('pyright')

-- lspconfig["lua_ls"].setup {
--     settings = {
--         Lua = {
--             workspace = {
--                 library = {
--                     ['/usr/share/nvim/runtime/lua'] = true,
--                     ['/usr/share/nvim/runtime/lua/lsp'] = true,
--                     ['/usr/share/awesome/lib'] = true
--                 }
--             },
--
--             diagnostics = {
--                 enable = true,
--                 globals = {
--                     -- neovim
--                     "lvim",
--                     "vim",
--
--                     -- awesomewm
--                     "awesome",
--                     "client",
--                     "root",
--                     "screen"
--                 },
--             }
--         }
--     },
-- }

-- Neovide
vim.o.guifont = "Hack,Noto_Color_Emoji:h10:b" -- text below applies for VimScript

-- vim
vim.cmd([[setlocal spell spelllang=en_us]])

-- VIM OPTIONS
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

vim.cmd.colorscheme("catppuccin")

vim.opt.termguicolors = true
require("bufferline").setup{}

-- Kitty scrollback
require('kitty-scrollback').setup()

-- Setup language servers.
-- local lspconfig = require('lspconfig')
-- lspconfig.pyright.setup {}
-- lspconfig.tsserver.setup {}
-- lspconfig.rust_analyzer.setup {
--   -- Server-specific settings. See `:help lspconfig-setup`
--   settings = {
--     ['rust-analyzer'] = {},
--   },
-- }

-- Register helper
local peekup = require('nvim-peekup.config')
peekup.on_keystroke.paste_reg = "+"
peekup.on_keystroke.delay = "300ms"

-- Marks setup
require('marks').setup {
  -- whether to map keybinds or not. default true
  -- TODO actually bind this!!!
  default_mappings = false,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "Group 1",
    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    -- defaults to false.
    annotate = false,
  },
  mappings = {}
}

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- Hop setup
local hop = require('hop')
local directions = require('hop.hint').HintDirection
-- vim.keymap.set('', 'f', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
-- end, {remap=true})
-- vim.keymap.set('', 'F', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
-- end, {remap=true})
-- vim.keymap.set('', 't', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, {remap=true})
-- vim.keymap.set('', 'T', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, {remap=true})

vim.api.nvim_set_keymap('n', '<leader>s', '<cmd>HopChar2<CR>', { noremap = false, desc = "Jump to 2 character sequence", silent = true })

require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
}

-- KEYBINDS
-- TODO add leader + / to comment line
-- General
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, desc = "Quick save", silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':nohl<CR>', { noremap = true, desc = "Remove highlights", silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, desc = "Remove highlights", silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Window-hopping
vim.api.nvim_set_keymap('n', '<C-h>', '<C-W>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-W>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-W>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-W>l', { noremap = true, silent = true })

-- Buffer interaction
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', { noremap = true, desc = "Next buffer", silent = true })
vim.api.nvim_set_keymap('n', '<leader>bb', ':bprevious<CR>', { noremap = true, desc = "Last buffer", silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', ':bdelete<CR>', { noremap = true, desc = "Close this buffer", silent = true })
vim.api.nvim_set_keymap('n', '<leader>bj', ':BufferLinePick<CR>', { noremap = true, desc = "Close target buffer", silent = true })
vim.api.nvim_set_keymap('n', '<leader>be', ':BufferLinePickClose<CR>', { noremap = true, desc = "Close target buffer", silent = true })

-- LSP THINGS
vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev)
-- COQ
vim.api.nvim_set_keymap('i', '<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap(
  "i",
  "<CR>",
  [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
  { expr = true, silent = true }
)
vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<BS>"]], { expr = true, silent = true })
