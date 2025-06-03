-- lua/custom/plugins/utilities.lua
return {
  -- Session management (simpler than auto-session)
  -- {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre",
  --   opts = { options = vim.opt.sessionoptions:get() },
  --   keys = {
  --     { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
  --     { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
  --     { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  --   },
  -- },

  -- Better buffer deletion
  {
    'echasnovski/mini.bufremove',
    keys = {
      {
        '<leader>bd',
        function()
          local bd = require('mini.bufremove').delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>bD',
        function()
          require('mini.bufremove').delete(0, true)
        end,
        desc = 'Delete Buffer (Force)',
      },
    },
  },

  -- Color highlighter
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      filetypes = { '*', '!lazy' },
      buftype = { '*', '!prompt', '!nofile' },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = false,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = 'background',
        tailwind = true,
        sass = { enable = true, parsers = { css = true } },
        virtualtext = '■',
      },
    },
  },

  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown Preview' },
    },
    config = function()
      vim.cmd [[do FileType]]
    end,
  },

  -- Better yank history
  {
    'gbprod/yanky.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    opts = {
      ring = {
        history_length = 100,
        storage = 'sqlite',
        sync_with_numbered_registers = true,
        cancel_event = 'update',
      },
      picker = {
        select = {
          action = nil,
        },
        telescope = {
          use_default_mappings = true,
          mappings = nil,
        },
      },
      system_clipboard = {
        sync_with_ring = true,
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 200,
      },
      preserve_cursor_position = {
        enabled = true,
      },
    },
    keys = {
      {
        '<leader>p',
        function()
          require('telescope').extensions.yank_history.yank_history {}
        end,
        desc = 'Paste from Yanky history',
      },
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' } },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' } },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' } },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' } },
      { '<c-n>', '<Plug>(YankyCycleForward)' },
      { '<c-p>', '<Plug>(YankyCycleBackward)' },
      { ']p', '<Plug>(YankyPutIndentAfterLinewise)' },
      { '[p', '<Plug>(YankyPutIndentBeforeLinewise)' },
      { ']P', '<Plug>(YankyPutIndentAfterLinewise)' },
      { '[P', '<Plug>(YankyPutIndentBeforeLinewise)' },
      { '>p', '<Plug>(YankyPutIndentAfterShiftRight)' },
      { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)' },
      { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)' },
      { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)' },
      { '=p', '<Plug>(YankyPutAfterFilter)' },
      { '=P', '<Plug>(YankyPutBeforeFilter)' },
    },
  },

  -- Project management
  {
    'ahmedkhalf/project.nvim',
    opts = {
      manual_mode = false,
      detection_methods = { 'pattern', 'lsp' },
      patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'go.mod' },
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = 'global',
    },
    event = 'VeryLazy',
    config = function(_, opts)
      require('project_nvim').setup(opts)
      require('telescope').load_extension 'projects'
    end,
    keys = {
      { '<leader>fp', '<cmd>Telescope projects<cr>', desc = 'Find Project' },
    },
  },

  -- Zen mode
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 0.95,
        width = 180,
        height = 1,
        options = {
          signcolumn = 'no',
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = '0',
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
      },
    },
    keys = {
      { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
    },
  },

  -- Twilight (dim inactive portions)
  {
    'folke/twilight.nvim',
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
  },
}
