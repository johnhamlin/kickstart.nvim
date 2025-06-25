return {
  "kevinhwang91/nvim-bqf",
  ft = "qf", -- load only for quickfix/location-list buffers
  opts = {
    auto_enable = true,            -- enable by default when quickfix opens
    magic_window = true,           -- keep qf window position consistent
    -- you can add more configuration here later; defaults are good enough
  },
} 