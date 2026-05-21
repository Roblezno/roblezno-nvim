-- ============================================================================
-- TITLE: Blink-cmp
-- ABOUT: Auto completion options menu for the lsp
-- LINKS
--  > github: https://github.com/saghen/blink.cmp
-- ============================================================================
return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
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
--        ['<Tab>'] = { 'select_next', 'fallback' },
--        ['<S-Tab>'] = { 'select_prev', 'fallback' },
--        ['<S-CR>'] = { 'accept', 'fallback' },
    },

    signature = { enabled = false },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
    },

  },
}
