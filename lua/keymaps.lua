-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>dl', function()
  vim.diagnostic.open_float { scope = 'line' }
end, { desc = 'Show diagnostics for the current line' })

vim.keymap.set('n', '<leader><C-n>', '<cmd>cnext<CR>zz', { desc = 'Next item in quickfixlist' })
vim.keymap.set('n', '<leader><C-p>', '<cmd>cprev<CR>zz', { desc = 'Previous item in quickfixlist' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Move marked lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move marked lines down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move marked lines up' })

-- Mappping indent and outdent
vim.keymap.set('n', '<tab>', '>>', { desc = 'Indent line' })
vim.keymap.set('n', '<S-tab>', '<<', { desc = 'Deindent line' })
vim.keymap.set('x', '<tab>', '>', { desc = 'Indent line' })
vim.keymap.set('x', '<S-tab>', '<', { desc = 'Deindent line' })

-- Center on jumping
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Center on jumping down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Center on jumping up' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Center on searching' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Center on searching' })

-- Combine lines, but keep cursor position
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Combine lines, but keep cursor position' })

-- In visual mode search for marked text
vim.keymap.set('x', '*', '"zy/<C-R>z<CR>', { desc = 'Search for marked text in visual mode' })

-- Start changing word under cursor
vim.keymap.set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Start chaning word under cursor' })

-- In visual mode, replace text and keep in register
vim.keymap.set('x', '<leader>P', '"_dP', { desc = 'Replace text and keep in register' })

-- Copy to clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Copy to EOL to system clipboard' })
-- nmap <leader>Y \"+Y

-- Paste from clipbord
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set('v', '<leader>p', '"_d"+P', { desc = 'Paste from system clipboard and keep register' })

-- In visual mode, delete and move to clipboard
vim.keymap.set('x', '<leader>D', '"+d', { desc = 'Delete and move to clipboard' })

-- In visual mode, delete and move to unnamed register
vim.keymap.set('x', '<leader>d', '"_d', { desc = 'Delete to unnamed register' })

-- In normal mode, delete and move to unnamed register
-- vim.keymap.set('n', '<leader>dd', '"_dd', { desc = 'Delete to unnamed register' })
vim.keymap.set('n', '<leader>d', '"_d', { desc = 'Delete to unnamed register' })

--Map to yank entire file into clipboard
vim.keymap.set('n', '<leader>ac', '<cmd>%y+<CR>', { desc = 'Yank entire file to system clipboard' })

-- Apply macro over visual range
vim.keymap.set('x', '@', function()
  return ':norm @ ' .. vim.fn.getcharstr() .. '<CR>'
end, { expr = true })

-- vim: ts=2 sts=2 sw=2 et
