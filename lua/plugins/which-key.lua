-- ============================================================================
-- TITLE: which-key
-- ABOUT: WhichKey helps remember NeoVim keymaps
-- LINKS:
--  > github: https://github.com/folke/which-key.nvim
-- ============================================================================


return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Label existing prefixes; the actions stay in their native/plugin owners.
    -- Run includes Visual mode because Slime can send the current selection.
    spec = {
      { "<leader>f", group = "Find" },
      { "<leader>b", group = "Buffers" },
      { "<leader>s", group = "Splits" },
      { "<leader>m", group = "Markdown/Quarto" },
      { "<leader>r", group = "Run", mode = { "n", "x" } },
      { "<leader>t", group = "Trouble" },
      { "<leader>w", group = "Sessions" },
      { "<leader>c", group = "Code" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
