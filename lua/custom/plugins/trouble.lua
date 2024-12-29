return {
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {}

      vim.keymap.set('n', '<leader>tt', function()
        require('trouble').toggle()
      end, { desc = '[T]oggle [T]rouble list' })

      vim.keymap.set('n', '[t', function()
        require('trouble').next { skip_groups = true, jump = true }
      end, { desc = 'Go to next [T]rouble mark' })

      vim.keymap.set('n', ']t', function()
        require('trouble').previous { skip_groups = true, jump = true }
      end, { desc = 'Go to previous [T]rouble mark' })
    end,
  },
}
