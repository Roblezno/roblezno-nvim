-- ============================================================================
-- TITLE: Telescope
-- ABOUT: File, text, and buffer pickers with native fzf sorting
-- LINKS:
--   > Telescope: https://github.com/nvim-telescope/telescope.nvim
--   > fzf-native: https://github.com/nvim-telescope/telescope-fzf-native.nvim
-- ============================================================================

return {
    'nvim-telescope/telescope.nvim', version = '*',
    -- Lazy loads Telescope before running a declared picker key or this command.
    cmd = 'Telescope',
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
        -- These discovery pickers share the same on-demand loading boundary.
        {
            "<leader>fr",
            function() require("telescope.builtin").oldfiles() end,
            desc = "Find recent files",
        },
        {
            "<leader>fw",
            function() require("telescope.builtin").grep_string() end,
            desc = "Search word under cursor",
        },
        {
            "<leader>fh",
            function() require("telescope.builtin").help_tags() end,
            desc = "Find help tags",
        },
        {
            "<leader>fk",
            function() require("telescope.builtin").keymaps() end,
            desc = "Find keymaps",
        },
    },

    config = function()
        -- Run setup on first load, before the requested picker or command executes.
        local telescope = require('telescope')
        telescope.setup({})

        -- Building fzf-native does not activate it; load it to override the sorters.
        telescope.load_extension('fzf')
    end
}
