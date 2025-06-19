return {
  {
    'luukvbaal/statuscol.nvim',
    lazy = false,
    -- statuscol requires Neovim 0.10+ (nightly). Guard in case user is on stable
    cond = vim.fn.has 'nvim-0.10' == 1,
    config = function()
      local builtin = require 'statuscol.builtin'

      -- Use the foldfunc provided by statuscol which respects ‚foldopen' and ‚foldclose' icons
      -- This integrates nicely with nvim-ufo and does NOT print depth digits.
      require('statuscol').setup {
        relculright = true, -- relative numbers on the right of line-nr segment
        segments = {
          -- Fold column (single cell wide, clickable)
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
          -- Sign column – always keep diagnostic/git signs visible
          { text = { '%s' },       click = 'v:lua.ScSa' },
          -- Line numbers; keep a space at the end so the cursor line highlight works nicely
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
        },
      }

      -- Make sure our icons are picked up by the fold column
      vim.opt.fillchars = vim.opt.fillchars + {
        foldopen = '', -- nf-md-chevron-down
        foldclose = '', -- nf-md-chevron-right
        fold = ' ',
        foldsep = ' ',
      }
    end,
  },
} 