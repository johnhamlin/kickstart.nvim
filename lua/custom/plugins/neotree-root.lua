return {
  -- Extend neo-tree to set Neovim's cwd whenever we change the root with the `set_root` command
  -- or when using the `<bs>` / navigate_up mapping.
  -- We achieve this by defining a custom command that wraps the built-in `set_root` command and
  -- then updating the current working directory to the newly selected root.
  -- The command is only added for the filesystem source.
  {
    'nvim-neo-tree/neo-tree.nvim',
    -- We just add extra config, so keep everything else that comes from the original spec intact.
    dependencies = {},
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
    end,
  },
} 