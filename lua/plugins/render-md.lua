return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ft = { 'markdown', 'quarto' }, -- Cargar solo en estos archivos
        opts = {
            file_types = { 'markdown', 'quarto' },
            -- Prevents line from de-rendering in markdown files while in "visual mode"
            anti_conceal = {
                enabled = false
            },
            heading = {
                backgrounds = {}, -- Disables heading background
            },
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
                    -- 'n' = Normal, 'v' = Visual, 'i' = Insert, 'c' = Command
                    -- Usar 'nc' mantiene la línea renderizada al navegar (Normal), pero 
                    -- te muestra el markdown crudo si entras a editar (Insert).
                    -- Si quieres que esté renderizado SIEMPRE (incluso al editar), usa 'nvic'.
                    rendered = 'nc', 
                },
            },
        },
        keys = {
            {
                "<leader>mt", -- Cambia esto por el atajo que prefieras (ej. Toggle Markdown)
                "<cmd>RenderMarkdown toggle<CR>",
                desc = "Alternar vista renderizada de Markdown/Quarto",
            },
        },
    }
}
