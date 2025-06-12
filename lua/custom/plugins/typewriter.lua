return {
  'joshuadanpeterson/typewriter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('typewriter').setup {
      enable_horizontal_scroll = false,
    }
  end,
  opts = {},
  keys = {
    {
      '<leader>tT',
      '<cmd>TWToggle<cr>',
      desc = '[T]oggle [T]ypewriter mode',
      silent = true,
    },
  },
}
