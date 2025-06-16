return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED: Initialize harpoon
      harpoon:setup {
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
        -- Configure the UI menu
        default = {
          select_with_nil = false,
        },
      }

      -- Telescope integration
      local ok, telescope = pcall(require, 'telescope')
      if ok then
        pcall(telescope.load_extension, 'harpoon')
      end

      local map = vim.keymap.set

      -- Add current file to Harpoon list
      map('n', '<leader>ha', function()
        harpoon:list():add()
        vim.notify('Added to Harpoon', vim.log.levels.INFO)
      end, { desc = 'Harpoon: [A]dd file' })

      -- Toggle Harpoon quick menu
      map('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon: Toggle [H]arpoon menu' })

      -- Navigate to the first four marks using leader + number
      for i = 1, 4 do
        map('n', '<leader>' .. i, function()
          harpoon:list():select(i)
        end, { desc = 'Harpoon: Go to file ' .. i })
      end

      -- Previous/Next navigation
      map('n', '<leader>hp', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon: Go to [P]revious' })

      map('n', '<leader>hn', function()
        harpoon:list():next()
      end, { desc = 'Harpoon: Go to [N]ext' })

      -- Telescope picker for all Harpoon files
      map('n', '<leader>sh', function()
        local ok_telescope = pcall(require, 'telescope')
        if ok_telescope then
          require('telescope').extensions.harpoon.marks()
        else
          -- Fallback to regular UI if telescope not available
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end
      end, { desc = '[S]earch [H]arpoon' })

      -- Custom Telescope integration with better UI
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr, map_telescope)
              local actions = require 'telescope.actions'
              local action_state = require 'telescope.actions.state'

              -- Custom action for vertical split
              local open_vsplit = function()
                local selected_entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd('vsplit ' .. selected_entry[1])
              end

              -- Custom action for horizontal split
              local open_split = function()
                local selected_entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd('split ' .. selected_entry[1])
              end

              -- Custom action for new tab
              local open_tab = function()
                local selected_entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd('tabedit ' .. selected_entry[1])
              end

              -- Map keys
              map_telescope('n', '<C-v>', open_vsplit)
              map_telescope('i', '<C-v>', open_vsplit)
              map_telescope('n', '<C-x>', open_split)
              map_telescope('i', '<C-x>', open_split)
              map_telescope('n', '<C-t>', open_tab)
              map_telescope('i', '<C-t>', open_tab)

              return true
            end,
          })
          :find()
      end

      -- Alternative telescope toggle with custom keymaps
      map('n', '<leader>ht', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Harpoon: [T]elescope view' })

      -- For the basic Harpoon UI, we need to set up autocmds to handle the keymaps
      -- This is a workaround since Harpoon 2's UI doesn't have built-in split keymaps
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'harpoon',
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }

          -- Add keymaps for the Harpoon buffer
          vim.keymap.set('n', '<C-v>', function()
            local line = vim.api.nvim_get_current_line()
            local file = vim.trim(line)
            if file ~= '' then
              vim.cmd 'wincmd p' -- Go to previous window
              vim.cmd('vsplit ' .. file)
            end
          end, opts)

          vim.keymap.set('n', '<C-x>', function()
            local line = vim.api.nvim_get_current_line()
            local file = vim.trim(line)
            if file ~= '' then
              vim.cmd 'wincmd p' -- Go to previous window
              vim.cmd('split ' .. file)
            end
          end, opts)

          vim.keymap.set('n', '<C-t>', function()
            local line = vim.api.nvim_get_current_line()
            local file = vim.trim(line)
            if file ~= '' then
              vim.cmd('tabedit ' .. file)
            end
          end, opts)
        end,
      })
    end,
    keys = {
      { '<leader>ha', desc = 'Harpoon: Add file' },
      { '<leader>hh', desc = 'Harpoon: Toggle menu' },
      { '<leader>hp', desc = 'Harpoon: Previous' },
      { '<leader>hn', desc = 'Harpoon: Next' },
      { '<leader>ht', desc = 'Harpoon: Telescope view' },
      { '<leader>sh', desc = 'Search Harpoon' },
      { '<leader>1', desc = 'Harpoon: File 1' },
      { '<leader>2', desc = 'Harpoon: File 2' },
      { '<leader>3', desc = 'Harpoon: File 3' },
      { '<leader>4', desc = 'Harpoon: File 4' },
    },
  },
}
