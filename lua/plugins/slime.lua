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
        -- Send to an existing tmux pane; the interpreter is started there separately.
        vim.g.slime_target = "tmux"

        -- Disabling mappings (want to use custom ones)
        vim.g.slime_no_mappings = true
        
        -- Inactive example for Slime's Neovim-terminal target, which uses a job ID.
        --vim.g.slime_default_config = { jobid = 1 }
        
        -- tmux uses a socket and pane token; <leader>rs can select another target.
        vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
      end,

    }
}
