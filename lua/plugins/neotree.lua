-- ============================================================================
-- TITLE: Neo-tree
-- ABOUT: File explorer and its plugin-wide toggle mapping
-- URL: https://github.com/nvim-neo-tree/neo-tree.nvim
-- ============================================================================

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- TODO: Fix floating window visuals
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    -- Keep the explorer action with the plugin that provides its command.
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree", silent = true },
    },
  }
}
