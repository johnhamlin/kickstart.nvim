-- leap.nvim - Motion plugin for Neovim
-- https://github.com/ggandor/leap.nvim
--

-- Leap config has been superseded by flash.nvim. Keeping for reference.
--[[
return {
  'ggandor/leap.nvim',
  dependencies = {
    'tpope/vim-repeat',
  },
  config = function()
    local leap = require 'leap'

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
]]

return {}
