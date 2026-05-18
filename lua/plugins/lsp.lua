-- ============================================================================
-- TITLE: LSP configuration
-- ABOUT: A mix between native lsp management and external plugins.
-- > lspconfig handles the configuration of the lsp in the client side.
-- > Mason comunicates with the servers. It allows me to install and manage 
-- LSP servers, DAP servers, linters and formatter easily inside NeoVim, 
-- without the need of installing them manually on my comuter.
-- > mason-lsp config acts a as link between lspconfig and mason.
-- LINKS
--  > lspconfig: https://github.com/neovim/nvim-lspconfig
--  > mason: https://github.com/mason-org/mason.nvim
--  > mason-lspconfig: https://github.com/mason-org/mason-lspconfig.nvim
-- ============================================================================



return {
    -- NOTE: Recommended setup from mason-lspconfig
    "mason-org/mason-lspconfig.nvim",
    -- event = {"BufReadPre", "BufNewFile"}, -- lsp load only when on a buffer
    dependencies = {
        "neovim/nvim-lspconfig",
        {"mason-org/mason.nvim", opts = {}},
    },
    opts = {
        -- Define auto install / enable languages (only from Mason)
        ensure_installed = {
            "lua_ls",
            "vimls",
            "pyright",
            --"r_language_server",
        },
    },
    config = function(_, opts)
        -- Cargo la tabla opts al setup de mason-lspconfig manualmente
        require("mason-lspconfig").setup(opts)
        -- Habilito R para que trabaje con el R del sistema no el de Mason
        vim.lsp.enable("r_language_server")

        -- TODO: Configure lua recommended configuration for nvim
    end,
}
