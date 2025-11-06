local M = {}

local state = {
  floating = { buf = -1, win = -1, id = -1 },
  bottom = { buf = -1, win = -1, id = -1 },
}

local floating_terminal_default_height = math.floor(vim.o.lines * 0.8)
local floating_terminal_default_width = math.floor(vim.o.columns * 0.8)
local bottom_terminal_default_height = math.floor(vim.o.lines * 0.3)

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or floating_terminal_default_width
  local height = opts.height or floating_terminal_default_height
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf or vim.api.nvim_create_buf(false, true)

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

local function create_bottom_window(opts)
  opts = opts or {}
  local width = vim.o.columns
  local height = opts.height or bottom_terminal_default_height
  local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf or vim.api.nvim_create_buf(false, true)

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = 0,
    row = vim.o.lines - height,
    style = 'minimal',
    border = 'single',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

local function toggle_terminal(state_entry, create_window, command, width, height)
  -- Check if the terminal window is open and toggle its visibility
  if not vim.api.nvim_win_is_valid(state_entry.win) then
    -- If not open, create a new terminal window
    local tmp_state_entry = create_window { buf = state_entry.buf, width = width, height = height }
    state_entry.buf = tmp_state_entry.buf
    state_entry.win = tmp_state_entry.win

    if vim.bo[state_entry.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
      state_entry.id = vim.b.terminal_job_id
    end

    if command then
      vim.fn.chansend(vim.b.terminal_job_id, command .. '\r\n')
    end
  else
    -- If it's open, hide the window
    vim.api.nvim_win_hide(state_entry.win)
  end
end

function M.toggle_floating_terminal(command, width, height)
  toggle_terminal(state.floating, create_floating_window, command, width, height)
end

function M.toggle_bottom_terminal(command, height)
  toggle_terminal(state.bottom, function(opts)
    opts.height = height
    return create_bottom_window(opts)
  end, command, nil, height)
end

function M.open_bottom_terminal(command, height)
  if not vim.api.nvim_win_is_valid(state.bottom.win) then
    toggle_terminal(state.bottom, function(opts)
      opts.height = height
      return create_bottom_window(opts)
    end, command, nil, height)
  else
    vim.fn.chansend(state.bottom.id, command .. '\r\n')
  end
end

-- Command to toggle and resize bottom terminal
vim.api.nvim_create_user_command('ResizeBottomTerminal', function(opts)
  local height = opts.args ~= '' and tonumber(opts.args) or bottom_terminal_default_height
  local terminal = require 'terminal'

  if vim.api.nvim_win_is_valid(terminal.state.bottom.win) then
    vim.api.nvim_win_set_height(terminal.state.bottom.win, height)
  else
    terminal.toggle_bottom_terminal(nil, height)
  end
end, { nargs = '?' })

-- Command to toggle and pass command to bottom terminal
vim.api.nvim_create_user_command('ToggleBottomTerminal', function(opts)
  local terminal = require 'terminal'

  terminal.toggle_bottom_terminal(opts.args)
end, { nargs = '?' })

-- Command to resize floating terminal
vim.api.nvim_create_user_command('ResizeFloatingTerminal', function(opts)
  local args = vim.split(opts.args, ' ')
  local width = tonumber(args[1]) or floating_terminal_default_width
  local height = tonumber(args[2]) or floating_terminal_default_height
  local terminal = require 'terminal'

  -- If the floating terminal is already open, reuse the buffer and resize the window
  if vim.api.nvim_win_is_valid(terminal.state.floating.win) then
    vim.api.nvim_win_set_height(terminal.state.floating.win, height)
    vim.api.nvim_win_set_width(terminal.state.floating.win, width)
  else
    -- If the floating terminal is not open, create a new one
    terminal.toggle_floating_terminal(nil, width, height)
  end
end, { nargs = '?' })

-- Command to toggle and pass command to floating terminal
vim.api.nvim_create_user_command('ToggleFloatingTerminal', function(opts)
  local terminal = require 'terminal'

  terminal.toggle_floating_terminal(opts.args)
end, { nargs = '?' })

-- Keymap definitions to toggle terminals
vim.api.nvim_set_keymap(
  'n',
  '<leader>tf',
  ':lua require("terminal").toggle_floating_terminal()<CR>',
  { desc = '[T]oggle [F]loating Terminal', noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  't',
  '<leader>tf',
  ':lua require("terminal").toggle_floating_terminal()<CR>',
  { desc = '[T]oggle [F]loating [T]erminal', noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>tb',
  ':lua require("terminal").toggle_bottom_terminal()<CR>',
  { desc = '[T]oggle [B]ottom Terminal', noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  't',
  '<leader>tb',
  ':lua require("terminal").toggle_bottom_terminal()<CR>',
  { desc = '[T]oggle [B]ottom Terminal', noremap = true, silent = true }
)

return M
