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
    priority = 1000,
    -- Optional config
    opts = {
        transparent = false, 
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


        
        -- Transparent floating windows
--        overrides = function(colors)
--            local theme = colors.theme
--            return {
--                NormalFloat = { bg = "none" },
--                FloatBorder = { bg = "none", fg = theme.ui.fg_dim }, -- Fondo transparente, borde sutil
--                FloatTitle = { bg = "none" },
--
--                -- Save an hlgroup with dark background and dimmed foreground
--                -- so that you can use it where your still want darker windows.
--                -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
--                -- NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
--
--                -- Popular plugins that open floats will link to NormalFloat by default;
--                -- set their background accordingly if you wish to keep them dark and borderless
--                -- TODO: Add borders to Lazy and Mason popup windows
--                LazyNormal = { bg = "none", fg = theme.ui.fg_dim },
--                MasonNormal = { bg = "none", fg = theme.ui.fg_dim },
--
--                -- Completion popup menu
--                Pmenu = { fg = theme.ui.shade0, bg = "none", blend = vim.o.pumblend},  -- add `blend = vim.o.pumblend` to enable transparency
--                PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
--                PmenuSbar = { bg = theme.ui.bg_m1 },
--                PmenuThumb = { bg = theme.ui.bg_p2 },
--
--            }
--        end,

    },
    -- Theme must be initialized with config func
    -- Passing opt params
    config = function(_, opts)
        -- Setting up theme with custom opts
        require("kanagawa").setup(opts) 
        
        -- Loading theme
        vim.cmd("colorscheme kanagawa-wave") 
    end,

    


}
