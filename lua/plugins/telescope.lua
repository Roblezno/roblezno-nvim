-- ============================================================================
-- TITLE: Telescope
-- ABOUT: File, text, and buffer pickers with native fzf sorting
-- LINKS:
--   > Telescope: https://github.com/nvim-telescope/telescope.nvim
--   > fzf-native: https://github.com/nvim-telescope/telescope-fzf-native.nvim
-- ============================================================================

return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- Build the native sorter used by the fzf extension below.
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },

    config = function()
        -- Initialize Telescope with its defaults before activating extensions.
        local telescope = require('telescope')
        telescope.setup({})

        -- Building fzf-native does not activate it; load it to override the sorters.
        telescope.load_extension('fzf')

        -- Fzf files in the current directory (and subdirectories)
        vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
        -- Edit nvim config no mather where I am
        vim.keymap.set("n", "<leader>fn", function()
            require('telescope.builtin').find_files{
                cwd = vim.fn.stdpath("config")
            }
        end)
        -- Live grep inside files (from the current directory and subdir)
        vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)

        -- Fzf buffers
        vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
    end
}
