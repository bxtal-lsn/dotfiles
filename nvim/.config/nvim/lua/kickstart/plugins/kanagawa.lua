return {
  'rebelot/kanagawa.nvim',
  name = 'kanagawa',
  enabled = true,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true

    local kanagawa = require 'kanagawa'

    kanagawa.setup {
      transparent = true,
    }
    vim.cmd.colorscheme 'kanagawa'
  end,
}
