return {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    -- Optional config
    opts = {
        transparent = true, 
        commentStyle = { italic = true },
        theme = "wave",
    },
    -- Theme must be initialized with config func
    -- Passing opt params
    config = function(_, opts)
        -- Setting up theme with custom opts
        require("kanagawa").setup(opts) 
        
        -- Loading theme
        vim.cmd("colorscheme kanagawa") 
    end,
}
