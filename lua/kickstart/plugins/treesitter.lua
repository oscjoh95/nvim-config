return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'python' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },

      -- Incremental selection setup with Treesitter
      -- check out what this does!
      incremental_selection = {
        enable = true,
        keymaps = {
          -- Keymaps for incremental selection
          init_selection = 'gnn', -- Start selection (default to 'gnn')
          node_incremental = 'grn', -- Increment selection to the next node (default to 'grn')
          scope_incremental = 'grc', -- Increment selection to the scope (default to 'grc')
          node_decremental = 'grm', -- Decrement selection (default to 'grm')
        },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (can be toggled per buffer with :TSContextToggle)
        throttle = true, -- Throttle updates (may improve performance)
        max_lines = 5, -- How many lines the context window should span. 0 = no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- Default patterns for all file types
          default = {
            'class',
            'function',
            'method',
          },
        },
        multiwindow = false, -- No multiwindow support
        min_window_height = 0, -- No limit on minimum window height
        line_numbers = true, -- Show line numbers in the context window
        multiline_threshold = 2, -- Max number of lines to show for a single context
        trim_scope = 'outer', -- Discard the outer context if `max_lines` is exceeded
        mode = 'cursor', -- Use the cursor position to calculate context
        separator = nil, -- No separator by default
        zindex = 20, -- Set the Z-index of the context window
        on_attach = nil, -- No custom on_attach function
      }
      vim.keymap.set('n', '<leader>[tc', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true, desc = 'Previous [C]ontext' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
