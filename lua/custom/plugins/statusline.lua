return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/local_plugins/git_conflict_status',
      name = 'git_conflict_status',
    },
  },
  event = 'VeryLazy',
  config = function()
    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn', 'info', 'hint' },
      -- symbols = {
      --   error = ' ',
      --   warn = ' ',
      --   info = ' ',
      --   hint = ' ',
      -- },
      symbols = {
        error = ' ',
        warn = ' ',
        info = ' ',
        hint = ' ',
      },
      colored = true,
      update_in_insert = false,
      always_visible = false,
    }

    local diff = {
      'diff',
      -- symbols = { added = ' ', modified = ' ', removed = ' ' },
      -- separator = { left = '', right = '' },
      separator = { left = '', right = '' },
      symbols = { added = '+', modified = '~', removed = '-' },
      colored = true,
      always_visible = false,
    }

    local progress = {
      'progress',
      separator = { left = '', right = '' },
    }

    local location = {
      'location',
      separator = {
        left = '',
        right = '',
      },
    }

    local conflicts = {
      separator = { left = '', right = '' },
      require('custom.plugins.local_plugins.git_conflict_status').status,
    }

    require('lualine').setup {
      options = {
        always_divide_middle = false,
        always_show_tabline = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { conflicts },
        lualine_y = { diff, diagnostics },
        lualine_z = { location, progress },
      },
    }
  end,
}
