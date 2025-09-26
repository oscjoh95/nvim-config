local format_mode = 'all'

-- Simple toggle command
vim.api.nvim_create_user_command('ToggleFormatMode', function()
  if format_mode == 'hunks' then
    format_mode = 'all'
    vim.notify('Format mode: FULL BUFFER', vim.log.levels.INFO)
  else
    format_mode = 'hunks'
    vim.notify('Format mode: HUNKS ONLY', vim.log.levels.INFO)
  end
end, { desc = 'Toggle between hunk-only formatting and full buffer formatting' })

-- Decide which filetypes should use hunk-only formatting
local hunk_only_filetypes = {
  python = true,
  cpp = true,
  c = true,
  h = true,
  hpp = true,
  -- add more if you want
}

local function get_format_options(bufnr)
  -- Disable "format_on_save lsp_fallback" for languages that don't
  -- have a well standardized coding style. You can add additional
  -- languages here or re-enable it for the disabled ones.
  local disable_filetypes = { c = true, cpp = false }
  if disable_filetypes[vim.bo[bufnr].filetype] then
    return nil
  else
    return {
      timeout_ms = 2000,
      lsp_format = 'never',
    }
  end
end

local function format_hunk(async)
  local ignore_filetypes = { 'lua' }
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    vim.notify('range formatting for ' .. vim.bo.filetype .. ' not working properly.')
    return
  end

  local hunks = require('gitsigns').get_hunks()
  if hunks == nil then
    return
  end

  local format = require('conform').format

  local function format_range()
    if next(hunks) == nil then
      vim.notify('done formatting git hunks', 'info', { title = 'formatting' })
      return
    end
    local hunk = nil
    while next(hunks) ~= nil and (hunk == nil or hunk.type == 'delete') do
      hunk = table.remove(hunks)
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local format_opts = get_format_options(bufnr)
    if not format_opts then
      vim.notify('Formatting disabled for this filetype', vim.log.levels.INFO)
    end

    if hunk ~= nil and hunk.type ~= 'delete' then
      local start = hunk.added.start
      local last = start + hunk.added.count
      local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
      local range = { start = { start, 0 }, ['end'] = { last - 1, last_hunk_line:len() } }
      -- format(vim.tbl_extend('force', { range = range, async = async ~= false }, format_opts), function()
      --   vim.defer_fn(function()
      --     format_range()
      --   end, 1)
      -- end)
      local opts = vim.tbl_extend('force', { range = range, async = async ~= false }, format_opts)

      if opts.async then
        format(opts, function()
          vim.defer_fn(format_range, 1)
        end)
      else
        format(opts)
        format_range()
      end
    end
  end

  format_range()
end

-- Autocmd: only use hunk formatting on save for selected filetypes
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args)
    if hunk_only_filetypes[vim.bo[args.buf].filetype] then
      local bufnr = args.buf
      local ft = vim.bo[bufnr].filetype
      local format_opts = get_format_options(bufnr)

      if not format_opts then
        return
      end

      if format_mode == 'hunks' then
        format_hunk(false) -- sync on save
      else
        require('conform').format(vim.tbl_extend('force', format_opts, { async = false }))
      end
    end
  end,
})

-- Command :W = format full buffer, then save
vim.api.nvim_create_user_command('W', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local format_opts = get_format_options(bufnr)
  if format_opts then
    require('conform').format(vim.tbl_extend('force', format_opts, { async = false }))
  end
  vim.cmd 'write'
end, { desc = 'Format whole buffer and save' })

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'jay-babu/mason-null-ls.nvim',
      'mason-org/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'lewis6991/gitsigns.nvim',
    },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>F',
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local format_opts = get_format_options(bufnr)
          if format_opts then
            require('conform').format(vim.tbl_extend('force', format_opts, { async = true }))
          else
            vim.notify('Formatting disabled for this filetype', vim.log.levels.INFO)
          end
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      default_format_opts = { lsp_format = 'never' },
      stop_after_first = false,
      -- format_on_save = get_format_options,
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if hunk_only_filetypes[ft] then
          return nil -- disable Conform save-formatting
        end
        return get_format_options(bufnr)
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        cpp = { 'clang_format' },
        c = { 'clang_format' },
        markdown = { 'markdownlint' },
        python = { 'ruff_organize_imports', 'ruff_format', 'ruff_fix' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      formatters = {
        clang_format = {
          prepend_args = { '--style=file', '--fallback-style=Chromium' },
        },
      },
    },
  },

  vim.keymap.set('n', '<leader>f', function()
    if format_mode == 'hunks' then
      format_hunk(true)
    else
      local bufnr = vim.api.nvim_get_current_buf()
      local format_opts = get_format_options(bufnr)
      if format_opts then
        require('conform').format(vim.tbl_extend('force', format_opts, { async = true }))
      end
    end
  end, { desc = '[F]ormat hunks (or buffer depending on mode) in current buffer' }),
}
-- vim: ts=2 sts=2 sw=2 et
