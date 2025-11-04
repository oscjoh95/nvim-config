return {
  'mfussenegger/nvim-dap-python',
  dependencies = {
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
  },
  ft = { 'python', 'py' },

  config = function()
    local dap = require 'dap'
    local conda_prefix = os.getenv 'CONDA_PREFIX' or 'C:\\Users\\BLOC\\AppData\\Local\\miniconda3'
    dap.configurations.python[1].pythonPath = conda_prefix .. '\\python.exe'
    require('dap-python').setup '{ C:\\Users\\JOSCA\\AppData\\Local\\nvim-data\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe , rocks = {enabled = false,},}'
    -- require('dap-python').setup(
    -- 'C:\\Users\\BLOC\\AppData\\Local\\nvim-data\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe',
    -- { pythonPath = os.getenv 'CONDA_PREFIX' .. '\\python.exe' }
    -- )
    -- require('dap-python').resolve_python = function()
    --   return os.getenv 'CONDA_PREFIX' .. '\\python.exe'
    -- end
  end,
}
