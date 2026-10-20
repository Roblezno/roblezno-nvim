-- ============================================================================
-- TITLE: kanagawa
-- ABOUT: Custom theme for neovim
-- LINKS
-- > github: https://github.com/rebelot/kanagawa.nvim
-- > more themes: https://github.com/topics/neovim-colorscheme
-- ============================================================================

return {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000, -- Apply the colorscheme before other startup plugins.
    -- Active theme options; the floating-window override example below is inactive.
    opts = {
        transparent = true, 
        commentStyle = { italic = true },
        theme = "wave",
        -- Remove background of LineNr {Sign, Fold}Column and friends
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none"
                    }
                }
            }
        },

        -- Colors for Quarto chunk boundaries and their language labels.
        overrides = function(colors)
            return {
                QuartoCodeBorder = {
                    -- Keep the language label readable against its background.
                    fg = colors.theme.ui.bg,
                    -- Thin border characters take their color from this background.
                    bg = "#A0A0A0",
                },
            }
        end,

    },
    -- Lazy passes opts here; configure the palette before applying the colorscheme.
    config = function(_, opts)
        -- Setting up theme with custom opts
        require("kanagawa").setup(opts) 
        
        -- Loading theme
        vim.cmd("colorscheme kanagawa-wave") 
    end,

    


}
