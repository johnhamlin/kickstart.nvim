return {
  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      open_cmd = 'noswapfile vnew', -- open in vertical split without swapfile
      line_sep_start = '┌──────────────────────────────────────────────────────────────',
      line_sep = '└──────────────────────────────────────────────────────────────',
    },
    keys = {
      {
        '<leader>sR',
        function()
          require('spectre').toggle()
        end,
        desc = '[S]earch & [R]eplace (Spectre)',
      },
      {
        '<leader>sw',
        function()
          require('spectre').open_visual { select_word = true }
        end,
        desc = '[S]pectre current [W]ord',
        mode = { 'n', 'v' },
      },
    },
  },
} 