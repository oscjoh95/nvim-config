local M = {}

-- Cache to store conflict info per buffer
local conflict_cache = {}

-- Parses the buffer and updates the cache
local function update_conflict_cache(bufnr)
  local conflicts = {}
  local in_conflict = false
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    if line:match '^<<<<<<<' then
      in_conflict = true
      table.insert(conflicts, { start = i })
    elseif line:match '^=======' and in_conflict then
      if #conflicts > 0 then
        conflicts[#conflicts].middle = i
      end
    elseif line:match '^>>>>>>>' and in_conflict then
      if #conflicts > 0 then
        conflicts[#conflicts].end_ = i
      end
      in_conflict = false
    end
  end

  conflict_cache[bufnr] = conflicts
end

-- Public function: returns [2/3]-style string or ''
function M.status()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local conflicts = conflict_cache[bufnr]

  if not conflicts or #conflicts == 0 then
    return ''
  end

  for i, conflict in ipairs(conflicts) do
    if cursor_line >= conflict.start and cursor_line <= conflict.end_ then
      return string.format('Conflicts: [%d/%d]', i, #conflicts)
    end
  end

  return 'Conflicts: [x/' .. #conflicts .. ']'
end

-- Setup autocommands to keep cache updated
function M.setup()
  -- Update on read or change
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'TextChanged', 'TextChangedI' }, {
    callback = function(args)
      vim.defer_fn(function()
        update_conflict_cache(args.buf)
      end, 50)
    end,
  })

  -- Clean up on buffer wipe
  vim.api.nvim_create_autocmd('BufWipeout', {
    callback = function(args)
      conflict_cache[args.buf] = nil
    end,
  })
end

return M
