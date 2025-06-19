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
  cmd = 'Neotree',
  keys = {
    {
      '\\',
      function()
        vim.cmd 'Neotree toggle left reveal_force_cwd'
      end,
      desc = 'Toggle NeoTree',
    },
    {
      '|',
      function()
        vim.cmd 'Neotree focus'
      end,
      desc = 'Focus NeoTree',
    },
    {
      '<leader>b',
      function()
        vim.cmd 'Neotree toggle show buffers right'
      end,
      desc = 'Toggle NeoTree Buffers',
    },
  },
  opts = function(_, opts)
    -- Helper that wraps the built-in command and then sets cwd
    local function set_root_and_cwd(state)
      -- Call the original implementation first to actually change the root
      require('neo-tree.sources.filesystem.commands').set_root(state)
      -- `state.path` now points to the new root – make it the Neovim cwd as well
      vim.fn.chdir(state.path)
    end

    -- Ensure tables exist
    opts.filesystem = opts.filesystem or {}
    opts.filesystem.commands = opts.filesystem.commands or {}
    opts.filesystem.window = opts.filesystem.window or {}
    opts.filesystem.window.mappings = opts.filesystem.window.mappings or {}

    -- Register the new command and map it to the `.` key (same as the default "set_root")
    opts.filesystem.commands.set_root_and_cwd = set_root_and_cwd
    opts.filesystem.window.mappings['.'] = 'set_root_and_cwd'
    opts.filesystem.window.mappings['\\'] = 'close_window'
    opts.filesystem.close_if_last_window = true
    opts.filesystem.hijack_netrw_behavior = 'open_default'
    opts.filesystem.filtered_items = {
      hide_gitignored = false,
    }

    return opts
  end,
  init = function()
    if vim.fn.argc(-1) == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      if stat and stat.type == 'directory' then
        require('neo-tree').setup { filesystem = { hijack_netrw_behavior = 'open_current' } }
      end
    end
  end,
}
