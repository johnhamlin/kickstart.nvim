-- Better diff mode experience for comparing files
return {
  -- Improved diff mode
  {
    'AndrewRadev/linediff.vim',
    cmd = { 'Linediff', 'LinediffReset' },
    keys = {
      { '<leader>dl', ':Linediff<cr>', desc = 'Mark selection for diff', mode = 'v' },
      { '<leader>dr', ':LinediffReset<cr>', desc = 'Reset line diff' },
    },
  },

  -- Additional diff utilities
  {
    'will133/vim-dirdiff',
    cmd = 'DirDiff',
    keys = {
      { '<leader>dd', ':DirDiff ', desc = 'Compare directories' },
    },
  },
}
