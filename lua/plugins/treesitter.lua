-- ============================================================================
-- TITLE: Treesitter parsers
-- ABOUT: Install parsers/queries; config.autocmds and config.quarto start highlighters
-- URL: https://github.com/nvim-treesitter/nvim-treesitter#setup
-- ============================================================================

-- The pinned main revision requires Neovim 0.12+, a C compiler, tar, curl,
-- and tree-sitter-cli 0.26.1+ installed through a package manager rather than npm.

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
