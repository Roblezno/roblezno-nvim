-- URLs: https://github.com/quarto-dev/quarto-nvim
--       https://github.com/jmbuhr/otter.nvim
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

        local chunk_group = vim.api.nvim_create_augroup("QuartoChunkLanguages", {})
        vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "BufWritePost" }, {
          group = chunk_group,
          pattern = "*.qmd",
          callback = function(args)
            if vim.bo[args.buf].filetype ~= "quarto" or not QuartoConfig.lspFeatures.enabled then
              return
            end
            local keeper = require("otter.keeper")
            local raft = keeper.rafts[args.buf]
            if not raft then
              vim.api.nvim_buf_call(args.buf, quarto.activate)
              return
            end

            local chunks = keeper.extract_code_chunks(args.buf)
            for _, language in ipairs(QuartoConfig.lspFeatures.languages) do
              if chunks[language] and not raft.buffers[language] then
                -- Reactivation discovers new languages and reuses existing buffers/clients.
                vim.api.nvim_buf_call(args.buf, quarto.activate)
                -- Clear forwarded diagnostics for languages omitted by the rebuilt raft.
                for active_language, buffer in pairs(raft.buffers) do
                  if not keeper.rafts[args.buf].buffers[active_language] then
                    local namespace = raft.diagnostics_namespaces[buffer]
                    if namespace then
                      vim.diagnostic.reset(namespace, args.buf)
                    end
                  end
                end
                return
              end
            end
          end,
          desc = "Activate Quarto LSP support for newly introduced chunk languages",
        })

        local runner = require("quarto.runner")
        vim.keymap.set("n", "<leader>mc", runner.run_cell,  { desc = "Markdown: Run current cell", silent = true })
        vim.keymap.set("n", "<leader>ma", runner.run_above, { desc = "Markdown: Run this cell and prev cells", silent = true })
        vim.keymap.set("n", "<leader>mA", runner.run_all,   { desc = "Markdown: Run all cells", silent = true })
        end
    }
}
