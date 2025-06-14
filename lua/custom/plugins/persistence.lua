return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = function()
      -- Get current sessionoptions and add 'globals' for marks
      local sessionoptions = vim.opt.sessionoptions:get()

      -- Add 'globals' if it's not already there
      if not vim.tbl_contains(sessionoptions, 'globals') then
        table.insert(sessionoptions, 'globals')
      end

      return { options = sessionoptions }
    end,
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
          require('persistence').stop()
        end,
        desc = 'Stop Persistence',
      },
    },
  },
}
