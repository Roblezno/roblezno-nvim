-- ============================================================================
-- TITLE: Noice Nvim
-- ABOUT: Command-line and LSP UI with document prose filtering
-- LINKS:
--      > github: https://github.com/folke/noice.nvim
-- ============================================================================
return 
{
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- Route LSP popups through the shared Markdown/Quarto prose policy.
      routes = {
          {
              filter = {
                  event = "lsp",
                  kind = { "hover", "signature" },
                  -- Keep route settings here and share the document/popup policy.
                  cond = function(message)
                      return require("config.quarto").suppress_lsp_message(message)
                  end,
              },
              opts = { skip = true },
          },
      },
      lsp = {
        -- Render native LSP Markdown through Noice's Treesitter-backed UI.
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          -- Inactive integration example for nvim-cmp; this configuration uses Blink.
          --  ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- Combine selected UI presets with the explicit hover border below.
      presets = {
          bottom_search = false, -- Disable the bottom-search preset.
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- Keep the optional inc-rename integration disabled.
          lsp_doc_border = true, -- add a border to hover docs and signature help
      },

      views = {
          hover = {
              -- border style for lsp help windows 
              border = {
                  style = "single",
                  padding = { 0, 2 }, -- Left and Right margins
              },
          },
      }
  },
  dependencies = {
    -- Lazy loads these dependencies before configuring Noice.
    "MunifTanjim/nui.nvim",
    -- Notification view backend; its own specification supplies default options.
    "rcarriga/nvim-notify",
  },

}
