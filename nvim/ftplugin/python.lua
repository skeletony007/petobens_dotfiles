local overseer = require('overseer')
local u = require('utils')
local builtin = require('telescope.builtin')
local utils = require('telescope.utils')

-- Options
vim.opt_local.commentstring = '#%s'
vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Running
local _parse_qf = function(qf_title, active_window_id)
    local current_qf = vim.fn.getqflist()
    local new_qf = {}
    for _, v in pairs(current_qf) do
        if v.valid > 0 or v.text ~= '' then
            table.insert(new_qf, v)
        end
    end
    if next(new_qf) ~= nil then
        vim.fn.setqflist({}, ' ', { items = new_qf, title = qf_title })
        vim.cmd('copen')
        vim.fn.win_gotoid(active_window_id)
    end
end

local run_python = function()
    local current_win_id = vim.fn.win_getid()
    vim.cmd('silent noautocmd update')
    overseer.run_template({ name = 'run_python' }, function(task)
        vim.cmd('cclose')
        task:subscribe('on_complete', function()
            _parse_qf(task.metadata.run_cmd, current_win_id)
        end)
    end)
end

local run_tmux_pane = function(debug_mode)
    debug_mode = debug_mode or false

    if vim.env.TMUX == nil then
        return
    end

    local python_cmd = 'python'
    if debug_mode then
        python_cmd = python_cmd .. ' -m pdb -cc'
    end

    local cwd = utils.buffer_dir()
    local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
    local sh_cmd = '"' .. python_cmd .. ' ' .. fname .. [[; read -p ''"]]
    vim.cmd('silent! !tmux new-window -c ' .. cwd .. ' -n ' .. fname .. ' ' .. sh_cmd)
end

-- Debugging
local add_breakpoint = function()
    local save_cursor = vim.fn.getcurpos()
    local current_line = vim.fn.line('.')
    local breakpoint_line = current_line - 1
    local indent_length = vim.fn.match(vim.fn.getline(current_line), '\\w')
    local bp_statement = string.rep(' ', indent_length) .. 'breakpoint()'
    vim.fn.append(breakpoint_line, bp_statement)
    vim.cmd('silent noautocmd update')
    vim.fn.setpos('.', save_cursor)
end

local remove_breakpoints = function()
    local save_cursor = vim.fn.getcurpos()
    vim.cmd('g/breakpoint()/d')
    vim.cmd('silent noautocmd update')
    vim.fn.setpos('.', save_cursor)
end

local list_breakpoints = function(local_buffer)
    local opts = {
        use_regex = true,
        search = 'breakpoint()',
    }
    if local_buffer == true then
        local buf_name = vim.api.nvim_buf_get_name(0)
        opts = vim.tbl_extend('keep', opts, {
            results_title = buf_name,
            search_dirs = { buf_name },
        })
    else
        local buffer_dir = utils.buffer_dir()
        opts = vim.tbl_extend('keep', opts, {
            cwd = buffer_dir,
            results_title = buffer_dir,
        })
    end
    builtin.grep_string(opts)
end

-- Running
u.keymap({ 'n', 'i' }, '<F7>', run_python, { buffer = true })
u.keymap({ 'n', 'i' }, '<F5>', run_tmux_pane, { buffer = true })
u.keymap({ 'n', 'i' }, '<F6>', function()
    run_tmux_pane(true)
end, { buffer = true })

-- Debugging
u.keymap('n', '<Leader>bp', add_breakpoint, { buffer = true })
u.keymap('n', '<Leader>rb', remove_breakpoints, { buffer = true })
u.keymap('n', '<Leader>lb', function()
    list_breakpoints(true)
end, { buffer = true })
u.keymap('n', '<Leader>lB', function()
    list_breakpoints(false)
end, { buffer = true })
