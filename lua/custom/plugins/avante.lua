return {
  -- Avante.nvim – full-featured AI assistant (Cursor-like)
  {
    enabled = false,
    'yetone/avante.nvim',
    build = 'make', -- compile the Rust native helpers (quick)
    event = 'VeryLazy', -- load lazily after UI is ready
    version = false, -- always track latest

    -- Explicit runtime dependencies (most are already in your setup, but
    -- listing them avoids lazy-loading pitfalls and makes config self-contained)
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'stevearc/dressing.nvim', -- nicer input UI
      'nvim-tree/nvim-web-devicons', -- UI icons for the sidebar
      -- Copilot Lua backend (required for Avante's `provider = "copilot"`)
      {
        'zbirenbaum/copilot.lua',
        config = function()
          -- keep it minimal – Avante will drive the requests; we only need auth
          require('copilot').setup { suggestion = { enabled = false } }
        end,
      },
    },

    -- Avante configuration
    opts = function()
      return {
        provider = 'copilot', -- use Copilot tokens for LLM calls
        mode = 'agentic', -- Cursor-style autonomous agent

        -- Keep Avante from spraying global maps; we'll define only what we need.
        behaviour = {
          auto_set_keymaps = false,
          auto_suggestions = true, -- inline AI ghost-text (replaces Copilot's)
          auto_apply_diff_after_generation = true, -- apply patches immediately (change if you prefer manual)
          auto_approve_tool_permissions = true, -- don't prompt for each tool call
        },

        -- Tune suggestion engine (reduce traffic)
        suggestion = {
          debounce = 800, -- ms before first request
          throttle = 800, -- minimum ms between requests
        },
      }
    end,

    -- Custom keymaps that do not collide with any of your current <leader> maps
    keys = {
      { '<leader>aa', '<cmd>AvanteToggle<cr>', desc = 'Avante: Toggle sidebar' },
      { '<leader>ac', '<cmd>AvanteAsk<cr>', desc = 'Avante: Ask (chat)', mode = { 'n', 'v' } },
      { '<leader>ar', '<cmd>AvanteRefresh<cr>', desc = 'Avante: Refresh windows' },
      { '<leader>as', '<cmd>AvanteStop<cr>', desc = 'Avante: Stop current AI job' },
      { '<leader>af', '<cmd>AvanteFocus<cr>', desc = 'Avante: Focus / unfocus' },
      { '<leader>ae', '<cmd>AvanteEdit<cr>', desc = 'Avante: Edit selected block', mode = 'v' },
      { '<leader>a?', '<cmd>AvanteModels<cr>', desc = 'Avante: Model list' },

      -- Inline suggestion controls (insert-mode) – mirror your old Copilot maps
      {
        '<C-J>',
        function()
          require('avante').get_suggestion():accept()
        end,
        mode = 'i',
        desc = 'Avante: Accept suggestion',
      },
      {
        '<C-\\>',
        function()
          require('avante').get_suggestion():suggest()
        end,
        mode = 'i',
        desc = 'Avante: Manual suggest',
      },
      {
        '<C-]>',
        function()
          require('avante').get_suggestion():dismiss()
        end,
        mode = 'i',
        desc = 'Avante: Dismiss suggestion',
      },
      {
        '<M-]>',
        function()
          require('avante').get_suggestion():next()
        end,
        mode = 'i',
        desc = 'Avante: Next suggestion',
      },
      {
        '<M-[>',
        function()
          require('avante').get_suggestion():prev()
        end,
        mode = 'i',
        desc = 'Avante: Prev suggestion',
      },
    },
  },
}
