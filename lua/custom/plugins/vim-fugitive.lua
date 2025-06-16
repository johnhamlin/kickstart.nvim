-- vim-fugitive
-- https://github.com/tpope/vim-fugitive
-- Git commands in nvim

return {
  'tpope/vim-fugitive',
  cmd = { 'G', 'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull' },
  keys = {
    { '<leader>gs', ':Git<CR>', desc = '[G]it Status' },
    { '<leader>gb', ':Git blame<CR>', desc = 'Git blame' },
  },
}
