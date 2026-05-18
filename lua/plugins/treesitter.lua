return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Install parsers and queries
    require('nvim-treesitter').install{
        'lua', 'python', "r", "vim"
    }
  end
}
