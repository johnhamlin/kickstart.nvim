return {
  -- Try persistence.nvim instead (lighter, less aggressive)
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session for Current Directory',
      },
      {
        '<leader>qS',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Select Session to Load',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>qd',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Stop Persistence',
      },
    },
  },
}
