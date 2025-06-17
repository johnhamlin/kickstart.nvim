return {
  {
    'kevinhwang91/nvim-ufo',
    event = 'BufReadPost',
    dependencies = {
      'kevinhwang91/promise-async',
      'nvim-treesitter/nvim-treesitter',
    },
    init = function()
      -- UFO requires these global settings to work properly
      vim.o.foldcolumn = '1' -- Show fold column
      vim.o.foldlevel = 99 -- Start with all folds open
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider requires remap of `zR` and `zM`
      -- (which you've already done with leader mappings)
    end,
    opts = {
      -- Provider selector with better defaults
      provider_selector = function(bufnr, filetype, buftype)
        -- Return a table of providers in priority order
        local function handleFallbackException(err, providerName)
          if type(err) == 'string' and err:match 'UfoFallbackException' then
            return require('ufo').getFolds(bufnr, providerName)
          else
            return require('promise').reject(err)
          end
        end

        -- Special handling for certain filetypes
        if filetype == '' or buftype == 'nofile' then
          return '' -- Disable UFO
        end

        -- For Markdown, prefer Treesitter
        if filetype == 'markdown' then
          return { 'treesitter', 'indent' }
        end

        -- For most code files, try LSP first, then Treesitter, then indent
        return {
          function(buf)
            return require('ufo')
              .getFolds(buf, 'lsp')
              :catch(function(err)
                return handleFallbackException(err, 'treesitter')
              end)
              :catch(function(err)
                return handleFallbackException(err, 'indent')
              end)
          end,
        }
      end,

      -- Fold virtual text customization
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end

        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,

      -- Preview window configuration
      preview = {
        win_config = {
          border = 'rounded',
          winhighlight = 'Normal:Folded',
          winblend = 0,
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
          jumpTop = '[',
          jumpBot = ']',
        },
      },

      -- Performance options
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { 'imports', 'comment' },
        json = { 'array' },
        c = { 'comment', 'region' },
      },

      -- Enable fold status indicator in status column
      enable_get_fold_virt_text = true,
    },
    config = function(_, opts)
      -- Setup UFO
      local ufo = require 'ufo'
      ufo.setup(opts)

      -- Fancy fold column icons
      -- Define fill characters with exactly one character each to avoid E1511
      -- See :help 'fillchars' for valid fields. Using table form is clearer and safer.
      vim.opt.fillchars = {
        eob = ' ',        -- Empty lines at the end of buffer
        fold = ' ',       -- Fold lines
        foldopen = '',  -- Icon for open fold (Nerd Font)
        foldclose = '', -- Icon for closed fold (Nerd Font)
        foldsep = ' ',    -- Fold column separator
      }

      -- Better fold text highlighting
      vim.api.nvim_set_hl(0, 'Folded', { bg = 'none', fg = '#6c7086' })
      vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none', fg = '#6c7086' })

      -- Keymaps
      local map = vim.keymap.set

      -- Basic fold operations using UFO methods (better than native commands)
      map('n', '<leader>fR', ufo.openAllFolds, { desc = '[F]old open all folds' })
      map('n', '<leader>fM', ufo.closeAllFolds, { desc = '[F]old close all folds' })

      -- Single fold operations (from your keymaps.lua)
      map('n', '<leader>fo', 'zo', { desc = '[F]old [O]pen fold under cursor' })
      map('n', '<leader>fc', 'zc', { desc = '[F]old [C]lose fold under cursor' })
      map('n', '<leader>ft', 'za', { desc = '[F]old [T]oggle fold under cursor' })

      -- Recursive fold operations
      map('n', '<leader>fO', 'zO', { desc = '[F]old [O]pen all folds under cursor recursively' })
      map('n', '<leader>fC', 'zC', { desc = '[F]old [C]lose all folds under cursor recursively' })

      -- Fold level operations (UFO handles these differently)
      map('n', '<leader>fr', function()
        -- UFO doesn't have direct fold level manipulation, use vim's native
        vim.cmd 'normal! zr'
      end, { desc = '[F]old reduce fold level by 1' })

      map('n', '<leader>fm', function()
        -- UFO doesn't have direct fold level manipulation, use vim's native
        vim.cmd 'normal! zm'
      end, { desc = '[F]old increase fold level by 1' })

      -- UFO-specific features
      map('n', '<leader>fI', function()
        ufo.openFoldsExceptKinds { 'imports', 'comment' }
      end, { desc = '[F]old open all except [I]mports/comments' })

      -- Peek fold with hover fallback
      map('n', '<leader>fp', function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = '[F]old [P]review' })

      -- Focus current fold (close all, then open current)
      map('n', '<leader>ff', function()
        ufo.closeAllFolds()
        vim.schedule(function()
          vim.cmd 'normal! zv' -- View cursor line (opens just enough folds)
        end)
      end, { desc = '[F]old [F]ocus current' })

      -- Navigation between closed folds
      map('n', '<leader>fj', function()
        ufo.goNextClosedFold()
      end, { desc = '[F]old go to next closed' })

      map('n', '<leader>fk', function()
        ufo.goPreviousClosedFold()
      end, { desc = '[F]old go to previous closed' })

      -- Apply fold changes for specific filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'neo-tree', 'aerial', 'help', 'lazy' },
        callback = function()
          ufo.detach()
        end,
      })

      -- Better fold commands that work with UFO
      vim.api.nvim_create_user_command('FoldAll', function()
        ufo.closeAllFolds()
      end, { desc = 'Close all folds' })

      vim.api.nvim_create_user_command('UnfoldAll', function()
        ufo.openAllFolds()
      end, { desc = 'Open all folds' })

      -- Apply folds based on indentation level
      vim.api.nvim_create_user_command('FoldLevel', function(args)
        local level = tonumber(args.args) or 1
        ufo.closeFoldsWith(level)
      end, {
        nargs = '?',
        desc = 'Fold to specified level',
      })
    end,
  },
}
