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

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'jay-babu/mason-null-ls.nvim',
      'mason-org/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
    },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
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
      format_on_save = get_format_options,
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
}
-- vim: ts=2 sts=2 sw=2 et
