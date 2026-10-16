-- ============================================================================
-- TITLE: Markdown/Quarto rendering
-- ABOUT: Render document markup; config.markup owns the buffer-local toggle
-- URL: https://github.com/MeanderingProgrammer/render-markdown.nvim
-- ============================================================================

return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ft = { 'markdown', 'quarto' }, -- Load when opening either document filetype.
        opts = {
            file_types = { 'markdown', 'quarto' },
            -- Keep decorations on the cursor row; native conceal is configured below.
            anti_conceal = {
                enabled = false
            },
            heading = {
                backgrounds = {}, -- Disable heading background highlights.
            },
            -- Inactive customization example: code-block borders, width, and padding.
--            code = {
--                border = 'single',
--                width = "block",
--                min_width = 80,
--                style = "full",
--                left_pad = 2,
--                right_pad = 2
--            },
            win_options = {
                concealcursor = {
                    -- Keep cursor-line text concealed in Normal and command-line modes.
                    -- Insert/Visual modes can reveal it; see :help 'concealcursor'.
                    -- Reference alternative: 'nvic' also conceals it in those modes.
                    rendered = 'nc', 
                },
            },
        },
    }
}
