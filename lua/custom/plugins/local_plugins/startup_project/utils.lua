local M = {}

function M.find_vcxproj_projects()
  local files = vim.fn.systemlist 'fd -e vcxproj'
  local dirs = {}

  -- Loop through the files and get the directory part
  for _, file in ipairs(files) do
    -- Extract the directory from the file path
    local dir = vim.fn.fnamemodify(file, ':p:h')

    -- Check if this directory is not already in the dirs table
    if not vim.tbl_contains(dirs, dir) then
      table.insert(dirs, dir)
    end
  end

  return dirs
end

return M
