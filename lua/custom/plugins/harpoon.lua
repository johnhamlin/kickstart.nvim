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
      harpoon:setup()

      -- Telescope integration (your setup is correct)
      local ok, telescope = pcall(require, 'telescope')
      if ok then
        pcall(telescope.load_extension, 'harpoon')
      end

      local map = vim.keymap.set

      -- Add current file to Harpoon list
      map('n', '<leader>ha', function()
        harpoon:list():add()
        vim.notify('Harpooned file', vim.log.levels.INFO)
      end, { desc = 'Harpoon: [A]dd file' })

      -- Toggle Harpoon quick menu
      map('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon: Toggle [H]arpoon menu' })

      -- **FIXED**: Navigate to the first four marks
      -- The loop now correctly captures the index for each keymap.
      for i = 1, 4 do
        local index = i
        map('n', '<leader>' .. index, function()
          harpoon:list():select(index)
        end, { desc = 'Harpoon: Go to file ' .. index })
      end

      -- NOTE: Your original mappings for vertical and horizontal splits
      -- (`<leader>hv` and `<leader>hs`) used an API from harpoon1.
      -- The modern `harpoon2` workflow encourages using the quick menu
      -- for splits. Open the menu with `<leader>hh` and then use
      -- <C-v> for a vertical split or <C-s> for a horizontal split.

      -- Telescope picker for all Harpoon files (your setup is correct)
      map('n', '<leader>sh', function()
        require('telescope').extensions.harpoon.marks()
      end, { desc = '[S]earch [H]arpoon' })
    end,
  },
}
