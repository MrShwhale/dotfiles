-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Keybinds for opening the terminal
lvim.builtin.which_key.mappings["t"] = {
    name = "+Terminal",
    f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
    v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
    h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
}

-- Default vim commands being moved over
vim.opt.cmdheight = 1 -- command height
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 4 spaces for a tab
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = true -- wrap lines
vim.opt.showcmd = true -- show the command being typed

-- use treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

lvim.transparent_window = true

-- Set header

lvim.builtin.alpha.dashboard.section.header.val = {
    "                 ,#############,                  ",
    "                 ##           ##                  ",
    "             m####             ####m              ",
    "          m##*'        mmm        '*##m           ",
    "        ###'         mm###mm         '###         ",
    "      ###        m#############m        ###       ",
    "     ##       m####*'  ###  '*####        ##      ",
    "    ##      m####      ###      ####m      ##     ",
    "   ##      ####      #######      ####      ##    ",
    "  m#      ###'        #####        '###      #m   ",
    "  ##     ####           #           ####     ##   ",
    "  ##     ###    wwwwwwww wwwwwwww    ###     ##   ",
    "  ##     ###m    ######   ######    m###     ##   ",
    ",###     '### m#######     #######m ###'     ###, ",
    "##'      m######'   *       *   '######m      '## ",
    " ##     *#*'######             ######'*#*     ##  ",
    "  ##         '#######m     m#######'         ##   ",
    "   *#m          '###############'          m#*    ",
    "     ##m ,m,        ''*****''        ,m, m##      ",
    "      *##'*###m                   m###*'##*       ",
    "            '*#######m     m#######*'             ",
    "                   '*#######*'                    ",
}



lvim.plugins = {
    {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "S", ":HopChar2<cr>", { silent = true }) end,
    },
    -- Lets code snippets be tried out/run fast
    {
      "metakirby5/codi.vim",
    },
    -- Markdown vim
    {
      "iamcco/markdown-preview.nvim",
      build = "cd app && npm install",
      ft = "markdown",
      config = function()
        vim.g.mkdp_auto_start = 1
      end,
    },
    -- Funny cellular automaton for when I get bored
    {
        'eandrju/cellular-automaton.nvim',
    },
    -- Lets nvim work with kitty windows as well
    {
        'mrjones2014/smart-splits.nvim',
        build = './kitty/install-kittens.bash'
    },
    -- Allows for better kitty interaction
    {
        'mikesmithgh/kitty-scrollback.nvim',
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
        version = '*', -- latest stable version, may have breaking changes if major version changed
        config = function()
            require('kitty-scrollback').setup()
        end,
    },
    -- Register usage
    {
        'gennaro-tedesco/nvim-peekup',
    },
    -- Better marks
    {
        'chentoast/marks.nvim',
    },
    -- Smart pairng for parenthesis and such
    --[[{
        'ZhiyuanLck/smart-pairs',
    },
    --]]
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        -- tag = "*",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                    ["core.esupports.hop"] = {}, -- Follow links with a single keypress
                },
            }
        end,
    },
    {
        "ms-jpq/coq_nvim"
    },
}

--- SCP THEMEING ---
---
--[[
"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣴⣤⣤⣤⣤⣤⡄⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
"⣿⣿⣿⣿⣿⣿⣿⠟⢋⣵⣿⣿⣿⡿⠛⣩⣤⣿⣿⣿⣿⣿⣿⣿⣬⣙⠻⣿⣿⣿⣷⡍⠛⢿⣿⣿⣿⣿⣿⣿",
"⣿⣿⣿⣿⠟⢹⠃⣠⣾⣿⣿⡿⢋⣴⣿⣿⣿⣿⠿⠿⠈⠿⢿⣿⣿⣿⣷⣤⡙⣿⣿⣿⢦⡀⢣⠙⣿⣿⣿⣿",
"⣿⣿⡿⡿⠀⡯⠊⣡⣿⣿⠏⣴⣿⣿⣿⠟⠁⣀⣤⣤⠀⣤⣤⡀⠙⠻⣿⣿⣿⣌⢻⣿⣧⡉⠺⡄⢸⠹⣿⣿",
"⣿⣿⠃⢷⠀⡠⢺⣿⣿⡏⣰⣿⣿⡟⠁⣠⣾⣿⣿⠿⠀⠿⣿⣿⣷⡄⠘⣿⣿⣿⡄⣿⣿⣯⠢⡀⢸⠀⢹⣿",
"⣿⣿⠀⢸⠊⣠⣿⣿⣿⢀⣿⣿⣿⠁⣰⣿⣿⣿⣿⣆⢀⣼⣿⣿⣿⣿⡄⢸⣿⣿⣿⣹⣿⣿⣦⠈⢺⠀⢸⣿",
"⣿⠹⡆⠀⣴⢻⣿⣿⣿⢸⣿⣿⣿⠀⣿⣿⡿⠿⠿⢿⣿⠿⠿⠿⣿⣿⡇⢈⣿⣿⣿⠀⣿⣿⣿⠳⡀⢀⡇⢸",
"⣿⡀⠹⣸⠉⣿⣿⡿⢋⣠⣿⣿⣿⡀⠸⠟⢋⣀⢠⣾⣿⣷⡀⣀⡙⠻⠁⢸⣿⣿⣿⣈⠻⣿⣿⡄⠹⡜⠀⣸",
"⣿⢧⠀⠇⢠⣿⣿⣷⡘⣿⣿⣿⣟⣁⡀⠘⢿⣿⣿⣿⣿⣿⣿⣿⠿⠀⣠⣉⣿⣿⣿⡿⢠⣿⡿⢧⠀⠁⣰⢿",
"⣿⡌⢷⡄⣾⠀⣿⣿⣷⡜⢿⣿⣿⣿⣿⣦⣄⠈⠉⠛⠛⠛⠉⢁⣠⣾⣿⣿⣿⣿⡟⣰⣿⣿⡇⢸⢀⡴⠃⣼",
"⣿⣷⣄⠙⢿⠀⣿⢿⣿⣿⣌⠿⠟⡻⣿⣿⣿⣿⣷⣶⣶⣶⣿⣿⣿⣿⡿⠛⠿⠟⣼⣿⡿⢫⠃⢸⠋⢀⣼⣿",
"⣿⣿⣟⣶⣄⡀⢸⡀⢻⣿⣿⣾⣿⣿⣶⣍⣙⠛⠿⠿⠿⠿⠿⠛⣋⣥⣶⣿⣿⣾⣿⣿⠁⣸⢀⣴⣶⣯⣿⣿",
"⣿⣿⣿⣿⣿⣿⠾⣧⠀⢯⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⡿⢫⠃⢠⢷⣛⣉⣽⣿⣿⣿",
"⣿⣿⣿⣿⣿⣿⣿⣄⣁⡈⢧⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⢋⣀⣠⣴⣾⣿⣿⣿⣿⣿",
"⣿⣿⣿⣿⣿⣿⣿⣯⣉⠉⠉⠉⣀⣀⡭⠟⠛⢛⣛⠛⠛⠛⣛⠛⠛⠩⣥⣀⣈⢁⢀⣀⣴⣿⣿⣿⣿⣿⣿⣿",
"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣝⡛⢉⣁⣀⣤⠖⣫⣴⣿⣿⣷⣬⡙⣦⣤⣀⡈⣉⣩⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿",
"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣼⣿⣿⣿⣿⣿⣿⣿⣧⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
--]]

