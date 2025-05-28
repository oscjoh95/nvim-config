return {
  'git_conflict_status',
  dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/local_plugins/git_conflict_status',
  name = 'git_conflict_status',
  config = function()
    require('custom.plugins.local_plugins.git_conflict_status').setup()
  end,
}
