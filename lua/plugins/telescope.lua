return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },

    config = function()
        -- Fzf files in the current directory (and subdirectories)
        vim.keymap.set("n", "<space>ff", require("telescope.builtin").find_files)
        -- Edit nvim config no mather where I am
        vim.keymap.set("n", "<space>en", function()
            require('telescope.builtin').find_files{
                cwd = vim.fn.stdpath("config")
            }
        end)
        -- Live grep inside files (from the current directory and subdir)
        vim.keymap.set("n", "<space>fg", require("telescope.builtin").live_grep)

        -- Fzf buffers
        vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
    end
}
