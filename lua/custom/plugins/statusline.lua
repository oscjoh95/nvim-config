local function qf_or_loclist_status()
  -- First, check location list for the current window
  local loclist = vim.fn.getloclist(0, { idx = 0, size = 0 })
  if loclist.size > 0 then
    return string.format('[L:%d/%d]', loclist.idx, loclist.size)
  end

  -- Then, check global quickfix list
  local qflist = vim.fn.getqflist { idx = 0, size = 0 }
  if qflist.size > 0 then
    return string.format('[Q:%d/%d]', qflist.idx, qflist.size)
  end

  return ''
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    -- 'yavorski/lualine-macro-recording.nvim', -- For recording to display! Not needed if we use noice
    'folke/noice.nvim',
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

    local list_status = {
      separator = { left = '', right = '' },
      qf_or_loclist_status,
    }

    local conflicts = {
      separator = { left = '', right = '' },
      require('custom.plugins.local_plugins.git_conflict_status').status,
    }

    local mode = {
      separator = { left = '', right = '' },
      cond = require('noice').api.status.mode.has,
      require('noice').api.status.mode.get,
    }

    local command = {
      separator = { left = '', right = '' },
      cond = require('noice').api.status.command.has,
      require('noice').api.status.command.get,
    }

    vim.o.showcmd = true
    vim.o.showcmdloc = 'statusline'
    require('lualine').setup {
      options = {
        always_divide_middle = false,
        always_show_tabline = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        -- lualine_c = { 'filename', 'macro_recording' },
        lualine_c = { 'filename', mode },
        -- lualine_x = { command, conflicts },
        lualine_x = { '%S', conflicts },
        lualine_y = { diff, diagnostics },
        lualine_z = { location, progress },
      },
    }
  end,
}
