local luasnip = require('luasnip')
local u = require('utils')

luasnip.setup({
    history = true, -- allow to jump back into exited (last) snippet
    enable_autosnippets = true,
    update_events = 'TextChanged,TextChangedI',
    store_selection_keys = '<C-s>',
})

require('luasnip.loaders.from_lua').lazy_load({
    paths = { vim.fn.stdpath('config') .. '/snippets/' },
})

-- Mappings
u.keymap({ 'i', 's' }, '<C-s>', function()
    if luasnip.expandable() then
        luasnip.expand({})
    end
end)
u.keymap({ 'i', 's' }, '<C-j>', function()
    if luasnip.jumpable(1) then
        luasnip.jump(1)
    end
end)
u.keymap({ 'i', 's' }, '<C-k>', function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end)
u.keymap({ 'i', 's' }, '<C-x>', function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end)
u.keymap('n', '<Leader>es', function()
    require('luasnip.loaders').edit_snippet_files({
        edit = function(file)
            local split = 'split '
            if vim.fn.winwidth(0) > 2 * (vim.go.textwidth or 80) then
                split = 'vsplit '
            end
            vim.cmd(split .. file)
        end,
    })
end)
