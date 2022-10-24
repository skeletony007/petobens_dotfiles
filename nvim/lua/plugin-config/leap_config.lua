local leap = require('leap')

leap.setup({
    max_highlighted_traversal_targets = 20,
    special_keys = {
        repeat_search = '<enter>',
        next_target = { '<A-n>' },
        prev_target = { '<A-p>' },
    },
})
require('flit').setup({}) -- enhanced f,F,t and T motions (as in sneak)

-- Mappings (use default but don't map x)
leap.add_default_mappings()
vim.keymap.del({ 'x', 'o' }, 'x')
vim.keymap.del({ 'x', 'o' }, 'X')
