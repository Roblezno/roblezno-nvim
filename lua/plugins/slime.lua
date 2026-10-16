-- ============================================================================
-- TITLE: Slime nvim
-- ABOUT: Sends source code and Quarto/Markdown chunks to a tmux terminal
-- LINKS:
--      > github: https://github.com/jpalardy/vim-slime
-- ============================================================================
return {
    {
      "jpalardy/vim-slime",
      lazy = false, -- Quarto can call Slime directly, before any Slime mapping is used.
      -- General sending actions are available in source and document buffers.
      keys = {
        { "<leader>rs", "<Plug>SlimeConfig", desc = "Select Slime target terminal" },
        { "<leader>rv", "<Plug>SlimeRegionSend", mode = "x", desc = "Run visual selection in terminal", silent = true },
        { "<leader>rl", "<cmd>SlimeSend<CR>", desc = "Run current line in terminal", silent = true },
      },
      init = function()
        -- We need to specify the target terminal, in this case tmux terms
        vim.g.slime_target = "tmux"

        -- Disabling mappings (want to use custom ones)
        vim.g.slime_no_mappings = true
        
        -- (Opcional) won't ask for term to run code if there's only 1
        -- for nvim terms we use jobid
        --vim.g.slime_default_config = { jobid = 1 }
        
        -- For tmux terms we use socket_name and target_pane
        vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
      end,

    }
}
