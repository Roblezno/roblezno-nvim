-- ============================================================================
-- TITLE: Markdown/Quarto rendering
-- ABOUT: Render document markup with language-colored Quarto chunk boundaries
-- LINKS:
--   > https://github.com/MeanderingProgrammer/render-markdown.nvim
--   > https://github.com/MeanderingProgrammer/render-markdown.nvim/blob/main/doc/custom-handlers.md
-- ============================================================================

return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        ft = { 'markdown', 'quarto' },

        opts = function()
            local devicons = require('nvim-web-devicons')

            -- Blend language colors toward white: 0 keeps the original color,
            -- while 1 produces white. Start with a modest 25% adjustment.
            local brighten_amount = 0.25
            local chunk_query

            --- Lighten an RGB color while retaining its original hue.
            ---@param rgb integer
            ---@return string
            local function brighten(rgb)
                local function channel(shift)
                    local value = math.floor(rgb / 2 ^ shift) % 256
                    return math.floor(
                        value + (255 - value) * brighten_amount + 0.5
                    )
                end

                return string.format(
                    '#%02X%02X%02X',
                    channel(16),
                    channel(8),
                    channel(0)
                )
            end

            --- Build line and label highlights from a language's icon color.
            --- The existing theme highlight supplies dark label text and the
            --- gray fallback used when a language has no recognized icon.
            local function language_style(language, fallback)
                local filetype = vim.filetype.match({
                    filename = 'chunk.' .. language,
                }) or language

                local icon, icon_hl = devicons.get_icon_by_filetype(
                    filetype,
                    { default = false }
                )

                local original_color = icon_hl and vim.api.nvim_get_hl(
                    0,
                    { name = icon_hl, link = false }
                ).fg

                local color = original_color
                    and brighten(original_color)
                    or fallback.bg

                local suffix = (
                    filetype ~= '' and filetype or 'unknown'
                ):gsub('[^%w_]', '_')

                local line_hl = 'QuartoChunkLine_' .. suffix
                local label_hl = 'QuartoChunkLabel_' .. suffix

                -- Lines use colored text over the transparent editor background.
                vim.api.nvim_set_hl(0, line_hl, {
                    fg = color,
                    bg = 'NONE',
                })

                -- Language labels use the same color as a filled background.
                vim.api.nvim_set_hl(0, label_hl, {
                    fg = fallback.fg,
                    bg = color,
                })

                return {
                    icon = icon,
                    icon_hl = icon_hl,
                    line = line_hl,
                    label = label_hl,
                }
            end

            --- Describe an overlay on a fence line.
            --- render-markdown manages creating, updating, and clearing it.
            local function fence_mark(node, text)
                local row, col = node:range()

                return {
                    conceal = true,
                    start_row = row,
                    start_col = col,
                    opts = {
                        virt_text = text,
                        virt_text_pos = 'overlay',
                        hl_mode = 'replace',
                        priority = 200,
                    },
                }
            end

            --- Draw language-colored boundaries for fenced Quarto chunks.
            ---@param ctx render.md.handler.Context
            ---@return render.md.Mark[]
            local function render_quarto_chunks(ctx)
                if vim.bo[ctx.buf].filetype ~= 'quarto' then
                    return {}
                end

                -- Parse once, when a Markdown syntax tree is first available.
                chunk_query = chunk_query or vim.treesitter.query.parse(
                    'markdown',
                    '(fenced_code_block) @chunk'
                )

                local marks = {}
                local fallback = vim.api.nvim_get_hl(
                    0,
                    { name = 'QuartoCodeBorder', link = false }
                )

                -- Overlay text is clipped at the window edge. Using the editor
                -- width also provides enough characters for narrower splits.
                local rule = string.rep('─', vim.o.columns)

                for _, block in chunk_query:iter_captures(ctx.root, ctx.buf) do
                    local fences = {}
                    local info = ''

                    -- Read the actual delimiters rather than assuming that
                    -- the final line is a closing fence in unfinished chunks.
                    for child in block:iter_children() do
                        if child:type() == 'fenced_code_block_delimiter' then
                            fences[#fences + 1] = child
                        elseif child:type() == 'info_string' then
                            info = vim.trim(
                                vim.treesitter.get_node_text(child, ctx.buf)
                            )
                        end
                    end

                    -- Recognize both plain fences and Quarto's {python}/{r}
                    -- notation, while retaining the full annotation in the label.
                    local language = info:match(
                        '^%s*{?%s*([%w_+%.%-]+)'
                    ) or ''

                    local style = language_style(language:lower(), fallback)

                    if fences[1] then
                        local text = { { rule, style.line } }

                        if info ~= '' then
                            local icon = style.icon
                                and (style.icon .. ' ')
                                or ''

                            text = {
                                { '─ ', style.line },
                                { ' ' .. icon .. info .. ' ', style.label },
                                { ' ' .. rule, style.line },
                            }
                        end

                        local header = fence_mark(fences[1], text)

                        -- Retain the language icon in the sign column.
                        if style.icon then
                            header.opts.sign_text = style.icon
                            header.opts.sign_hl_group = style.icon_hl
                        end

                        marks[#marks + 1] = header
                    end

                    if fences[2] then
                        marks[#marks + 1] = fence_mark(
                            fences[2],
                            { { rule, style.line } }
                        )
                    end
                end

                return marks
            end

            return {
                file_types = { 'markdown', 'quarto' },

                -- Keep decorations visible on the cursor row.
                anti_conceal = {
                    enabled = false,
                },

                heading = {
                    backgrounds = {},
                },

                overrides = {
                    filetype = {
                        quarto = {
                            code = {
                                -- Keep chunk bodies transparent. The custom
                                -- handler below draws their labels and borders.
                                disable_background = true,
                                conceal_delimiters = true,
                                language = false,
                                border = 'none',
                            },
                        },
                    },
                },

                custom_handlers = {
                    markdown = {
                        -- Extend the built-in Markdown renderer.
                        extends = true,
                        parse = render_quarto_chunks,
                    },
                },

                win_options = {
                    concealcursor = {
                        -- Conceal cursor-line markup in Normal/command modes;
                        -- Insert/Visual modes can reveal the source.
                        rendered = 'nc',
                    },
                },
            }
        end,
    },
}
