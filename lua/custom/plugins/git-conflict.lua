return {
  'akinsho/git-conflict.nvim',
  version = 'v2.1.0',
  event = 'VeryLazy',
  config = function()
    vim.api.nvim_set_hl(0, 'DiffText', { fg = '#ffffff', bg = '#1d3b40' })
    vim.api.nvim_set_hl(0, 'DiffAdd', { fg = '#ffffff', bg = '#1d3450' })
    require('git-conflict').setup {
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
      },
      default_mappings = false,
      disable_diagnostics = true,
      default_commands = true,
      list_opener = 'copen',
    }
    vim.keymap.set('n', '<leader>co', '<cmd>GitConflictChooseOurs<CR>')
    vim.keymap.set('n', '<leader>ct', '<cmd>GitConflictChooseTheirs<CR>')
    vim.keymap.set('n', '<leader>cb', '<cmd>GitConflictChooseBoth<CR>')
    vim.keymap.set('n', '<leader>c0', '<cmd>GitConflictChooseNone<CR>')
    vim.keymap.set('n', '[x', '<cmd>GitConflictPrevConflict<CR>')
    vim.keymap.set('n', ']x', '<cmd>GitConflictNextConflict<CR>')
    vim.keymap.set('n', '<leader>cq', '<cmd>GitConflictListQf<CR>')

    vim.api.nvim_create_autocmd('User', {
      pattern = 'GitConflictDetected',
      callback = function()
        vim.notify('Conflict detected in ' .. vim.fn.expand '<afile>')
      end,
    })
  end,
}
