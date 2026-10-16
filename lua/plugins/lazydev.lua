-- ============================================================================
-- TITLE: Lazydev
-- ABOUT: Plugin that properly configures LuaLS for editing NeoVim config by
--        lazily updating workspace libraries
-- LINKS:
--       >github: https://github.com/folke/lazydev.nvim
-- ============================================================================
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Add libuv types to LuaLS when the buffer uses vim.uv.
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { -- Extend Blink with Lua-module completion for require statements and annotations.
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- Keep the general sources alongside the Lua-specific provider.
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  }
  -- Inactive migration reference for older configurations that used neodev.
  -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
}
