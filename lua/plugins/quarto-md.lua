-- ============================================================================
-- TITLE: Quarto integration
-- ABOUT: Code-chunk language support and Slime execution
-- LINKS:
--   > Quarto: https://github.com/quarto-dev/quarto-nvim
--   > Otter: https://github.com/jmbuhr/otter.nvim
-- ============================================================================
-- Buffer-local document mappings are owned by config.markup and after/ftplugin.
-- Quarto activates Otter through its ftplugin; Markdown uses :QuartoActivate.
-- config.quarto registers document guards and language discovery before plugin setup.

return {
    {
      "quarto-dev/quarto-nvim",
      -- Neovim 0.12 detects .qmd natively. Lazy configures Quarto before replaying
      -- FileType, so its ftplugin activates Otter with the configured languages.
      ft = "quarto",
      -- Expose the pinned plugin's commands before loading, including explicit
      -- Markdown activation. Commands are defined in plugin/quarto.lua and setup().
      cmd = {
        "QuartoPreview",
        "QuartoPreviewNoWatch",
        "QuartoUpdatePreview",
        "QuartoClosePreview",
        "QuartoActivate",
        "QuartoHelp",
        "QuartoSend",
        "QuartoSendAbove",
        "QuartoSendBelow",
        "QuartoSendAll",
        "QuartoSendRange",
        "QuartoSendLine",
      },
      dependencies = {
        "jmbuhr/otter.nvim",
       -- "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter", -- Its own specification keeps it eagerly loaded.
      },
      config = function()
        local quarto = require("quarto")
        quarto.setup({
          lspFeatures = {
            languages = { "r", "python", "bash" },
            chunks = "all", -- lsp enabled for all code blocks
            diagnostics = {
              enabled = true,
              triggers = { "BufWritePost" },
            },
            completion = {
              enabled = true,
            },
          },
          codeRunner = {
            enabled = true,
            default_method = "slime",
            ft_runners = {},
            -- never_run = {"yaml"}
          },
        })

      end
    }
}
