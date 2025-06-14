return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      local list = harpoon:list()

      -- Telescope integration
      local ok, telescope = pcall(require, 'telescope')
      if ok then
        telescope.load_extension 'harpoon'
      end

      -- Keymaps (no conflicts with existing mappings)
      local map = vim.keymap.set

      -- Add current file to Harpoon list
      map('n', '<leader>ha', function()
        list:append()
      end, { desc = 'Harpoon: [A]dd file' })

      -- Toggle Harpoon quick menu
      map('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(list)
      end, { desc = 'Harpoon: Toggle [H]arpoon menu' })

      -- Navigate to first four marks using <leader>1-4
      for i = 1, 4 do
        map('n', '<leader>' .. i, function()
          list:select(i)
        end, { desc = 'Harpoon: Go to file ' .. i })

        map('n', '<leader>hv' .. i, function()
          list:select(i, { vsplit = true })
        end, { desc = '[H]arpoon: [V]-split file ' .. i })

        map('n', '<leader>hs' .. i, function()
          list:select(i, { split = true })
        end, { desc = '[H]arpoon: h-[S]plit file ' .. i })
      end

      -- Telescope picker for all Harpoon files
      map('n', '<leader>ht', function()
        require('telescope').extensions.harpoon.marks {}
      end, { desc = 'Harpoon: Telescope picker' })
    end,
  },
} 