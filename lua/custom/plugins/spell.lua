return {
  -- Enhanced spellchecking
  'lewis6991/spellsitter.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Use treesitter to spellcheck only comments and strings
    require('spellsitter').setup()

    -- Default spell language
    vim.opt.spelllang = { 'en_us' }

    -- Helper for concise mappings
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true, noremap = true })
    end

    ---------------------------------------------------------------------------
    -- Core toggles & navigation (no z/Z keys!)
    ---------------------------------------------------------------------------
    -- Toggle spelling (fits existing <leader>u* UI-toggle pattern)
    map({ 'n', 'v' }, '<leader>us', function()
      vim.opt.spell = not vim.opt.spell:get()
    end, '[U]I [S]spellcheck')

    -- Jump to next/previous misspelling (keeps builtin motions but gives mnemonic alternatives)
    -- map('n', '<leader>sn', ']s', 'Next misspelling')
    -- map('n', '<leader>sp', '[s', 'Previous misspelling')

    ---------------------------------------------------------------------------
    -- Suggestions & dictionary management
    ---------------------------------------------------------------------------
    -- Telescope powered suggestion picker for the word under cursor
    map('n', '<leader>ss', function()
      require('telescope.builtin').spell_suggest()
    end, '[S}earch [S]pell suggestions')

    -- Add current word to the good spell list ("g" for good)
    map('n', '<leader>sa', function()
      local word = vim.fn.expand '<cword>'
      vim.cmd('silent spellgood ' .. word)
      vim.notify('Added "' .. word .. '" to dictionary')
    end, '[S]pellcheck [A]dd')

    -- Mark current word as bad ("b" for bad)
    map('n', '<leader>sb', function()
      local word = vim.fn.expand '<cword>'
      vim.cmd('silent spellbad ' .. word)
      vim.notify('Marked "' .. word .. '" as bad')
    end, '[S]pellcheck [B]ad')
  end,
}
