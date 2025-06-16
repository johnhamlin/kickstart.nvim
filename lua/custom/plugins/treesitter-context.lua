return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPost', -- load after reading a buffer
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- See :h treesitter-context for all options
    opts = {
      enable = true,         -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0,         -- How many lines the window should span. Values <= 0 mean no limit.
      trim_scope = 'outer',  -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'topline',      -- Line used to calculate context. Choices: 'cursor', 'topline'
      separator = nil,       -- Separator character in between context and content. nil = no separator.
    },
    keys = {
      {
        '<leader>uc',
        function()
          require('treesitter-context').toggle()
        end,
        desc = '[U]I Treesitter [C]ontext',
      },
    },
  },
} 
