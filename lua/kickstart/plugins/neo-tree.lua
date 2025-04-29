-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      close_if_last_window = true,
      hijack_netrw_behavior = 'open_default',
      filtered_items = {
        hide_gitignored = false,
      },
    },
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree toggle left reveal_force_cwd<cr>', desc = 'NeoTree reveal', silent = true },
    { '|', ':Neotree focus<cr>', desc = 'NeoTree reveal', silent = true },
    { '<leader>b', ':Neotree toggle show buffers right<cr>', desc = 'NeoTree reveal', silent = true },
  },
  init = function()
    if vim.fn.argc(-1) == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == 'directory' then
        require('neo-tree').setup { filesystem = { hijack_netrw_behavior = 'open_current' } }
      end
    end
  end,
}
