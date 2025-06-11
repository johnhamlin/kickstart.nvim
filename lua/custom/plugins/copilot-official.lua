-- lua/custom/plugins/copilot.lua
-- Official GitHub Copilot configuration for corporate environments

return {
  -- Official GitHub Copilot plugin (better proxy support)
  {
    'github/copilot.vim',
    event = 'VimEnter',
    config = function()
      -- Disable default tab mapping if you want to use your own
      vim.g.copilot_no_tab_map = true

      -- Optional: Set specific node command if needed
      -- vim.g.copilot_node_command = 'node'

      -- Enable Copilot for specific filetypes (optional)
      vim.g.copilot_filetypes = {
        ['*'] = true,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        vimwiki = false,
        ['.'] = false,
      }

      -- Custom accept mapping (optional)
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.keymap.set('i', '<C-]>', '<Plug>(copilot-dismiss)')
      vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-suggest)')

      -- Navigation between suggestions
      vim.keymap.set('i', '<M-]>', '<Plug>(copilot-next)')
      vim.keymap.set('i', '<M-[>', '<Plug>(copilot-previous)')
    end,
    cmd = 'Copilot',
  },

  -- Official Copilot Chat plugin (if available)
  -- Note: As of my last update, GitHub's official chat plugin might not be available yet
  -- You can check https://github.com/github for updates

  -- Alternative: Keep CopilotChat but use official base
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'github/copilot.vim' }, -- Use official plugin as dependency
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken',
    opts = {
      debug = false,
      model = 'gpt-4',

      -- Proxy-friendly settings
      timeout = 10000, -- Increase timeout for slow proxy connections

      window = {
        layout = 'vertical',
        width = 0.5,
        height = 0.5,
        border = 'rounded',
        title = 'Copilot Chat',
      },

      question_header = '## User ',
      answer_header = '## Copilot ',
      error_header = '## Error ',
      separator = '───',

      prompts = {
        Explain = {
          prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
        },
        Review = {
          prompt = '/COPILOT_REVIEW Review the selected code.',
        },
        Fix = {
          prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to fix the problem.',
        },
        Optimize = {
          prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readability.',
        },
        Docs = {
          prompt = '/COPILOT_GENERATE Please add documentation comment for the selection.',
        },
        Tests = {
          prompt = '/COPILOT_GENERATE Please generate tests for my code.',
        },
        FixDiagnostic = {
          prompt = 'Please assist with the following diagnostic issue in file:',
          selection = function(source)
            return require('CopilotChat.select').diagnostics(source)
          end,
        },
        Commit = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source)
          end,
        },
      },

      auto_follow_cursor = true,
      auto_insert_mode = false,
      clear_chat_on_new_prompt = false,
      highlight_selection = true,
      chat_autocomplete = true,
      context = 'buffers',
      history_path = vim.fn.stdpath 'data' .. '/copilotchat_history',

      selection = function(source)
        return require('CopilotChat.select').visual(source) or require('CopilotChat.select').buffer(source)
      end,

      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        yank_diff = {
          normal = 'gy',
          register = '"',
        },
        show_diff = {
          normal = 'gd',
        },
        show_info = {
          normal = 'gp',
        },
        show_context = {
          normal = 'gs',
        },
      },
    },
    keys = {
      -- Main chat toggle
      { '<leader>cc', '<cmd>CopilotChatToggle<cr>', desc = 'Copilot Chat Toggle' },
      { '<leader>ccr', '<cmd>CopilotChatReset<cr>', desc = 'Copilot Chat Reset' },

      -- Quick actions
      { '<leader>cce', '<cmd>CopilotChatExplain<cr>', desc = 'Copilot Chat Explain', mode = { 'n', 'v' } },
      { '<leader>ccv', '<cmd>CopilotChatReview<cr>', desc = 'Copilot Chat Review', mode = { 'n', 'v' } },
      { '<leader>ccf', '<cmd>CopilotChatFix<cr>', desc = 'Copilot Chat Fix', mode = { 'n', 'v' } },
      { '<leader>cco', '<cmd>CopilotChatOptimize<cr>', desc = 'Copilot Chat Optimize', mode = { 'n', 'v' } },
      { '<leader>ccd', '<cmd>CopilotChatDocs<cr>', desc = 'Copilot Chat Docs', mode = { 'n', 'v' } },
      { '<leader>cct', '<cmd>CopilotChatTests<cr>', desc = 'Copilot Chat Tests', mode = { 'n', 'v' } },
      { '<leader>ccD', '<cmd>CopilotChatFixDiagnostic<cr>', desc = 'Copilot Chat Fix Diagnostic' },

      -- Git integration
      { '<leader>ccm', '<cmd>CopilotChatCommit<cr>', desc = 'Copilot Chat Commit' },
      { '<leader>ccM', '<cmd>CopilotChatCommitStaged<cr>', desc = 'Copilot Chat Commit Staged' },

      -- Quick chat
      {
        '<leader>ccq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'Copilot Chat Quick Chat',
      },
    },
    cmd = {
      'CopilotChat',
      'CopilotChatOpen',
      'CopilotChatClose',
      'CopilotChatToggle',
      'CopilotChatStop',
      'CopilotChatReset',
      'CopilotChatExplain',
      'CopilotChatReview',
      'CopilotChatFix',
      'CopilotChatOptimize',
      'CopilotChatDocs',
      'CopilotChatTests',
      'CopilotChatFixDiagnostic',
      'CopilotChatCommit',
    },
  },
}
