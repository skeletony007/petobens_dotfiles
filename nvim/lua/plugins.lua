local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- Plugin list
local plugins = {
    -- Appearance
    {
        'olimorris/onedarkpro.nvim',
        config = function()
            require('plugin-config.onedark_config')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'WhoIsSethDaniel/lualine-lsp-progress.nvim',
        },
        config = function()
            require('plugin-config.lualine_config')
        end,
    },
    {
        'folke/noice.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
        },
        config = function()
            require('plugin-config.noice_config')
        end,
    },

    -- Editing
    {
        'numToStr/Comment.nvim',
        config = function()
            require('plugin-config.comment_config')
        end,
    },
    {
        'kylechui/nvim-surround',
        config = function()
            require('plugin-config.surround_config')
        end,
    },
    {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('plugin-config.colorizer_config')
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('plugin-config.indentlines_config')
        end,
    },
    {
        'ggandor/leap.nvim',
        dependencies = {
            'ggandor/flit.nvim',
        },
        config = function()
            require('plugin-config.leap_config')
        end,
    },

    -- LSP and completion
    {
        'williamboman/mason.nvim',
        dependencies = 'WhoIsSethDaniel/mason-tool-installer.nvim',
        config = function()
            require('plugin-config.mason_config')
        end,
    },
    { 'williamboman/mason-lspconfig.nvim' },
    {
        'neovim/nvim-lspconfig',
        config = function()
            require('plugin-config.lsp_config')
        end,
    },
    { 'folke/neodev.nvim' },
    {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            require('plugin-config.null_ls_config')
        end,
    },
    {
        'folke/trouble.nvim',
        config = function()
            require('plugin-config.trouble_config')
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'andersevenrud/cmp-tmux',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-path',
            'onsails/lspkind.nvim',
        },
        config = function()
            require('plugin-config.cmp_config')
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            require('plugin-config.treesitter_config')
        end,
    },

    -- Telescope and file/code exploring
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-z.nvim',
            'smartpde/telescope-recent-files',
            'debugloop/telescope-undo.nvim',
        },
        config = function()
            require('plugin-config.telescope_config')
        end,
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('plugin-config.nvimtree_config')
        end,
    },
    {
        'stevearc/aerial.nvim',
        config = function()
            require('plugin-config.aerial_config')
        end,
    },

    -- Snippets
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'benfowler/telescope-luasnip.nvim',
        },
        config = function()
            require('plugin-config.luasnip_config')
        end,
    },

    -- Git
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('plugin-config.gitsigns_config')
        end,
    },
    {
        'tpope/vim-fugitive',
        dependencies = {
            'aymericbeaumet/vim-symlink',
            'shumphrey/fugitive-gitlab.vim',
            'tommcdo/vim-fubitive',
            'tpope/vim-rhubarb',
        },
        config = function()
            require('plugin-config.fugitive_config')
        end,
    },

    -- Latex
    {
        'lervag/vimtex',
        config = function()
            require('plugin-config.vimtex_config')
        end,
    },

    -- Runners and terminal
    {
        'stevearc/overseer.nvim',
        config = function()
            require('plugin-config.overseer_config')
        end,
    },
    {
        'akinsho/toggleterm.nvim',
        config = function()
            require('plugin-config.toggleterm_config')
        end,
    },

    -- Utilities
    { 'gioele/vim-autoswap' },
    { 'jamessan/vim-gnupg' },
    { 'nathom/tmux.nvim' },
    { 'tpope/vim-repeat' },
    {
        'andymass/vim-matchup',
        config = function()
            require('plugin-config.matchup_config')
        end,
    },
    { 'lambdalisue/suda.vim' },
    {
        'nyngwang/NeoZoom.lua',
        config = function()
            require('plugin-config.neozoom_config')
        end,
    },
}

-- Lazy plugin setup
require('lazy').setup(plugins, {
    ui = {
        size = { width = 1, height = 1 },
    },
    git = {
        log = { '--since=2 days ago' },
    },
})

-- Mappings
local u = require('utils')
u.keymap('n', '<Leader>lz', '<Cmd>Lazy<CR>')
u.keymap('n', '<Leader>bu', '<Cmd>Lazy sync<CR>')
u.keymap('n', '<Leader>ul', '<Cmd>Lazy log<CR>')
