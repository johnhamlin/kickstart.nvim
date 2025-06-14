return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        -- keep built-in search (/ and ?), char mode disabled to retain f/F motions implementation
        search = { enabled = false },
        -- char = { enabled = false },
      },
    },
    keys = {
      -- Primary flash jump (was 'z' in leap)
      {
        'z',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash: jump',
      },
      -- Treesitter enhanced jump (was 'Z' in leap)
      {
        'Z',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash: Treesitter jump',
      },
      -- Remote jump to currently visible flash label
      {
        'gz',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').remote()
        end,
        desc = 'Flash: remote label',
      },
      -- Treesitter search across file (great for jumping to functions/classes)
      {
        'gZ',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Flash: Treesitter search',
      },
    },
  },
}