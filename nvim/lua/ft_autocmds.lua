local u = require('utils')

--- i3
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = vim.api.nvim_create_augroup('ft_i3', { clear = true }),
    pattern = { '*i3/config' },
    command = 'setlocal ft=i3config foldmethod=marker',
})

--- Bash
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = vim.api.nvim_create_augroup('ft_bash', { clear = true }),
    pattern = { 'bash_profile', 'bashrc', 'fzf_bash.sh' },
    command = 'setlocal foldmethod=marker filetype=sh',
})

--- Bibtex
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ft_bib', { clear = true }),
    pattern = { 'bib' },
    command = 'setlocal foldmethod=marker commentstring=%%%%s spell shiftwidth=2 '
        .. 'tabstop=2 softtabstop=2 indentkeys=',
})

--- Configs
local configs_acg = vim.api.nvim_create_augroup('ft_configs', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = configs_acg,
    pattern = {
        'dunstrc',
        '*.dirs',
        'zathurarc',
        '*mpv/*.conf',
        '*onedrive/config',
        '*fdignore',
        '*pylintrc',
        '*flake8',
        '*ripgreprc',
        'matplotlibrc',
    },
    command = 'setlocal filetype=config foldmethod=marker',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = configs_acg,
    pattern = { 'vimiv.conf' },
    command = 'setlocal filetype=dosini',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = configs_acg,
    pattern = { '*.rasi' },
    command = 'setlocal filetype=css',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = configs_acg,
    pattern = { '*/.ssh/config', '*/ssh/config' },
    command = 'setlocal filetype=sshconfig',
})

--- Crontab
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ft_crontab', { clear = true }),
    pattern = { 'crontab' },
    command = 'setlocal nobackup nowritebackup',
})

--- Git
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ft_git', { clear = true }),
    pattern = { 'git' },
    command = 'nnoremap <buffer><silent> q <Cmd>bdelete<CR>',
})

--- HTML & CSS
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ft_html', { clear = true }),
    pattern = { 'html' },
    command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2',
})

--- JSON
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ft_json', { clear = true }),
    pattern = { 'json' },
    command = 'setlocal foldmethod=syntax',
})

--- Python
local python_acg = vim.api.nvim_create_augroup('ft_python', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = python_acg,
    pattern = { 'pdbrc' },
    command = 'setlocal filetype=python',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = python_acg,
    pattern = { '*.ipynb' },
    command = 'setlocal filetype=json',
})

--- QuickFix
local qf_acg = vim.api.nvim_create_augroup('ft_qf', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = qf_acg,
    pattern = { 'qf' },
    callback = function()
        -- Options, position and dynamic height
        vim.cmd('setlocal colorcolumn= textwidth=0 nospell nobuflisted')
        vim.cmd('wincmd J')
        vim.cmd(math.max(1, math.min(vim.fn.line('$'), 15)) .. 'wincmd _')

        -- Maps
        local map_opts = { buffer = true }
        u.keymap('n', 'q', '<Cmd>bdelete<CR>', map_opts)
        u.keymap('n', 'Q', '<Cmd>bdelete<CR>', map_opts)
        u.keymap('n', '<C-s>', '<C-w><Enter>', map_opts)
        u.keymap('n', '<C-v>', '<C-w><Enter><C-w>L', map_opts)
        u.keymap(
            'n',
            '<C-q>',
            '<Cmd>cclose<bar>wincmd p<bar>Telescope quickfix<CR>',
            map_opts
        )
        u.keymap(
            'n',
            '<C-l>',
            '<Cmd>lclose<bar>wincmd p<bar>Telescope loclist<CR>',
            map_opts
        )
    end,
})
vim.api.nvim_create_autocmd({ 'QuitPre', 'BufDelete' }, {
    group = qf_acg,
    -- Automatically close corresponding loclist when quitting a window
    command = 'if &filetype != "qf" | silent! lclose | endif',
})

--- R
local r_acg = vim.api.nvim_create_augroup('ft_R', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = r_acg,
    pattern = { 'Rprofile', '.Rprofile', '*.R', 'radian_profile', '.radian_profile' },
    command = 'setlocal ft=r',
})
vim.api.nvim_create_autocmd('FileType', {
    group = r_acg,
    pattern = { 'r' },
    command = 'setlocal foldmethod=syntax',
})

--- Text
local txt_acg = vim.api.nvim_create_augroup('ft_txt', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = txt_acg,
    pattern = { 'text' },
    command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2 spell',
})

--- TOML
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    group = vim.api.nvim_create_augroup('ft_toml', { clear = true }),
    pattern = { 'poetry.lock' },
    command = 'set filetype=toml',
})

--- Vim (also help and man)
local vim_acg = vim.api.nvim_create_augroup('ft_vim', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = vim_acg,
    pattern = { 'vim' },
    command = 'setlocal foldmethod=marker formatoptions-=ro',
})
vim.api.nvim_create_autocmd('FileType', {
    group = vim_acg,
    pattern = { 'help' },
    command = 'setlocal textwidth=78 relativenumber',
})
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim_acg,
    pattern = { '*.txt' },
    command = 'if &ft == "help" | wincmd J | endif',
})
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim_acg,
    pattern = { '*.txt' },
    command = 'if &ft == "help" | 20 wincmd _ | endif',
})
vim.api.nvim_create_autocmd('FileType', {
    group = vim_acg,
    pattern = { 'help' },
    command = 'nnoremap <buffer><silent> q <Cmd>bdelete<CR>',
})
vim.api.nvim_create_autocmd('FileType', {
    group = vim_acg,
    pattern = { 'help', 'man' },
    command = 'nmap <buffer><silent><Leader>tc gO',
})
vim.api.nvim_create_autocmd('FileType', {
    group = vim_acg,
    pattern = { 'help', 'man' },
    command = 'nmap <buffer><silent><Leader>tC :execute "normal gO" <bar> bd<CR>',
})
vim.api.nvim_create_autocmd('FileType', {
    group = vim_acg,
    pattern = { 'man' },
    command = 'setlocal iskeyword+=-',
})

--- YAML
vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = vim.api.nvim_create_augroup('ft_yaml', { clear = true }),
    pattern = { 'yaml' },
    command = 'setlocal textwidth=90',
})
