return {
  require('lspconfig').sourcekit.setup {
    cmd = { 'xcrun', 'sourcekit-lsp' },
    filetypes = { 'swift', 'swiftinterface', 'objective-c', 'objc', 'c', 'cpp' },
    root_dir = require('lspconfig.util').root_pattern('Package.swift', '.git', '*.xcodeproj'),
    single_file_support = true, -- attach in .swiftinterface buffers }
  },
}
