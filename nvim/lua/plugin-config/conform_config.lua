local u = require('utils')

local conform = require('conform')
local formatters = require('conform.formatters')

-- Global options
vim.o.formatexpr = [[v:lua.require('conform').formatexpr()]]

-- Formatters args
formatters.jq.args = { '--indent', '4' }
require('conform').formatters.stylua =
    { prepend_args = { '--config-path=' .. vim.env.HOME .. '/.config/stylua.toml' } }
require('conform').formatters.isort =
    { prepend_args = { '--settings-file=' .. vim.env.HOME .. '/.isort.cfg' } }
require('conform').formatters.black =
    { prepend_args = { '--config=' .. vim.env.HOME .. '/.config/.black.toml' } }
require('conform').formatters.shfmt = { prepend_args = { '-i', '4', '-ci', '-sr' } }
formatters.taplo.args = { 'format', '--config=' .. vim.env.HOME .. '/taplo.toml', '-' }

-- Custom Formatters
local custom_formatters = {
    sqlfluff = {
        command = 'sqlfluff',
        args = {
            'fix',
            '--disable-progress-bar',
            '-f',
            '-n',
            '-',
        },
        stdin = true,
    },
}

-- Setup
conform.setup({
    format_on_save = {
        timeout_ms = 700,
        quiet = true,
        lsp_fallback = false,
    },
    notify_on_error = false,
    formatters = custom_formatters,
    formatters_by_ft = {
        ['_'] = { 'trim_whitespace' },
        json = { 'jq' },
        lua = { 'stylua' },
        -- markdown = { 'prettierd' },
        python = { 'isort', 'black' },
        sh = { 'shfmt' },
        sql = { 'sqlfluff' },
        toml = { 'taplo' },
        yaml = { 'prettierd' },
    },
})

-- Mappings
u.keymap({ 'n', 'v' }, '<Leader>fc', function()
    conform.format({ async = true, lsp_fallback = false })
end)
