require('lazy').setup({
  -- Your core plugins will be required here
  require 'kickstart.plugins.gitsigns',
  require 'kickstart.plugins.which-key',
  require 'kickstart.plugins.telescope',
  require 'kickstart.plugins.lspconfig',
  require 'kickstart.plugins.conform',
  require 'kickstart.plugins.blink-cmp',
  require 'kickstart.plugins.tokyonight',
  require 'kickstart.plugins.todo-comments',
  require 'kickstart.plugins.mini',
  require 'kickstart.plugins.treesitter',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.debug',

  -- Your custom plugins
  { import = 'custom.plugins' },
  { import = 'custom.colorschemes' },

}, {
  ui = {
    -- UI configuration for lazy.nvim
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
}) 