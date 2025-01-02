return {
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup {
      enabled = true,
      auto_save = true, -- Enables/disables auto saving session on exit
      auto_restore = true, -- Enables/disables auto restoring session on start
      auto_create = false,
      cwd_change_handling = true,
      -- auto_restore_last_session = true,
      show_auto_restore_notif = true, -- Whether to show a notification when auto-restoring
      auto_session_suppress_dirs = { 'C:\\', '~\\Downloads*', '~\\Documents\\*' },
      -- allowed_dirs = { 'C:\\gitRepos\\*' },
      session_lens = {
        buftypes_to_ignore = {},
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
        mappings = {
          -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
          delete_session = { 'i', '<C-D>' },
          alternate_session = { 'i', '<C-S>' },
          copy_session = { 'i', '<C-Y>' },
        },
      },

      -- Save quickfix list and open it when restoring the session
      save_extra_cmds = {
        function()
          local qflist = vim.fn.getqflist()
          -- return nil to clear any old qflist
          if #qflist == 0 then
            return nil
          end
          local qfinfo = vim.fn.getqflist { title = 1 }

          for _, entry in ipairs(qflist) do
            -- use filename instead of bufnr so it can be reloaded
            entry.filename = vim.api.nvim_buf_get_name(entry.bufnr)
            entry.bufnr = nil
          end

          local setqflist = 'call setqflist(' .. vim.fn.string(qflist) .. ')'
          local setqfinfo = 'call setqflist([], "a", ' .. vim.fn.string(qfinfo) .. ')'
          return { setqflist, setqfinfo, 'copen' }
        end,
      },
    }

    -- Function to save the session if it exists
    local function save_session()
      -- local session = require('auto-session.lib').get_session_name()
      local session = require('auto-session.lib').current_session_name()
      if session and #session > 0 then
        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype

        -- Skip saving for certain buffer types (e.g terminal or quickfix buffers) or filetypes
        if buftype == '' and not vim.tbl_contains({ 'TelescopePrompt', 'fugitive' }, filetype) then
          require('auto-session').SaveSession(session, false)
        end
      end
    end

    local session_group = vim.api.nvim_create_augroup('SessionManagement', {})
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost', 'BufWritePost', 'BufDelete' }, {
      pattern = '*',
      group = session_group,
      callback = function()
        save_session()
      end,
      desc = 'Automatically save the session on buffer events, skipping certain types',
    })

    -- vim.keymap.set('n', '<Leader>ls', require('auto-session.session-lens').search_session, {
    --   noremap = true,
    -- })
    vim.keymap.set('n', '<leader>se', '<cmd>SessionSearch<CR>', { desc = 'Session search', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>as', '<cmd>SessionSave<CR>', { desc = 'Save session', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>ar', '<cmd>SessionRestore<CR>', { desc = 'Restore session', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>ad', '<cmd>SessionDelete<CR>', { desc = 'Delete session', noremap = true, silent = true })
  end,
}
