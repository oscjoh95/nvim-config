return {
  dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/local_plugins/startup_project',
  name = 'startup_project',
  config = function()
    require('custom.plugins.local_plugins.startup_project').setup()

    vim.keymap.set('n', '<leader>sp', '<cmd>SetStartupProject<CR>', { silent = true, desc = 'Set startup project' })
  end,
}
