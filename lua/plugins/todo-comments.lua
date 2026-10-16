-- ============================================================================
-- TITLE: todo-comments
-- ABOUT: Better comments for adding notes, warnings, bugs ...
-- LINKS:
--  > github: https://github.com/folke/todo-comments.nvim
-- ============================================================================


return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
        -- Use upstream keyword, highlighting, and search defaults.
        }
    }
}

-- Reference keyword examples; these illustrate the plugin's comment markers.
-- PERF:
-- HACK:
-- TODO: 
-- NOTE:
-- FIX:
-- WARNING:
-- TEST:
