return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():add()
      end, { desc = '[H]arpoon [A]dd to list' })

      vim.keymap.set('n', '<leader><C-h>', function()
        harpoon:list():select(1)
      end, { desc = 'Select first file in harpoon list' })
      vim.keymap.set('n', '<leader><C-j>', function()
        harpoon:list():select(2)
      end, { desc = 'Select second file in harpoon list' })
      vim.keymap.set('n', '<leader><C-k>', function()
        harpoon:list():select(3)
      end, { desc = 'Select third file in harpoon list' })
      vim.keymap.set('n', '<leader><C-l>', function()
        harpoon:list():select(4)
      end, { desc = 'Select fourth file in harpoon list' })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end, { desc = 'Toggle [P]revious buffer in Harpoon list' })
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end, { desc = 'Toggle [N]ext buffer in Harpoon list' })
      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },
}
