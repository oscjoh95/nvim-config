return {
  -- Preview markdown in browser
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown', 'md' },
  },

  -- Show preview in normal mode and code in insert
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  --   --     -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {},
  --   ft = { 'markdown', 'md' },
  -- },

  {
    'OXY2DEV/markview.nvim',
    lazy = false,

    dependencies = {
      'saghen/blink.cmp',
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons',
    },
    config = function()
      local preset = require 'markview.presets'
      require('markview').setup {
        markdown = {
          headings = preset.headings.slanted,
          tables = preset.tables.rounded,
        },
        experimental = {
          check_rtp_message = false, -- Disable warning that markview is loaded before nvim-treesitter
        },
      }
    end,
  },

  vim.keymap.set('n', '<leader>ch', 'I- [ ] ', { desc = 'Add checkbox at start of line' }),
}
