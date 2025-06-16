-- diffview.nvim - Single tabpage interface for easily cycling through diffs
-- https://github.com/sindrets/diffview.nvim

return {
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewRefresh',
      'DiffviewFileHistory',
    },
    keys = {
      -- Git diff commands (these are what diffview is designed for)
      { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Git Diff Open' },
      { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = 'Git Diff Close' },
      { '<leader>gdh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git Diff History (current file)' },
      { '<leader>gdH', '<cmd>DiffviewFileHistory<cr>', desc = 'Git Diff History (all)' },

      -- Toggle diffview
      {
        '<leader>gdt',
        function()
          local view = require('diffview.lib').get_current_view()
          if view then
            vim.cmd 'DiffviewClose'
          else
            vim.cmd 'DiffviewOpen'
          end
        end,
        desc = 'Git Diff Toggle',
      },

      -- For comparing arbitrary files, we'll use Neovim's built-in diff
      { '<leader>df', ':vert diffsplit ', desc = 'Diff current file with...' },
      { '<leader>dc', ':DiffClipboard<cr>', desc = 'Diff selection with clipboard', mode = 'v' },
    },
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = false,
        use_icons = true,
        view = {
          default = {
            layout = 'diff2_horizontal',
          },
          merge_tool = {
            layout = 'diff3_horizontal',
            disable_diagnostics = true,
          },
        },
      }

      -- Custom command to diff selection with clipboard
      local function diff_selection_with_clipboard()
        -- Get visual selection
        local start_pos = vim.fn.getpos "'<"
        local end_pos = vim.fn.getpos "'>"
        local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

        if #lines == 0 then
          vim.notify('No selection found', vim.log.levels.WARN)
          return
        end

        -- Handle partial line selection
        if #lines == 1 then
          lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
        else
          lines[1] = string.sub(lines[1], start_pos[3])
          lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
        end

        -- Create temp files
        local selection_file = vim.fn.tempname()
        vim.fn.writefile(lines, selection_file)

        local clipboard_content = vim.fn.getreg '+'
        local clipboard_lines = vim.split(clipboard_content, '\n')
        local clipboard_file = vim.fn.tempname()
        vim.fn.writefile(clipboard_lines, clipboard_file)

        -- Open diff in new tab
        vim.cmd 'tabnew'
        vim.cmd('e ' .. selection_file)
        vim.cmd 'diffthis'
        vim.cmd('vnew ' .. clipboard_file)
        vim.cmd 'diffthis'

        -- Set nice buffer names
        vim.cmd 'file Selection'
        vim.cmd 'wincmd h'
        vim.cmd 'file Clipboard'
        vim.cmd 'wincmd l'

        -- Make buffers temporary and unmodified
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_name(buf):match(selection_file) or vim.api.nvim_buf_get_name(buf):match(clipboard_file) then
            vim.bo[buf].buftype = 'nofile'
            vim.bo[buf].modifiable = false
            vim.bo[buf].modified = false
          end
        end

        -- Clean up temp files when closing
        vim.api.nvim_create_autocmd('TabClosed', {
          callback = function()
            vim.fn.delete(selection_file)
            vim.fn.delete(clipboard_file)
          end,
          once = true,
        })
      end

      vim.api.nvim_create_user_command('DiffClipboard', diff_selection_with_clipboard, {
        range = true,
        desc = 'Diff selection with clipboard',
      })
    end,
  },
}
