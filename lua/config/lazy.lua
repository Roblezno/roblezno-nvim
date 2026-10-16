-- ============================================================================
-- TITLE: lazy.nvim plugin manager
-- ABOUT: Bootstrap the manager, load native settings, then import plugin specs
-- URL: https://github.com/folke/lazy.nvim
-- ============================================================================

-- Bootstrap the manager itself before loading any plugin specifications.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", 
                             "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leaders and document guards must exist before plugins register their actions.
require("config.globals")
require("config.autocmds")
require("config.options")
require("config.keymaps")


require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    -- Plugin specifications can override this default version policy.
    -- Branch revisions are recorded in lazy-lock.json for later restoration.
    version = false, -- Follow the plugin's branch when selecting updates.
    -- Inactive alternative: select releases for plugins that maintain tags.
    -- version = "*", 
  },
  install = { colorscheme = { "kanagawa", } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- Checking reports available revisions; applying updates is a separate action.
  performance = {
    rtp = {
      -- Keep Neovim's standard runtime plugins available.
      disabled_plugins = {},
    },
  },

  ui = {
      border = "single",
  }
})
