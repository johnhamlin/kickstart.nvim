-- Buffer navigation with Tab and Shift-Tab
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Go to next buffer', silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Go to previous buffer', silent = true })

vim.keymap.set('n', '<Enter>', 'o<Esc>', { desc = 'Add blank line below', silent = true })
vim.keymap.set('n', '<S-Enter>', 'O<Esc>', { desc = 'Add blank line below', silent = true })

-- Add any other custom keymaps here

-- Return the module (optional)
return {}
