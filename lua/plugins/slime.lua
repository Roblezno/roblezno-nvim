-- ============================================================================
-- TITLE: Slime nvim
-- ABOUT: Enables interaction between quarto files and terminals for running
--        code inside markdown blocks
-- LINKS:
--      > github: https://github.com/jpalardy/vim-slime
-- ============================================================================
return {
    {
      "jpalardy/vim-slime",
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