--[[
    "                                                                     .%@&%%##########%%@@(.                                                                    ",
    "                                                                     ,&&(,............*%@&,                                                                    ",
    "                                                                  .,/%@(,             .*#@#*.                                                                  ",
    "                                                               .,#@@%/,.               ..,(&@&/..                                                              ",
    "                                                            .*%@@(,.          ,//.         .,*#@@#,                                                            ",
    "                                                           ,#@%*,.          .,#@@/.           .*(&@/.                                                          ",
    "                                                         .(@%*.        .,*#%&@@@@@@&%(*..        ,/&&*.                                                        ",
    "                                                       .,&@/.       ,(&@@@@@@@@@@@@@@@@@@%*.       ,#@#.                                                       ",
    "                                                      .#@%*.      *%@@@@&(*,,*%@@(,.,/#@@@@@(.      ./@%/                                                      ",
    "                                                     .(@&*.     ./@@@@#,..   ,#@@/.   .,/%@@@&,      ,(@&*                                                     ",
    "                                                     *@#/.    .*#@@@(,      .*%@@(,      .*%@@@/,     ,(&&.                                                    ",
    "                                                    ,&&*.     *@@@&*.      .(@@@@@@*       ,(@@@&,    .,/@(.                                                   ",
    "                                                    /@(..    ,&@@@/.        .(@@@@/.        ,#@@@#.    .,%&,                                                   ",
    "                                                   .#@/.     /@@@%,          ,#@@(.         ./&@@&,    .,#@*                                                   ",
    "                                                   .%&*.    .(@@@(.           .**.           ,%@@@*    .,/@/                                                   ",
    "                                                   .%&*.    .#@@@(.   ,//((###,  /###((/*.   ,%@@@*    ../@(                                                   ",
    "                                                   .#@*.    ./@@@#,  .*&@@@@@/.  ,#@@@@@%,. .*&@@&,    .,(@/.                                                  ",
    "                                                  .(@@*      ,&@@@/,*(&@@@@@/.    ,#@@@@@&(,*(@@@#.    ..#@#,.                                                 ",
    "                                                .(@@/,       ./@@@@@@@#/*/%,.      ./%**/%@@@@@@&*       .*%@&,                                                ",
    "                                                 /@#,       .*%@@@@@#*.                  ./%@@@@@%*       .*%&,                                                ",
    "                                                 .*@#,      .#&(/#@@@&/..              ,*#@@@&(/(%/      .*&&,                                                 ",
    "                                                  ./@(,        .../&@@@*,.       ..,(&@@@@%,.         .*%&,                                                    ",
    "                                                    *@#,.          .*%@@@@@@&&%%%&&@@@@@@@(,           ,*&%,                                                   ",
    "                                                     ,&%/.            .,*#&@@@@@@@@@@%(,,.           .,#.                                                      ",
    "                                                      ,%@(,..,*,.          .........          ..,,...*%&(.                                                     ",
    "                                                       ,(@#%@@@@%*,                         .,/&@@@%@*.                                                        ",
    "                                                        .*(*,..*/&@&(*,.               ..,*#&@%*,,,*/#,                                                        ",
    "                                                                 ..*(&@@&%(/*******/(#&@@@%/,.                                                                 ",
    "                                                                      ..,*//##%%%%#(/*,...                                                                     ",
    "                                                                             ......                                                                            ",
--]]
