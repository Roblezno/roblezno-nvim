-- ============================================================================
-- TITLE: LSP configuration
-- ABOUT: Native LSP clients with shared server definitions and tool installation
-- > Neovim's native LSP client starts and communicates with language servers.
-- > nvim-lspconfig provides server definitions; overrides are configured below.
-- > Mason installs external tools and adds their executables to Neovim's PATH.
-- > mason-lspconfig installs listed servers and enables Mason-managed servers.
-- LINKS
--  > lspconfig: https://github.com/neovim/nvim-lspconfig
--  > mason: https://github.com/mason-org/mason.nvim
--  > mason-lspconfig: https://github.com/mason-org/mason-lspconfig.nvim
--  > R language server: https://github.com/REditorSupport/languageserver
--  > Ruff: https://docs.astral.sh/ruff/editors/
-- ============================================================================


return {
    -- Dependencies initialize Mason and provide native server definitions.
    "mason-org/mason-lspconfig.nvim",
    -- Inactive loading alternative; this specification currently starts eagerly.
    -- event = {"BufReadPre", "BufNewFile"}, -- defer setup until opening a buffer
    dependencies = {
        "neovim/nvim-lspconfig",
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    border = "single"
                }
            }
        },
    },
    opts = {
        -- Install these servers through Mason; automatic enabling uses its default.
        ensure_installed = {
            "lua_ls",
            "vimls",
            "pyright",
            "ruff",
            "bashls",
            "nextflow_ls",
            -- Inactive alternative: R is currently managed outside Mason.
            --"r_language_server",
        },
    },
    config = function(_, opts)
        -- Pyright owns Python analysis; Ruff supplies linting, actions, and formatting.
        vim.lsp.config("pyright", {
            settings = {
                pyright = {
                    disableOrganizeImports = true,
                },
            },
        })

        vim.lsp.config("ruff", {
            on_attach = function(client)
                -- Pyright provides more complete hover information.
                client.server_capabilities.hoverProvider = false
            end,
        })

        -- Use vim-language-nextflow syntax instead of LSP semantic highlighting.
        vim.lsp.config("nextflow_ls", {
            on_attach = function (client)
                client.server_capabilities.semanticTokensProvider = nil
            end,
        })

        -- Apply the installation list and enable Mason-managed server definitions.
        require("mason-lspconfig").setup(opts)
        -- Enable externally managed R; nvim-lspconfig resolves R from Neovim's PATH.
        -- That R installation must be able to load its languageserver package.
        vim.lsp.enable("r_language_server")
    end,
}
