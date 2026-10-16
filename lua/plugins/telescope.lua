-- ============================================================================
-- TITLE: Telescope
-- ABOUT: File, text, and buffer pickers with native fzf sorting
-- LINKS:
--   > Telescope: https://github.com/nvim-telescope/telescope.nvim
--   > fzf-native: https://github.com/nvim-telescope/telescope-fzf-native.nvim
-- ============================================================================

return {
    'nvim-telescope/telescope.nvim', version = '*',
    lazy = false, -- Initialize at startup; the keys below declare its entry points.
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- Build the native sorter used by the fzf extension below.
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },

    -- Plugin-wide picker mappings; require the picker when its mapping is used.
    keys = {
        {
            "<leader>ff",
            function() require("telescope.builtin").find_files() end,
            desc = "Find files",
        },
        {
            "<leader>fn",
            function()
                require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find Neovim config files",
        },
        {
            "<leader>fg",
            function() require("telescope.builtin").live_grep() end,
            desc = "Search text in files",
        },
        {
            "<leader>fb",
            function() require("telescope.builtin").buffers() end,
            desc = "Find buffers",
        },
    },

    config = function()
        -- Initialize Telescope with its defaults before activating extensions.
        local telescope = require('telescope')
        telescope.setup({})

        -- Building fzf-native does not activate it; load it to override the sorters.
        telescope.load_extension('fzf')
    end
}
