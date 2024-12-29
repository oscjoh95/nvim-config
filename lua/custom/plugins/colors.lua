function ColorMyPencils(color)
  color = color or 'tokyonight-night'
  vim.cmd.colorscheme(color)
end

local my_default_color_scheme = 'gruvbox'

return {
  -- Tokyonight color scheme
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- Ensure this loads before other plugins
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
        overrides = {},
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
    init = function()
      -- Load the Rose-pine color scheme with the 'main' variant
      if string.find(my_default_color_scheme, 'rose-pine') then
        ColorMyPencils(my_default_color_scheme)
      end
    end,
  },
}
