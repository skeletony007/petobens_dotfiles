local overseer = require('overseer')
local u = require('utils')
local utils = require('telescope.utils')

-- Options
vim.opt_local.textwidth = 90
vim.opt_local.foldlevelstart = 99
vim.opt_local.foldmethod = 'manual'

-- Running
local _parse_qf = function(qf_title, active_window_id)
    local current_qf = vim.fn.getqflist()
    local new_qf = {}
    for _, v in pairs(current_qf) do
        if v.valid > 0 or v.text ~= '' then
            if v.lnum > 0 then
                v.type = 'E'
            end
            table.insert(new_qf, v)
        end
    end
    if next(new_qf) ~= nil then
        vim.fn.setqflist({}, ' ', { items = new_qf, title = qf_title })
        vim.cmd('copen')
        vim.fn.win_gotoid(active_window_id)
    end
end

local function run_overseer()
    local current_win_id = vim.fn.win_getid()
    vim.cmd('silent noautocmd update')
    overseer.run_template({ name = 'run_lua' }, function(task)
        vim.cmd('cclose')
        task:subscribe('on_complete', function()
            _parse_qf(task.metadata.run_cmd, current_win_id)
        end)
    end)
end

local run_toggleterm = function()
    vim.cmd('silent noautocmd update')
    vim.cmd(
        string.format(
            'TermExec cmd="%s %s"',
            'nvim -l',
            vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
        )
    )
end

local run_tmux_pane = function()
    if vim.env.TMUX == nil then
        return
    end
    local cwd = utils.buffer_dir()
    local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
    local sh_cmd = '"nvim -l ' .. fname .. [[; read -p ''"]]
    vim.cmd('silent! !tmux new-window -c ' .. cwd .. ' -n ' .. fname .. ' ' .. sh_cmd)
end

vim.api.nvim_create_user_command('RunVisualLua', function()
    vim.cmd('normal ') -- leave visual mode to set <,> marks
    local lines = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
    vim.cmd('lua ' .. table.concat(lines, ' '))
end, { range = true })

-- Mappings
u.keymap({ 'n', 'i' }, '<F7>', run_overseer, { buffer = true })
u.keymap({ 'n', 'i' }, '<F5>', run_tmux_pane, { buffer = true })
u.keymap('n', '<Leader>rf', run_toggleterm, { buffer = true })
u.keymap('n', '<Leader>rl', [[:execute "lua " getline('.')<CR>]], { buffer = true })
u.keymap(
    'n',
    '<Leader>ri',
    '<Cmd>update<CR>:luafile %<CR>',
    { silent = false, buffer = true }
)
u.keymap('v', '<Leader>ri', ':RunVisualLua<CR>', { buffer = true })
