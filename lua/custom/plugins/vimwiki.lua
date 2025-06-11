return {
  ---------------------------------------------------------------------------
  -- ➊ Vimwiki  (dev branch) – required
  ---------------------------------------------------------------------------
  {
    'vimwiki/vimwiki',
    branch = 'dev',
    event = 'VeryLazy',
    init = function()
      vim.g.vimwiki_list = {
        {
          path = '/Users/john/Documents/vimwiki/',
          syntax = 'default',
        },
      }
    end,
  },
  ---------------------------------------------------------------------------
  -- ➋ Taskwiki
  ---------------------------------------------------------------------------
  {
    'tools-life/taskwiki',
    event = 'VeryLazy',
    ft = { 'vimwiki' },
    dependencies = { 'vimwiki/vimwiki' },
    init = function()
      -- vim.g.mapleader = ' '
      -- vim.g.maplocalleader = ' '
      -- vim.g.taskwiki_maplocalleader = vim.g.maplocalleader

      -- keep Taskwarrior DB somewhere version-controlled (optional)
      vim.g.taskwiki_data_location = vim.fn.expand '~/Documents/task'

      -- REMOVE the Markdown override; default markup matches Vimwiki headings
      -- vim.g.taskwiki_markup_syntax = "markdown"

      -- QoL tweaks
      vim.g.taskwiki_disable_concealcursor = 1 -- keep filters visible in insert mode
      vim.g.taskwiki_dont_fold = 1 -- avoid automatic folding
    end,
  },
  --   -- only load when a Vimwiki buffer is opened
  --   ft = { 'vimwiki' },
  --
  --   init = function()
  --     -- recognise *, - or + list bullets as Taskwiki tasks
  --     vim.g.taskwiki_markers = { '*' }
  --
  --     -- keep Taskwarrior DB somewhere version-controlled (optional)
  --     vim.g.taskwiki_data_location = vim.fn.expand '~/Documents/task'
  --
  --     -- REMOVE the Markdown override; default markup matches Vimwiki headings
  --     -- vim.g.taskwiki_markup_syntax = "markdown"
  --
  --     -- QoL tweaks
  --     vim.g.taskwiki_disable_concealcursor = 1 -- keep filters visible in insert mode
  --     vim.g.taskwiki_dont_fold = 1 -- avoid automatic folding
  --   end,
  --
  --   config = function()
  --     local map = function(lhs, rhs, desc)
  --       vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
  --     end
  --
  --     -- basic actions
  --     map('<leader>tt', '<Plug>TaskWikiToggle', 'Taskwiki toggle complete')
  --     map('<leader>ta', '<Plug>TaskWikiAdd', 'Taskwiki add below')
  --     map('<leader>te', '<Plug>TaskWikiEdit', 'Taskwiki edit in prompt')
  --     map('<leader>ts', '<Plug>TaskWikiStart', 'Taskwiki start / stop')
  --     map('<leader>tr', '<Plug>TaskWikiMod rc', 'Taskwiki set recurrence')
  --   end,
  -- },
  --
  -- -- ---------------------------------------------------------------------------
  -- -- -- ➌ (optional) ANSI colours in Taskwarrior charts
  -- -- ---------------------------------------------------------------------------
  { 'powerman/vim-plugin-AnsiEsc', cmd = 'AnsiEsc', ft = { 'vimwiki' } },

  -- -- ---------------------------------------------------------------------------
  -- -- -- ➍ (optional) Telescope-powered Taskwarrior search
  -- -- ---------------------------------------------------------------------------
  {
    'nvim-telescope/telescope.nvim',
    optional = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        '<leader>st',
        function()
          require('telescope.builtin').command_history { default_text = 'task ' }
        end,
        desc = 'Search Taskwarrior reports',
      },
    },
  },
}
