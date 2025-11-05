return {
  'build_solution',
  dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/local_plugins/build_solution',
  name = 'build_solution',
  config = function()
    require('custom.plugins.local_plugins.build_solution').setup()
  end,
}
