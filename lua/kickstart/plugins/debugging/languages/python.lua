return {
  'mfussenegger/nvim-dap-python',
  dependencies = {
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
  },
  -- ft = { 'python', 'py' },

  config = function()
    local dap = require 'dap'
    dap.configurations.python[1].pythonPath = os.getenv 'CONDA_PREFIX' .. '\\python.exe'
    require('dap-python').setup 'C:\\Users\\BLOC\\AppData\\Local\\nvim-data\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe'
    -- require('dap-python').setup(
    -- 'C:\\Users\\BLOC\\AppData\\Local\\nvim-data\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe',
    -- { pythonPath = os.getenv 'CONDA_PREFIX' .. '\\python.exe' }
    -- )
    -- require('dap-python').resolve_python = function()
    --   return os.getenv 'CONDA_PREFIX' .. '\\python.exe'
    -- end
  end,
}
