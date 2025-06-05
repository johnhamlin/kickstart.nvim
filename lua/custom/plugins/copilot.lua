-- lua/custom/plugins/copilot.lua
-- Feature-rich Copilot configuration focused on chat and agent features

return {
  -- Core Copilot plugin (lightweight, just for authentication)
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        -- Disable autocomplete suggestions since you don't find them helpful
        suggestion = { enabled = false },
        panel = { enabled = false },

        -- Keep authentication and basic functionality
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      }
    end,
  },

  -- Main Copilot Chat plugin - this is where the magic happens
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main', -- Use main branch (canary is deprecated)
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      debug = false, -- Enable debugging

      -- Model selection
      model = 'gpt-4', -- GPT-4 for better code understanding

      -- Chat window configuration
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        border = 'rounded', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        title = 'Copilot Chat', -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },

      -- Chat behavior
      question_header = '## User ', -- Header to use for user questions
      answer_header = '## Copilot ', -- Header to use for AI answers
      error_header = '## Error ', -- Header to use for errors
      separator = '───', -- Separator to use in chat

      -- Default prompts
      prompts = {
        Explain = {
          prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
        },
        Review = {
          prompt = '/COPILOT_REVIEW Review the selected code.',
          callback = function(response, source)
            -- Custom callback for code review
            local ns = vim.api.nvim_create_namespace 'copilot_review'
            local diagnostics = {}
            -- Process response and create diagnostics if needed
          end,
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
        CommitStaged = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source, true)
          end,
        },
      },

      -- Auto-follow cursor in chat
      auto_follow_cursor = true, -- Don't follow the cursor after getting response
      auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
      clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
      highlight_selection = true, -- Highlight selection in the source buffer when in the chat window

      -- Enable chat autocompletion
      chat_autocomplete = true,

      -- Context and history
      context = 'buffers', -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
      history_path = vim.fn.stdpath 'data' .. '/copilotchat_history', -- Default path to stored history
      callback = nil, -- Callback to use when ask response is received

      -- Selection
      selection = function(source)
        return require('CopilotChat.select').visual(source) or require('CopilotChat.select').buffer(source)
      end,

      -- Mappings
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
    config = function(_, opts)
      local chat = require 'CopilotChat'
      local select = require 'CopilotChat.select'

      chat.setup(opts)

      -- Custom functions for advanced workflows
      vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = '*', range = true })

      -- Function to automatically include git diff context
      vim.api.nvim_create_user_command('CopilotChatInline', function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = 'float',
            relative = 'cursor',
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = '*', range = true })

      -- Advanced prompt for architectural discussions
      vim.api.nvim_create_user_command('CopilotChatArchitecture', function()
        local input = vim.fn.input 'Architecture question: '
        if input ~= '' then
          chat.ask(
            'As a senior software architect, please help me with this architectural decision: '
              .. input
              .. '\n\nConsider: scalability, maintainability, performance, security, and best practices. Provide pros/cons and recommendations.',
            { selection = select.buffer }
          )
        end
      end, {})

      -- Code review with specific focus areas
      vim.api.nvim_create_user_command('CopilotChatCodeReview', function()
        chat.ask(
          'Please provide a thorough code review of this selection. Focus on:\n'
            .. '1. Code quality and readability\n'
            .. '2. Potential bugs or edge cases\n'
            .. '3. Performance considerations\n'
            .. '4. Security concerns\n'
            .. '5. Best practices and conventions\n'
            .. '6. Suggestions for improvement',
          { selection = select.visual }
        )
      end, {})

      -- Debugging helper
      vim.api.nvim_create_user_command('CopilotChatDebug', function()
        chat.ask(
          "I'm having trouble debugging this code. Please:\n"
            .. '1. Identify potential issues\n'
            .. '2. Suggest debugging strategies\n'
            .. '3. Recommend logging or testing approaches\n'
            .. '4. Help me understand what might be going wrong',
          { selection = select.visual }
        )
      end, {})

      -- Performance optimization
      vim.api.nvim_create_user_command('CopilotChatOptimize', function()
        chat.ask(
          'Please analyze this code for performance optimization opportunities:\n'
            .. '1. Identify bottlenecks\n'
            .. '2. Suggest algorithmic improvements\n'
            .. '3. Recommend memory optimization\n'
            .. '4. Consider time complexity\n'
            .. '5. Provide optimized version if possible',
          { selection = select.visual }
        )
      end, {})
    end,
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

      -- Advanced commands
      { '<leader>cca', '<cmd>CopilotChatArchitecture<cr>', desc = 'Copilot Chat Architecture' },
      { '<leader>ccR', '<cmd>CopilotChatCodeReview<cr>', desc = 'Copilot Chat Code Review', mode = 'v' },
      { '<leader>ccb', '<cmd>CopilotChatDebug<cr>', desc = 'Copilot Chat Debug', mode = 'v' },
      { '<leader>ccO', '<cmd>CopilotChatOptimize<cr>', desc = 'Copilot Chat Optimize Advanced', mode = 'v' },

      -- Inline and visual modes
      { '<leader>cci', '<cmd>CopilotChatInline<cr>', desc = 'Copilot Chat Inline', mode = 'v' },
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

      -- Buffer and selection context
      {
        '<leader>ccs',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'Copilot Chat Prompt Actions (Telescope)',
      },
    },
    cmd = {
      'CopilotChat',
      'CopilotChatOpen',
      'CopilotChatClose',
      'CopilotChatToggle',
      'CopilotChatStop',
      'CopilotChatReset',
      'CopilotChatSave',
      'CopilotChatLoad',
      'CopilotChatDebugInfo',
      'CopilotChatExplain',
      'CopilotChatReview',
      'CopilotChatFix',
      'CopilotChatOptimize',
      'CopilotChatDocs',
      'CopilotChatTests',
      'CopilotChatFixDiagnostic',
      'CopilotChatCommit',
      'CopilotChatCommitStaged',
    },
  },

  -- Optional: Enhanced with Telescope integration
  {
    'nvim-telescope/telescope.nvim',
    optional = true,
    opts = function(_, opts)
      -- Simple check for CopilotChat without utils dependency
      local ok, _ = pcall(require, 'CopilotChat')
      if ok then
        opts.extensions = opts.extensions or {}
        opts.extensions.copilot = {
          theme = 'dropdown',
          layout_config = {
            width = 0.8,
            height = 0.6,
          },
        }
      end
      return opts
    end,
  },
}
