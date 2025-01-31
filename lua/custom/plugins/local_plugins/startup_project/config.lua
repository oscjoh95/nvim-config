local M = {}
local config_dir = vim.fn.stdpath 'data' .. '/startup_projects'
local config_path = config_dir .. '/startup_projects.json'

-- Ensure the directory exists
local function ensure_directory_exists()
  if vim.fn.isdirectory(config_dir) == 0 then
    vim.fn.mkdir(config_dir, 'p') -- "p" ensures parent directories are created if missing
  end
end

-- Load the configuration file
local function load_config()
  local file = io.open(config_path, 'r')
  if file then
    local content = file:read '*a'
    file:close()
    local data = vim.fn.json_decode(content)
    return data or {}
  end
  return {}
end

-- Save configuration to file
local function save_config(data)
  ensure_directory_exists()
  local file = io.open(config_path, 'w')
  if file then
    file:write(vim.fn.json_encode(data))
    file:close()
  end
end

-- Set project for current working directory
function M.set_project(project_path)
  local cwd = vim.fn.getcwd()
  local config = load_config()
  config[cwd] = project_path
  save_config(config)
  print('Startup project set to: ' .. project_path)
end

-- Get project for current working directory
function M.get_project()
  local cwd = vim.fn.getcwd()
  local config = load_config()
  return config[cwd] or nil
end

return M
