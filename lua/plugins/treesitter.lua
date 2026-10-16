-- ============================================================================
-- TITLE: Treesitter parsers
-- ABOUT: Install parsers and queries; config.autocmds enables highlighting
-- URL: https://github.com/nvim-treesitter/nvim-treesitter#setup
-- ============================================================================

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false, -- The main-branch plugin requires eager loading.
  build = ':TSUpdate',
  config = function()
    -- Install parsers and queries asynchronously; feature activation is separate.
    require('nvim-treesitter').install{
        'lua', 'python', "r", "bash", "vim", "markdown", "markdown_inline"
    }
  end
}
