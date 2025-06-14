return {
  {
    'kevinhwang91/nvim-ufo',
    event = 'BufReadPost',
    dependencies = {
      'kevinhwang91/promise-async',
      'nvim-treesitter/nvim-treesitter', -- optional but recommended for better folds
    },
    opts = {
      -- give Treesitter & LSP priority, fall back to indent
      provider_selector = function(_, ft)
        local ts_disabled = { '', 'vim', 'help' }
        if vim.tbl_contains(ts_disabled, ft) then
          return { 'indent' }
        end
        return { 'lsp', 'treesitter', 'indent' }
      end,
      open_fold_hl_timeout = 400,
      preview = {
        win_config = { border = 'rounded', winblend = 0 },
      },
    },
    config = function(_, opts)
      require('ufo').setup(opts)

      -- Convenient toggles using <leader>f? prefix to avoid 'z' conflicts with leap.nvim
      local map = vim.keymap.set
      map('n', '<leader>fR', require('ufo').openAllFolds, { desc = '[F]old open all folds (ufo)' })
      map('n', '<leader>fM', require('ufo').closeAllFolds, { desc = '[F]old close all folds (ufo)' })
      map('n', '<leader>fO', require('ufo').openFoldsExceptKinds, { desc = '[F]old open all except imports/comments' })

      -- Peek without opening (uses K by default, here remapped)
      map('n', '<leader>fp', require('ufo').peekFoldedLinesUnderCursor,
         { desc = '[F]old [P]review' })

      -- Open only the fold your cursor is in, close the rest
      map('n', '<leader>fo', function()
        require('ufo').closeAllFolds()
        require('ufo').openFoldsUnderCursor()
      end, { desc = '[F]ocus fold' })
    end,
  },
} 