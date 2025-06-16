-- Custom diff tools and utilities
return {
  -- Create a dummy plugin entry to load our custom diff commands
  {
    'nvim-lua/plenary.nvim', -- We already have this dependency
    config = function()
      -- Function to diff two files
      local function diff_files(file1, file2)
        if not file1 or not file2 then
          vim.notify('Usage: DiffFiles <file1> <file2>', vim.log.levels.ERROR)
          return
        end

        -- Expand file paths
        file1 = vim.fn.expand(file1)
        file2 = vim.fn.expand(file2)

        -- Check if files exist
        if vim.fn.filereadable(file1) == 0 then
          vim.notify('File not found: ' .. file1, vim.log.levels.ERROR)
          return
        end
        if vim.fn.filereadable(file2) == 0 then
          vim.notify('File not found: ' .. file2, vim.log.levels.ERROR)
          return
        end

        -- Open in new tab
        vim.cmd('tabnew ' .. file1)
        vim.cmd 'diffthis'
        vim.cmd('vnew ' .. file2)
        vim.cmd 'diffthis'

        -- Set some nice options for diff mode
        vim.opt_local.number = true
        vim.opt_local.relativenumber = false
      end

      -- Function to diff selection with clipboard
      local function diff_selection_with_clipboard()
        -- Save current position
        local saved_reg = vim.fn.getreg '"'
        local saved_regtype = vim.fn.getregtype '"'

        -- Yank visual selection
        vim.cmd 'normal! "xy'
        local selection = vim.fn.getreg 'x'

        -- Restore register
        vim.fn.setreg('"', saved_reg, saved_regtype)

        if selection == '' then
          vim.notify('No selection found', vim.log.levels.WARN)
          return
        end

        -- Get clipboard content
        local clipboard = vim.fn.getreg '+'
        if clipboard == '' then
          vim.notify('Clipboard is empty', vim.log.levels.WARN)
          return
        end

        -- Create new tab with two buffers
        vim.cmd 'tabnew'

        -- Left side: Selection
        vim.cmd 'enew'
        vim.bo.buftype = 'nofile'
        vim.bo.bufhidden = 'wipe'
        vim.bo.swapfile = false
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(selection, '\n'))
        vim.api.nvim_buf_set_name(0, '[Selection]')
        vim.bo.modifiable = false
        vim.cmd 'diffthis'

        -- Right side: Clipboard
        vim.cmd 'vnew'
        vim.bo.buftype = 'nofile'
        vim.bo.bufhidden = 'wipe'
        vim.bo.swapfile = false
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(clipboard, '\n'))
        vim.api.nvim_buf_set_name(0, '[Clipboard]')
        vim.bo.modifiable = false
        vim.cmd 'diffthis'

        -- Focus on differences
        vim.cmd 'normal! gg]c'
      end

      -- Function to diff current file with another
      local function diff_with_file()
        local current_file = vim.fn.expand '%:p'
        if current_file == '' then
          vim.notify('No file currently open', vim.log.levels.ERROR)
          return
        end

        vim.ui.input({
          prompt = 'Diff with file: ',
          completion = 'file',
          default = vim.fn.expand '%:h' .. '/',
        }, function(file)
          if file and file ~= '' then
            diff_files(current_file, file)
          end
        end)
      end

      -- Function to toggle diff mode for current windows
      local function toggle_diff_windows()
        local diff_wins = {}
        local non_diff_wins = {}

        -- Check all windows in current tab
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.api.nvim_win_get_option(win, 'diff') then
            table.insert(diff_wins, win)
          else
            table.insert(non_diff_wins, win)
          end
        end

        if #diff_wins > 0 then
          -- Turn off diff mode
          for _, win in ipairs(diff_wins) do
            vim.api.nvim_win_call(win, function()
              vim.cmd 'diffoff'
            end)
          end
          vim.notify('Diff mode disabled', vim.log.levels.INFO)
        else
          -- Turn on diff mode for all windows
          for _, win in ipairs(non_diff_wins) do
            vim.api.nvim_win_call(win, function()
              vim.cmd 'diffthis'
            end)
          end
          vim.notify('Diff mode enabled for all windows', vim.log.levels.INFO)
        end
      end

      -- Create commands
      vim.api.nvim_create_user_command('DiffFiles', function(opts)
        local args = vim.split(opts.args, '%s+')
        diff_files(args[1], args[2])
      end, {
        nargs = '+',
        complete = 'file',
        desc = 'Diff two files',
      })

      vim.api.nvim_create_user_command('DiffClipboard', diff_selection_with_clipboard, {
        range = true,
        desc = 'Diff selection with clipboard',
      })

      vim.api.nvim_create_user_command('DiffWith', diff_with_file, {
        desc = 'Diff current file with another',
      })

      vim.api.nvim_create_user_command('DiffToggle', toggle_diff_windows, {
        desc = 'Toggle diff mode for current windows',
      })

      -- Keymaps
      vim.keymap.set('n', '<leader>df', ':DiffFiles ', { desc = 'Diff two files' })
      vim.keymap.set('n', '<leader>dw', ':DiffWith<cr>', { desc = 'Diff current with...' })
      vim.keymap.set('v', '<leader>dc', ':DiffClipboard<cr>', { desc = 'Diff selection with clipboard' })
      vim.keymap.set('n', '<leader>dt', ':DiffToggle<cr>', { desc = 'Toggle diff mode' })
      vim.keymap.set('n', '<leader>do', ':diffoff!<cr>', { desc = 'Turn off diff mode' })
      vim.keymap.set('n', '<leader>du', ':diffupdate<cr>', { desc = 'Update diff' })

      -- Navigation in diff mode
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then
          vim.cmd 'normal! ]c'
        else
          -- Fallback to gitsigns or other navigation
          pcall(function()
            require('gitsigns').nav_hunk 'next'
          end)
        end
      end, { desc = 'Next diff/change' })

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then
          vim.cmd 'normal! [c'
        else
          -- Fallback to gitsigns or other navigation
          pcall(function()
            require('gitsigns').nav_hunk 'prev'
          end)
        end
      end, { desc = 'Previous diff/change' })

      -- Helper function to create a nice diff view
      vim.api.nvim_create_user_command('DiffSplit', function(opts)
        local file = opts.args
        if file == '' then
          vim.notify('Usage: DiffSplit <file>', vim.log.levels.ERROR)
          return
        end
        vim.cmd('vert diffsplit ' .. file)
      end, {
        nargs = 1,
        complete = 'file',
        desc = 'Open file in vertical diff split',
      })
    end,
  },
}
