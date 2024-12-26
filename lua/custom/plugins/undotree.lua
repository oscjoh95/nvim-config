return {
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle', -- Load only when this command is used
    config = function()
      -- vim.g.undotree_SetFocusWhenToggle = 1 -- Automatically focus on the window
      -- vim.g.undotree_SplitWidth = 35 -- Set the split width
      vim.keymap.set('n', '<leader>u', vim.cmd.UndoTreeToggle)
    end,
  },
}
