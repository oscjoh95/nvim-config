-- lua/build_and_test.lua
local M = {}

-- Utility: find the .sln for the current buffer
local function find_sln()
  local current_dir = vim.fn.expand '%:p:h'
  local dir = current_dir
  while dir ~= '' and dir ~= '/' do
    local files = vim.fn.globpath(dir, '*.sln', false, true)
    if #files > 0 then
      return files[1]
    end
    dir = vim.fn.fnamemodify(dir, ':h')
  end
  return nil
end

local function open_terminal(cmd)
  require('terminal').open_bottom_terminal(cmd, 15)
  vim.cmd 'normal! G'
end

-- Build function: opens a terminal split and runs msbuild
function M.build_current_solution(configuration)
  local sln_file = find_sln()
  if not sln_file then
    print 'No .sln file found for current buffer!'
    return
  end

  configuration = configuration or 'Debug'
  local cmd = string.format('msbuild.exe "%s" -p:Configuration=%s', sln_file, configuration)

  open_terminal(cmd)
end

function M.setup()
  vim.keymap.set('n', '<leader>bcd', function()
    M.build_current_solution 'Debug'
  end, { silent = true, desc = '[b]uild [c]urrent in [d]ebug' })
  vim.keymap.set('n', '<leader>bcr', function()
    M.build_current_solution 'Release'
  end, { silent = true, desc = '[b]uild [c]urrent in [r]elease' })
end

return M
