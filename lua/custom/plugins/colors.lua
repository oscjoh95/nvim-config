-- === Configurable variables ===
local my_default_color_scheme = 'gruvbox'
local toggle_transparant_background = true -- Use this to change transparent_background
local transparent_background = false -- Must be false in order for everything to be loaded correctly
local local_sidebar = 'dark'
local local_floats = 'dark'

-- Store fallback highlights for Normal and NormalFloat
local stored = { Normal = nil, NormalFloat = nil, NormalNC = nil, Sidebars = {} }

-- Sidebar / floating highlight groups commonly used by plugins
local sidebar_groups = {
  'WinSeparator',
  'SignColumn',
  'DiagnosticSignError',
  'DiagnosticSignWarn',
  'DiagnosticSignInfo',
  'DiagnosticSignHint',
  'DiagnosticSignOk',
  'TelescopeNormal',
  'TelescopeBorder',
  'TelescopePromptBorder',
  'TelescopePromptTitle',
  'LineNr',
}

-- === Utility Functions ===
local function hex(n)
  return n and string.format('#%06x', n) or nil
end

local function capture_defaults()
  local function cap(name)
    local h = vim.api.nvim_get_hl(0, { name = name, link = false })
    return { fg = h.fg and hex(h.fg) or nil, bg = h.bg and hex(h.bg) or nil }
  end
  stored.Normal = cap 'Normal'
  stored.NormalFloat = cap 'NormalFloat'
  stored.NormalNC = cap 'NormalNC'

  stored.Sidebars = {}
  for _, grp in ipairs(sidebar_groups) do
    if vim.fn.hlexists(grp) == 1 then
      stored.Sidebars[grp] = cap(grp)
    end
  end
end

local function apply_transparency_override()
  if transparent_background then
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })

    -- Sidebars/floats
    for grp, val in pairs(stored.Sidebars) do
      vim.api.nvim_set_hl(0, grp, { fg = val.fg, bg = 'none' })
    end
  else
    if stored.Normal then
      vim.api.nvim_set_hl(0, 'Normal', stored.Normal)
    end
    if stored.NormalFloat then
      vim.api.nvim_set_hl(0, 'NormalFloat', stored.NormalFloat)
    end
    if stored.NormalNC then
      vim.api.nvim_set_hl(0, 'NormalNC', stored.NormalNC)
    end
    for grp, val in pairs(stored.Sidebars) do
      vim.api.nvim_set_hl(0, grp, val)
    end
  end
end

------
-- User functions
local function ChangeTransparency()
  transparent_background = not transparent_background
  -- local_sidebar = transparent_background and 'transparent' or 'dark'
  -- local_floats = transparent_background and 'transparent' or 'dark'

  apply_transparency_override()
end

function ColorMyPencils(color)
  color = color or my_default_color_scheme
  vim.cmd.colorscheme(color)
  capture_defaults()
  apply_transparency_override()
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.schedule(function()
      transparent_background = false
      vim.cmd 'lua ColorMyPencils("tokyonight")'
      transparent_background = toggle_transparant_background
      if transparent_background then
        apply_transparency_override()
      end
    end)
  end,
})

-- Autocmd: handle manual colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    capture_defaults()
    apply_transparency_override()
  end,
})

-- Initial apply
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy', -- Lazy.nvim fires this after loading everything
  callback = function()
    capture_defaults()
    transparent_background = toggle_transparant_background
    apply_transparency_override()
  end,
})

-- Create command
vim.api.nvim_create_user_command('ChangeTransparency', function()
  ChangeTransparency()
end, { desc = 'Change transparancy' })

return {
  -- Tokyonight color scheme
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Ensure this loads before other plugins
    opts = {
      transparent = false,
      styles = {
        sidebars = local_sidebar,
        floats = local_floats,
      },
    },
    init = function()
      -- Load the Tokyonight color scheme with the "night" style
      if string.find(my_default_color_scheme, 'tokyonight') then
        ColorMyPencils(my_default_color_scheme)
      end

      -- Optionally, configure specific highlight groups here
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    priority = 1000, -- Ensure this loads before other plugins
    config = function()
      require('gruvbox').setup {
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = false,
        bold = true,
        -- italic = {
        --   strings = false,
        --   emphasis = false,
        --   comments = true,
        --   operators = false,
        --   folds = false,
        -- },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = '', -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {
          -- ['@lsp.type.property'] = { link = '@property' }, -- This controls colors to properties (e.g. member variables)
          -- ['@lsp.type.parameter'] = { link = 'Comment' }, -- This controls colors to parameters (e.g. variables to functions)
        },
        dim_inactive = false,
        transparent_mode = false,
      }
      if string.find(my_default_color_scheme, 'gruvbox') then
        ColorMyPencils(my_default_color_scheme)
      end
    end,
  },

  -- Rose-pine color scheme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000, -- Ensure this loads after Tokyonight (if you switch to it later)
    opts = {
      transparent = false,
      styles = {
        sidebars = local_sidebar,
        floats = local_floats,
      },
    },
    init = function()
      -- Load the Rose-pine color scheme with the 'main' variant
      if string.find(my_default_color_scheme, 'rose-pine') then
        ColorMyPencils(my_default_color_scheme)
      end
    end,
  },

  --Catpuccin colorscheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      transparent = false,
      styles = {
        sidebars = local_sidebar,
        floats = local_floats,
      },
    },
    config = function()
      if string.find(my_default_color_scheme, 'catppuccin') then
        ColorMyPencils(my_default_color_scheme)
      end
    end,
  },

  -- vscode colorscheme
  {
    'Mofiqul/vscode.nvim',
    name = 'vscode',
    priority = 1000, -- Ensure this loads before other plugins
    opts = {
      transparent = false,
      italic_comments = true,
      styles = {
        sidebars = local_sidebar,
        floats = local_floats,
      },
    },
    config = function()
      if string.find(my_default_color_scheme, 'vscode') then
        ColorMyPencils(my_default_color_scheme)
      end
    end,
  },
}
