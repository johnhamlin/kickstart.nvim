-- lua/custom/plugins/ui-enhancements.lua
return {
  -- Better notifications
  -- {
  --   'rcarriga/nvim-notify',
  --   event = 'VeryLazy',
  --   opts = {
  --     timeout = 3000,
  --     max_height = function()
  --       return math.floor(vim.o.lines * 0.75)
  --     end,
  --     max_width = function()
  --       return math.floor(vim.o.columns * 0.75)
  --     end,
  --     on_open = function(win)
  --       vim.api.nvim_win_set_config(win, { zindex = 100 })
  --     end,
  --   },
  --   init = function()
  --     -- Use nvim-notify as default notify function
  --     vim.notify = require 'notify'
  --   end,
  -- },

  -- Dashboard
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      -- Set header
      dashboard.section.header.val = {
        '                                                     ',
        '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
        '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
        '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
        '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
        '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
        '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
        '                                                     ',
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
        dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('r', '  Recent files', ':Telescope oldfiles <CR>'),
        dashboard.button('g', '  Find text', ':Telescope live_grep <CR>'),
        dashboard.button('c', '  Config', ':e $MYVIMRC <CR>'),
        dashboard.button('s', '  Restore Session', ':SessionRestore<CR>'),
        dashboard.button('l', '󰒲  Lazy', ':Lazy<CR>'),
        dashboard.button('q', '  Quit', ':qa<CR>'),
      }

      -- Set footer
      local fortune = require 'alpha.fortune'
      dashboard.section.footer.val = fortune()

      -- Send config to alpha
      alpha.setup(dashboard.opts)

      -- Disable folding on alpha buffer
      vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
    end,
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
      { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
      -- { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      -- { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
      { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
    },
    opts = {
      options = {
        close_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
        right_mouse_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- Better UI
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
      presets = {
        -- bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  -- Better vim.ui (using snacks.nvim instead of archived dressing.nvim)
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- Enable the UI features we want
      input = { enabled = true },
      select = { enabled = true },
      -- notifier = { enabled = true }, -- We're using nvim-notify instead
      -- You can explore other features like:
      statuscolumn = { enabled = true },
      indent = { enabled = true },
      lazygit = { configure = true },
      -- dashboard = { enabled = false }, -- We use alpha instead
      -- scroll = { enabled = false },
      -- words = { enabled = true }, -- Highlight word under cursor
    },
    -- put this in the same spec, or anywhere after snacks has loaded
    keys = {
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit (cwd)',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Git log (repo)',
      },
      {
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Git log (file)',
      },
    },
  },

  -- Better vim.ui
  -- {
  --   'stevearc/dressing.nvim',
  --   lazy = true,
  --   init = function()
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     vim.ui.select = function(...)
  --       require('lazy').load { plugins = { 'dressing.nvim' } }
  --       return vim.ui.select(...)
  --     end
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     vim.ui.input = function(...)
  --       require('lazy').load { plugins = { 'dressing.nvim' } }
  --       return vim.ui.input(...)
  --     end
  --   end,
  -- },

  -- Indent guides for Neovim
  -- {
  --   'lukas-reineke/indent-blankline.nvim',
  --   opts = {
  --     indent = {
  --       char = '│',
  --       tab_char = '│',
  --     },
  --     scope = { show_start = false, show_end = false },
  --     exclude = {
  --       filetypes = {
  --         'help',
  --         'alpha',
  --         'dashboard',
  --         'neo-tree',
  --         'Trouble',
  --         'trouble',
  --         'lazy',
  --         'mason',
  --         'notify',
  --         'toggleterm',
  --         'lazyterm',
  --       },
  --     },
  --   },
  --   main = 'ibl',
  -- },

  -- Active indent guide and indent text objects
  -- {
  --   'echasnovski/mini.indentscope',
  --   -- enabled = false,
  --   version = false,
  --   event = 'VeryLazy',
  --   opts = {
  --     symbol = '│',
  --     options = { try_as_border = true },
  --     draw = {
  --       animation = require('mini.indentscope').gen_animation.none(),
  --     },
  --   },
  --   init = function()
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = {
  --         'help',
  --         'alpha',
  --         'dashboard',
  --         'neo-tree',
  --         'Trouble',
  --         'trouble',
  --         'lazy',
  --         'mason',
  --         'notify',
  --         'toggleterm',
  --         'lazyterm',
  --       },
  --       callback = function()
  --         vim.b.miniindentscope_disable = true
  --       end,
  --     })
  --   end,
  -- },

  -- Scrollbar
  {
    'petertriho/nvim-scrollbar',
    event = 'BufReadPost',
    config = function()
      local scrollbar = require 'scrollbar'
      scrollbar.setup {
        handle = {
          color = '#51504f',
        },
        marks = {
          Search = { color = '#ff9e64' },
          Error = { color = '#db4b4b' },
          Warn = { color = '#e0af68' },
          Info = { color = '#0db9d7' },
          Hint = { color = '#1abc9c' },
          Misc = { color = '#9d7cd8' },
        },
      }
    end,
  },
}
