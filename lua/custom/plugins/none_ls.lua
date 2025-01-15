return {
  'nvimtools/none-ls.nvim',
  ft = { 'python' },
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local opts = {
      null_ls.builtins.diagnostics.mypy,
      -- null_ls.builtins.diagnostics.ruff,
      require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      require 'none-ls.formatting.ruff_format',
    }
    null_ls.setup(opts)
  end,
}
