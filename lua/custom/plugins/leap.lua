-- leap.nvim - Motion plugin for Neovim
-- https://github.com/ggandor/leap.nvim

return {
  'ggandor/leap.nvim',
  dependencies = {
    'tpope/vim-repeat',
  },
  config = function()
    local leap = require 'leap'

    -- Remove the default s/S keybindings
    -- vim.keymap.del({ 'n', 'x', 'o' }, 's')
    -- vim.keymap.del({ 'n', 'x', 'o' }, 'S')

    -- Add custom z/Z keybindings
    vim.keymap.set({ 'n', 'x', 'o' }, 'z', '<Plug>(leap-forward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'Z', '<Plug>(leap-backward)')

    -- Additional configuration options
    leap.opts = {
      highlight_unlabeled_phase_one_targets = true,
      safe_labels = {},
    }
  end,
}
