return {
  'petertriho/nvim-scrollbar',
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
  event = 'VeryLazy',
  config = function()
    require('scrollbar').setup()
    require('scrollbar.handlers.gitsigns').setup()
  end,
}
