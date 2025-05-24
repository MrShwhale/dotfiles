return {
    {
        -- Funny cellular automaton for when I get bored
        'eandrju/cellular-automaton.nvim',
        lazy = true,
    },
    {
        -- Treesitter; syntax highlighting and dependency
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    {
        -- Lets nvim work with kitty windows as well
        'mrjones2014/smart-splits.nvim',
        lazy = false,
        build = './kitty/install-kittens.bash'
    },
    {
        -- Allows for better kitty interaction
        'mikesmithgh/kitty-scrollback.nvim',
        enabled = true,
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
        version = '*', -- latest stable version, may have breaking changes if major version changed
        config = function()
            require('kitty-scrollback').setup()
        end,
    },
    {
        -- Configurable statusline
        'nvim-lualine/lualine.nvim',
        enabled = true,
        lazy = false,
    },
    {
        -- LSP configurer
        'neovim/nvim-lspconfig',
        enabled = true,
        lazy = false,
    },
    {
        -- Autocomplete
        'ms-jpq/coq_nvim',
        enabled = true,
        lazy = false,
    },
    {
        -- Autocomplete snippets
        'ms-jpq/coq.artifacts',
        enabled = true,
        lazy = false,
    },
    {
        -- Better word/phrase surrounding
        'kylechui/nvim-surround',
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
        enabled = true,
        lazy = false,
    },
    {
        -- Markdown Preview
        'iamcco/markdown-preview.nvim',
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        enabled = true,
        lazy = true,
    },
    {
        -- Register usage
        'gennaro-tedesco/nvim-peekup',
        enabled = true,
        lazy = false,
    },
    {
        -- Better marks
        'chentoast/marks.nvim',
        enabled = true,
        lazy = false,
    },
    {
        -- Better Jumps
        'smoka7/hop.nvim',
        version = "*",
        opts = {},
        enabled = true,
        lazy = false,
    },
    {
        -- Smart pairng for parenthesis and such
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
        opts = {
            map_cr = true,
        }
    },
    -- Formatting
    {
        'stevearc/conform.nvim',
        opts = {},
    },
    {
        'mikesmithgh/kitty-scrollback.nvim',
        enabled = true,
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
        event = { 'User KittyScrollbackLaunch' },
        -- version = '*', -- latest stable version, may have breaking changes if major version changed
        -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
        config = function()
            require('kitty-scrollback').setup()
        end,
    }
}
