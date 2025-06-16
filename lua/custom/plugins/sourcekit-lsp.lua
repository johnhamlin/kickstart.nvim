return {
  {
    'neovim/nvim-lspconfig',
    ft = { 'swift', 'swiftinterface', 'objective-c', 'objc', 'c', 'cpp' },
    opts = {
      servers = {
        sourcekit = {
          cmd = { 'xcrun', 'sourcekit-lsp' },
          root_dir = require('lspconfig.util').root_pattern('Package.swift', '.git', '*.xcodeproj'),
          single_file_support = true,
        },
      },
    },
  },
}
