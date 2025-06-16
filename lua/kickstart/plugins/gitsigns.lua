-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })

        -- normal mode
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>gu', gitsigns.reset_hunk, { desc = 'git [u]ndo stage hunk (reset)' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>gb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>gD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })

        -- Toggles
        map('n', '<leader>ub', gitsigns.toggle_current_line_blame, { desc = 'toggle git show [b]lame line' })
        map('n', '<leader>uD', gitsigns.preview_hunk_inline, { desc = 'toggle git show [D]eleted inline' })

        -- Toggle gitsigns entirely for current buffer
        map('n', '<leader>ug', function()
          gitsigns.toggle_signs()
          gitsigns.toggle_linehl()
          gitsigns.toggle_numhl()
          gitsigns.toggle_word_diff()
          -- Track state for visual feedback
          vim.b.gitsigns_enabled = not vim.b.gitsigns_enabled
          if vim.b.gitsigns_enabled == false then
            vim.notify('Gitsigns disabled for this buffer', vim.log.levels.INFO)
          else
            vim.notify('Gitsigns enabled for this buffer', vim.log.levels.INFO)
          end
        end, { desc = 'toggle [g]itsigns for buffer' })

        -- Alternative: completely detach/attach gitsigns from buffer
        map('n', '<leader>uG', function()
          if vim.b.gitsigns_attached == nil then
            vim.b.gitsigns_attached = true
          end

          if vim.b.gitsigns_attached then
            gitsigns.detach(bufnr)
            vim.b.gitsigns_attached = false
            vim.notify('Gitsigns detached from buffer', vim.log.levels.INFO)
          else
            gitsigns.attach(bufnr)
            vim.b.gitsigns_attached = true
            vim.notify('Gitsigns attached to buffer', vim.log.levels.INFO)
          end
        end, { desc = 'toggle [G]itsigns attach/detach' })
      end,
    },
  },
}
