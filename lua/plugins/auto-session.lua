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
    -- suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    -- log_level = 'debug',
  },
}
