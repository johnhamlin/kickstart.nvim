return {
  'joshuadanpeterson/typewriter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('typewriter').setup {
      enable_horizontal_scroll = false,
    }

    -- HACK: Override the default centre logic so that we *always* use "zz"
    -- even when the cursor is on the very last line of the buffer.  The upstream
    -- version of the plugin switches to "zb" at EOF which results in the cursor
    -- being glued to the bottom of the window when editing wiki files.
    --
    -- We patch this after setup() so that it takes precedence over the original
    -- implementation.  If the plugin updates in the future you can simply
    -- remove this block once the issue is resolved upstream.
    local commands = require 'typewriter.commands'
    commands.center_cursor = function()
      local utils = require 'typewriter.utils'
      if not utils.is_typewriter_active() then
        return
      end

      -- Save the current cursor position so we can restore it after centering.
      local cursor = vim.api.nvim_win_get_cursor(0)

      -- Always centre the cursor vertically in the window.
      vim.cmd 'normal! zz'

      -- Re-set the cursor in case the view change moved us horizontally.
      vim.api.nvim_win_set_cursor(0, cursor)
    end
  end,
  opts = {},
  keys = {
    {
      '<leader>ut',
      '<cmd>TWToggle<cr>',
      desc = '[U]I [T]ypewriter mode',
      silent = true,
    },
  },
}
