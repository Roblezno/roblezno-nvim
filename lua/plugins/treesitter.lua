-- URL: https://github.com/nvim-treesitter/nvim-treesitter#setup
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Install parsers and queries
    require('nvim-treesitter').install{
        'lua', 'python', "r", "bash", "vim", "markdown", "markdown_inline"
    }
  end
}
