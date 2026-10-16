-- ============================================================================
-- TITLE: Blink-cmp
-- ABOUT: LSP, path, snippet, and buffer completion with document prose gating
-- LINKS
--  > github: https://github.com/saghen/blink.cmp
-- ============================================================================
return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = "1.*",
  opts = {
    -- In document buffers, allow completion only inside fenced code bodies.
    enabled = function()
      return not require("config.prose").is_prose()
    end,

    -- Reference: available presets and their shared controls.
    -- 'default' (selected below) uses built-in-style completion keys (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap

    -- NOTE: Check https://cmp.saghen.dev/configuration/keymap.html for more info
    keymap = { 
        preset = 'default',
        -- Inactive customization examples; the active preset supplies the mappings.
--        ['<Tab>'] = { 'select_next', 'fallback' },
--        ['<S-Tab>'] = { 'select_prev', 'fallback' },
--        ['<S-CR>'] = { 'accept', 'fallback' },
    },

    signature = { enabled = false }, -- Noice owns LSP signature popups.

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
    },

   -- Command line config opts
   cmdline = {
       enabled = true,
       keymap = {
           preset = "cmdline", -- Sets the default bindings for cmd line
       },
       completion = {
           menu = {
               auto_show = true, -- Automatically displays the menu
           }
       }
   },

  },
}
