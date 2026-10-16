-- ============================================================================
-- TITLE: tmux navigation
-- ABOUT: Shared Neovim/tmux navigation with explicitly owned key mappings
-- URL: https://github.com/christoomey/vim-tmux-navigator
-- ============================================================================

return {
  "christoomey/vim-tmux-navigator",
  lazy = false, -- Register the navigation commands during startup.
  init = function()
    -- This specification owns the mappings, including the upstream defaults.
    vim.g.tmux_navigator_no_mappings = 1

    -- Disabling defaults also disables the upstream netrw workaround. Keep its
    -- Ctrl-l mapping when the workaround is enabled and no custom maps exist.
    local disable_netrw = vim.g.tmux_navigator_disable_netrw_workaround
    if disable_netrw ~= 1 and disable_netrw ~= true and vim.g.Netrw_UserMaps == nil then
      vim.g.Netrw_UserMaps = { { "<C-l>", "<C-U>TmuxNavigateRight<cr>" } }
    end
  end,
  keys = function()
    -- Preserve the four direction keys and the plugin's previous-pane shortcut.
    local keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Navigate left (Neovim/tmux)", silent = true },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Navigate down (Neovim/tmux)", silent = true },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Navigate up (Neovim/tmux)", silent = true },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate right (Neovim/tmux)", silent = true },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", desc = "Navigate to previous pane (Neovim/tmux)", silent = true },
    }

    -- Upstream also maps terminal-mode direction keys when running inside tmux.
    -- Expression mappings pass the original key through to FZF terminal buffers.
    if vim.env.TMUX and vim.env.TMUX ~= "" then
      for _, direction in ipairs({ { "h", "Left" }, { "j", "Down" }, { "k", "Up" }, { "l", "Right" } }) do
        local key = "<C-" .. direction[1] .. ">"
        local command = "TmuxNavigate" .. direction[2]
        keys[#keys + 1] = {
          key,
          function()
            if vim.bo.filetype == "fzf" then
              return key
            end
            return "<C-w>:<C-U> " .. command .. "<CR>"
          end,
          mode = "t",
          expr = true,
          silent = true,
          desc = "Navigate " .. direction[2]:lower() .. " from terminal (Neovim/tmux)",
        }
      end
    end
    return keys
  end,
}
