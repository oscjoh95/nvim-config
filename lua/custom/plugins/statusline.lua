local function git_conflict_status()
  local total_conflicts = 0
  local current_conflict = 0
  local in_conflict = false
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]

  for i = 1, vim.fn.line '$' do
    local line = vim.fn.getline(i)
    if line:match '^<<<<<<<' then
      total_conflicts = total_conflicts + 1
      in_conflict = true
    elseif line:match '^=======' and in_conflict then
      if i >= cursor_line then
        current_conflict = total_conflicts
        break
      end
    elseif line:match '^>>>>>>>' and in_conflict then
      in_conflict = false
    end
  end

  if total_conflicts == 0 then
    return ''
  elseif current_conflict > 0 then
    return 'Conflict: [' .. current_conflict .. '/' .. total_conflicts .. ']'
  else
    return 'Conflict: [x /' .. total_conflicts .. ']'
  end
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
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

      git_conflict_status,
      cond = function()
        return vim.bo.modifiable and vim.fn.search('<<<<<<<', 'nw') ~= 0
      end,
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
