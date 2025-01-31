local M = {}
local config = require 'custom.plugins.local_plugins.startup_project.config'

M.setup = function()
  -- Auto-load startup project
  local function load_startup_project()
    local startup_project = config.get_project()
    if startup_project then
      print('Loaded startup project: ' .. startup_project)
    end
  end

  -- Auto-load startup project on startup
  load_startup_project()

  -- Commands
  vim.api.nvim_create_user_command('SetStartupProject', function()
    require('custom.plugins.local_plugins.startup_project.picker').pick_project()
  end, {})

  vim.api.nvim_create_user_command('ShowStartupProject', function()
    local project = config.get_project()
    if project then
      print('Startup project for current directory: ' .. project)
    else
      print 'No startup project set for this directory.'
    end
  end, {})
end

return M
