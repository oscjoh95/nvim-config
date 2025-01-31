local M = {}
local utils = require 'custom.plugins.local_plugins.startup_project.utils'
local config = require 'custom.plugins.local_plugins.startup_project.config'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local telescopeUtilities = require 'telescope.utils'
local telescopeMakeEntryModule = require 'telescope.make_entry'
local plenaryStrings = require 'plenary.strings'
local devIcons = require 'nvim-web-devicons'
local telescopeEntryDisplayModule = require 'telescope.pickers.entry_display'

-- Same width for everything
local fileTypeIconWidth = plenaryStrings.strdisplaywidth(devIcons.get_icon('fname', { default = true }))

-- Gets the File Path and its Tail (the file name) as a Tuple
local function getPathAndTail(fileName)
  -- Get the Tail
  local bufferNameTail = telescopeUtilities.path_tail(fileName)

  -- Now remove the tail from the Full Path
  local pathWithoutTail = require('plenary.strings').truncate(fileName, #fileName - #bufferNameTail, '')

  -- Apply truncation and other pertaining modifications to the path according to Telescope path rules
  local pathToDisplay = telescopeUtilities.transform_path({
    path_display = { 'truncate' },
  }, pathWithoutTail)

  -- Return as Tuple
  return bufferNameTail, pathToDisplay
end

local local_entry_maker = function(options)
  options = options or {}
  local originalEntryMaker = telescopeMakeEntryModule.gen_from_file(options)

  local current_project = config.get_project()
  local current_project_tail = current_project and telescopeUtilities.path_tail(current_project) .. ' ' or ''

  local function checkIfCurrentProject(current_project, current_project_tail, tmpTail, tmpPath)
    if current_project == nil then
      return false
    end

    if current_project_tail ~= tmpTail then
      return false
    end

    local _, current_project_path = getPathAndTail(current_project)

    return current_project_path == tmpPath
  end

  return function(line)
    -- Generate the Original Entry table
    local originalEntryTable = originalEntryMaker(line)

    local displayer = telescopeEntryDisplayModule.create {
      separator = ' ', -- Telescope will use this separator between each entry item
      items = {
        { width = fileTypeIconWidth },
        { width = nil },
        { remaining = true },
      },
    }

    -- HELP: Read the 'make_entry.lua' file for more info on how all of this works
    originalEntryTable.display = function(entry)
      -- Get the Tail and the Path to display
      local tail, tmpPathToDisplay = getPathAndTail(entry.value)

      -- Add an extra space to the tail so that it looks nicely separated from the path
      local tmpTailForDisplay = tail .. ' '

      -- Get the Icon with its corresponding Highlight information
      local icon, iconHighlight = telescopeUtilities.get_devicons(tail)
      icon = ''

      -- Setup marker for selected workspace
      local pathToDisplay
      local tailForDisplay
      if checkIfCurrentProject(current_project, current_project_tail, tmpTailForDisplay, tmpPathToDisplay) then
        pathToDisplay = tmpPathToDisplay
        tailForDisplay = { tmpTailForDisplay, 'TelescopeResultsComment' }
      else
        pathToDisplay = { tmpPathToDisplay, 'TelescopeResultsComment' }
        tailForDisplay = tmpTailForDisplay
      end

      if tmpPathToDisplay ~= '.' then
        return displayer {
          { icon, iconHighlight },
          tailForDisplay,
          pathToDisplay,
        }
      else
        return displayer {
          { icon, iconHighlight },
          tailForDisplay,
        }
      end
    end

    return originalEntryTable
  end
end

function M.pick_project()
  local projects = utils.find_vcxproj_projects()

  if #projects == 0 then
    print 'No .vcxproj files found.'
    return
  end

  local current_project = config.get_project()
  local prompt_title = 'Select Startup Project'
  if current_project then
    prompt_title = prompt_title .. ' (' .. telescopeUtilities.path_tail(current_project) .. ')'
  end

  pickers
    .new({}, {
      prompt_title = prompt_title,
      finder = finders.new_table { results = projects, entry_maker = local_entry_maker {} },
      sorter = require('telescope.sorters').get_fuzzy_file {},
      attach_mappings = function(_, map)
        actions.select_default:replace(function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            config.set_project(selection[1])
          end
        end)
        return true
      end,
    })
    :find()
end

return M
