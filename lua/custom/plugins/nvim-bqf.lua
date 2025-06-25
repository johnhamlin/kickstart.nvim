return {
  "kevinhwang91/nvim-bqf",
  ft = "qf", -- load only for quickfix/location-list buffers
  dependencies = {
    -- FZF binary & vim plugin for advanced quickfix filtering
    {
      "junegunn/fzf",
      build = function()
        -- Install the fzf binary if it is not present
        vim.fn["fzf#install"]()
      end,
    },
  },
  opts = {
    auto_enable = true,            -- enable by default when quickfix opens
    magic_window = true,           -- keep qf window position consistent

    -- Treesitter-powered syntax highlighting inside the preview window
    preview = {
      -- use treesitter highlighting after slight delay for performance
      delay_syntax = 50,
      win_height = 15,
      win_vheight = 15,
    },

    -- FZF integration for interactive filtering and extra actions
    filter = {
      fzf = {
        -- Map common fzf keys to quickfix actions
        action_for = {
          ["ctrl-s"] = "split",   -- open in horizontal split
          ["ctrl-v"] = "vsplit",  -- open in vertical split
          ["ctrl-t"] = "tabedit", -- open in new tab
          ["ctrl-q"] = "signtoggle", -- toggle sign for selected items
        },
        -- Additional fzf options (toggle all with <C-o>, custom prompt)
        extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "QF> " },
      },
    },
  },
} 