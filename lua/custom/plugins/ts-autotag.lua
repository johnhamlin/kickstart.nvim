return {
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable_close_on_slash = false,
    },
  },
} 