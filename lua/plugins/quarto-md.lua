return {
    {
      "quarto-dev/quarto-nvim",
      dependencies = {
        "jmbuhr/otter.nvim",
       -- "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("quarto").setup({
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
        local runner = require("quarto.runner")
        vim.keymap.set("n", "<leader>mc", runner.run_cell,  { desc = "Markdown: Run current cell", silent = true })
        vim.keymap.set("n", "<leader>ma", runner.run_above, { desc = "Markdown: Run this cell and prev cells", silent = true })
        vim.keymap.set("n", "<leader>mA", runner.run_all,   { desc = "Markdown: Run all cells", silent = true })
        end
    }
}
