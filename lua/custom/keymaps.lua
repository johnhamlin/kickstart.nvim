-- Buffer navigation with Tab and Shift-Tab
-- vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Go to next buffer', silent = true })
-- vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Go to previous buffer', silent = true })

vim.keymap.set('n', '<Enter>', 'o<Esc>', { desc = 'Add blank line below', silent = true })
vim.keymap.set('n', '<S-Enter>', 'O<Esc>', { desc = 'Add blank line below', silent = true })

vim.keymap.set('i', '<C-;>', '<Esc>A;<CR>', { desc = 'Complete statement with ; and new line' })
vim.keymap.set('n', '<C-;>', 'A;<CR>', { desc = 'Complete statement with ; and new line' })

vim.keymap.set('i', '<C-,>', '<Esc>A,<CR>', { desc = 'Complete statement with , and new line' })
vim.keymap.set('n', '<C-,>', 'A,<CR>', { desc = 'Complete statement with , and new line' })

vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('n', 'J', '}')
vim.keymap.set('n', 'K', '{')

-- Center cursor line in normal and visual modes
local map = vim.keymap.set
map({ 'n', 'x' }, '<leader>l', function()
  vim.cmd 'normal! zz'
end, { silent = true, desc = 'Centre cursor line' })

-- Insert-mode helper (optional)
map('i', '<C-l>', '<C-o>zz', { silent = true, desc = 'Centre cursor line' })

vim.keymap.set('n', '<leader>rf', ':TSToolsRenameFile<CR>', { desc = 'TS [R]ename [f]ile + fix imports' })
vim.keymap.set('n', '<leader>rr', ':TSToolsFileReferences<CR>', { desc = 'TS [R]eferences' })
-- vim.keymap.set('n', '<leader>fc', '<Cmd>normal! zc<CR>', { desc = '[F]old [C]lose fold under cursor' })
-- vim.keymap.set('n', '<leader>ft', '<Cmd>normal! za<CR>', { desc = '[F]old [T]oggle fold under cursor' })
-- vim.keymap.set('n', '<leader>fO', '<Cmd>normal! zO<CR>', { desc = '[F]old [O]pen all folds under cursor recursively' })
-- vim.keymap.set('n', '<leader>fC', '<Cmd>normal! zC<CR>', { desc = '[F]old [C]lose all folds under cursor recursively' })
-- vim.keymap.set('n', '<leader>fR', '<Cmd>normal! zR<CR>', { desc = '[F]old open all folds in buffer' })
-- vim.keymap.set('n', '<leader>fM', '<Cmd>normal! zM<CR>', { desc = '[F]old close all folds in buffer' })
-- vim.keymap.set('n', '<leader>fr', '<Cmd>normal! zr<CR>', { desc = '[F]old reduce fold level by 1' })
-- vim.keymap.set('n', '<leader>fm', '<Cmd>normal! zm<CR>', { desc = '[F]fold increase fold level by 1' })

-- vim.keymap.set('n', '<C-S-Space>', 'vimwiki_<C-Space>')
-- Add any other custom keymaps here

-- Return the module (optional)
return {}
