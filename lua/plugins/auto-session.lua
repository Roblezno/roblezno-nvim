-- ============================================================================
-- TITLE: Auto-session
-- ABOUT: Project sessions with explicit restore, save, and delete actions
-- URL: https://github.com/rmagatti/auto-session
-- ============================================================================

return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
      -- Explicit commands for the current working directory
    { "<leader>wr", "<cmd>AutoSession restore<CR>", desc = "Restore cwd session" },
    { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save cwd session" },
    { "<leader>wd", "<cmd>AutoSession delete<CR>", desc = "Delete cwd session" },
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
      auto_restore = false, -- disables restoring auto session on start
    -- Inactive customization examples for excluded directories and log verbosity.
    -- suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    -- log_level = 'debug',
  },
}
