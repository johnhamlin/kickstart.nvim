return {
  'LintaoAmons/scratch.nvim',
  -- We only need scratch buffers once the editor has settled, so defer loading
  event = 'VeryLazy',
  dependencies = {
    -- Use Telescope for picking existing scratch files – already configured elsewhere
    'nvim-telescope/telescope.nvim',
    -- Nice input / select UI (optional but tiny)
    'stevearc/dressing.nvim',
  },
  config = function()
    local scratch_ok, scratch = pcall(require, 'scratch')
    if not scratch_ok then
      return
    end

    scratch.setup {
      -- Keep scratch files under Neovim cache dir so they are ephemeral and outside your projects
      scratch_file_dir = vim.fn.stdpath 'cache' .. '/scratch.nvim',
      -- Open scratch buffers in a vertical split right of the current window
      window_cmd = 'rightbelow vsplit', --[['vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit']]

      -- Use Telescope (already part of your config) for picking scratch files
      use_telescope = true,
      file_picker = 'telescope', -- or "fzflua" if you install it later

      -- Common filetypes you are likely to reach for
      filetypes = { 'lua', 'js', 'ts', 'sh', 'go', 'yaml', 'json', 'markdown', 'txt', 'html', 'css' },
    }

    -- ---------------------------------------------------------------------
    -- Keymaps -------------------------------------------------------------
    -- ---------------------------------------------------------------------
    -- Feel free to change these.  They follow the convention already used
    -- in your config (<leader> prefix + mnemonic).

    local wk_ok, wk = pcall(require, 'which-key')
    if wk_ok then
      require('which-key').add {
        { '<leader>n', group = '[N]otes' },
        { '<leader>nn', '<cmd>Scratch<cr>', desc = 'New Scratch' },
        { '<leader>no', '<cmd>ScratchOpen<cr>', desc = 'Open Scratch' },
      }
    else
      -- Basic mappings if which-key is not available (should not happen)
      vim.keymap.set('n', '<leader>nn', '<cmd>Scratch<cr>', { desc = 'Scratch: New' })
      vim.keymap.set('n', '<leader>no', '<cmd>ScratchOpen<cr>', { desc = 'Scratch: Open' })
    end
  end,
}
