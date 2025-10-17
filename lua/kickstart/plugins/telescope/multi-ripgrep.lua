local conf = require('telescope.config').values
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local pickers = require 'telescope.pickers'

local flatten = vim.tbl_flatten

-- i would like to be able to do telescope
-- and have telescope do some filtering on files and some grepping

return function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.shortcuts = opts.shortcuts or {
    ['l'] = '*.lua',
    ['v'] = '*.vim',
    ['n'] = '*.{vim,lua}',
    ['c'] = '*.c',
  }
  opts.pattern = opts.pattern or '%s'

  -- Helper: gather buffer names depending on flags
  local function get_target_buffers()
    local bufs = {}
    local mode = opts.grep_visible_only and 'visible' or opts.grep_open_files and 'listed' or nil

    if not mode then
      return nil -- no restriction
    end

    -- visible buffers
    if mode == 'visible' then
      local wins = vim.api.nvim_list_wins()
      for _, win in ipairs(wins) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name ~= '' and vim.loop.fs_stat(name) then
          table.insert(bufs, name)
        end
      end
      return bufs
    end

    -- listed buffers (the ones shown in :ls)
    if mode == 'listed' then
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
          local name = vim.api.nvim_buf_get_name(bufnr)
          if name ~= '' and vim.loop.fs_stat(name) then
            table.insert(bufs, name)
          end
        end
      end
      return bufs
    end
  end

  local custom_grep = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local prompt_split = vim.split(prompt, '  ')

      local args = { 'rg' }
      if prompt_split[1] then
        table.insert(args, '-e')
        table.insert(args, prompt_split[1])
      end

      if prompt_split[2] then
        table.insert(args, '-g')

        local pattern
        if opts.shortcuts[prompt_split[2]] then
          pattern = opts.shortcuts[prompt_split[2]]
        else
          pattern = prompt_split[2]
        end

        table.insert(args, string.format(opts.pattern, pattern))
      end

      local common_args = { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }

      local target_files = get_target_buffers()
      if target_files and not vim.tbl_isempty(target_files) then
        args = flatten { args, common_args, '--', target_files }
      else
        args = flatten { args, common_args }
      end
      return args
    end,
    entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Live Grep (with shortcuts)',
      finder = custom_grep,
      previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end
