local M = {}

-- Normalize file paths for Windows and Unix-like systems
local function normalize_path(path)
  -- Replace backslashes with forward slashes for consistency
  return path:gsub('\\', '/')
end

-- Function to check if the file exists
local function file_exists(filepath)
  return vim.fn.filereadable(filepath) == 1
end

-- Function to get all sibling directories in the parent directory
local function get_sibling_dirs(parent_dir)
  -- List all directories in the parent directory (excluding files)
  local dirs = vim.fn.glob(parent_dir .. '/*', false, 1) -- The '1' flag returns directories
  local sibling_dirs = {}

  -- Filter out non-directories (glob can return files as well)
  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      local tmp_path = normalize_path(dir)
      table.insert(sibling_dirs, tmp_path)
    end
  end

  return sibling_dirs
end

local function remove_extension(filename)
  return filename:match '^(.-)%.?[^%.]*$'
end

M.switch_source_header = function()
  local current_file = vim.fn.expand '%:t' -- Current file name
  local current_dir = normalize_path(vim.fn.expand '%:p:h') -- Current file directory
  local parent_dir = normalize_path(vim.fn.fnamemodify(current_dir, ':h')) -- Parent directory
  local current_file_name = remove_extension(current_file)

  -- Determine the file type
  local is_header = current_file:match '%.h$' or current_file:match '%.hpp$'
  local is_source = current_file:match '%.cpp$' or current_file:match '%.c$' or current_file:match '%.cc$'

  -- Initialize best_match as nil
  local best_match = nil

  -- Step 1: Check if the corresponding file exists in the current directory
  if is_header then
    -- Searching for corresponding source file (cpp, c, or cc)
    local possible_source_files = {
      current_dir .. '/' .. current_file_name .. '.cpp',
      current_dir .. '/' .. current_file_name .. '.c',
      current_dir .. '/' .. current_file_name .. '.cc',
    }
    for _, source_file in ipairs(possible_source_files) do
      if file_exists(source_file) then
        best_match = source_file
        break
      end
    end
  elseif is_source then
    -- Searching for corresponding header file (h or hpp)
    local possible_header_files = {
      current_dir .. '/' .. current_file_name .. '.h',
      current_dir .. '/' .. current_file_name .. '.hpp',
    }
    for _, header_file in ipairs(possible_header_files) do
      if file_exists(header_file) then
        best_match = header_file
        break
      end
    end
  end

  -- Step 2: If no match found in the current directory, check sibling directories
  if not best_match then
    local sibling_dirs = get_sibling_dirs(parent_dir)

    -- Loop over sibling directories to find the corresponding file
    for _, sibling_dir in ipairs(sibling_dirs) do
      -- Skipping already searched directory
      if sibling_dir == current_dir then
        goto continue
      end

      if is_header then
        -- Searching for corresponding source file (cpp, c, or cc)
        local possible_source_files = {
          sibling_dir .. '/' .. current_file_name .. '.cpp',
          sibling_dir .. '/' .. current_file_name .. '.c',
          sibling_dir .. '/' .. current_file_name .. '.cc',
        }
        for _, source_file in ipairs(possible_source_files) do
          if file_exists(source_file) then
            best_match = source_file
            break
          end
        end
      elseif is_source then
        -- Searching for corresponding header file (h or hpp)
        local possible_header_files = {
          sibling_dir .. '/' .. current_file_name .. '.h',
          sibling_dir .. '/' .. current_file_name .. '.hpp',
        }
        for _, header_file in ipairs(possible_header_files) do
          if file_exists(header_file) then
            best_match = header_file
            break
          end
        end
      end

      -- Break the loop if a match is found
      if best_match then
        break
      end
      ::continue::
    end
  end

  -- Step 3: Open the matching file, if found
  if best_match then
    -- Ensure the path is properly escaped for Neovim
    local escaped_path = vim.fn.fnameescape(best_match)
    vim.cmd('edit ' .. escaped_path)
  else
    vim.notify('No suitable match found', vim.log.levels.WARN)
  end
end

return M
