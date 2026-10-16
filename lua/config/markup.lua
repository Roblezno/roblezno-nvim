-- ============================================================================
-- TITLE: Markdown/Quarto mappings
-- ABOUT: Shared buffer-local document actions, installed by after/ftplugin
-- HELP: :help vim.keymap.set(), :help undo_ftplugin
-- ============================================================================

local M = {}

--- Insert a fenced chunk below the cursor, then enter Insert mode in its body.
---@param language string Chunk language, such as "python", "r", or "bash".
local function insert_chunk(language)
    -- Cursor rows are one-based; using that row as a line index inserts below it.
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, true, { "```{" .. language .. "}", "", "```" })
    vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
    vim.cmd("startinsert")
end

--- Install shared document mappings in the current Markdown or Quarto buffer.
--- Called by both after/ftplugin files; repeated setup is safe for the same buffer.
function M.setup()
    local filetype = vim.bo.filetype
    if (filetype ~= "markdown" and filetype ~= "quarto") or vim.b.markup_keymaps_loaded then
        return
    end

    -- Keep the three chunk templates identical apart from their language label.
    -- Resolve runner functions on use; Markdown activation remains explicit.
    local mappings = {
        { "<leader>mp", function() insert_chunk("python") end, desc = "Insert Python code chunk" },
        { "<leader>mr", function() insert_chunk("r") end, desc = "Insert R code chunk" },
        { "<leader>mb", function() insert_chunk("bash") end, desc = "Insert Bash code chunk" },
        { "<leader>mc", function() require("quarto.runner").run_cell() end, desc = "Run current cell" },
        { "<leader>ma", function() require("quarto.runner").run_above() end, desc = "Run current and previous cells (current language)" },
        { "<leader>mA", function() require("quarto.runner").run_all() end, desc = "Run all cells (current language)" },
        { "<leader>mt", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle Markdown/Quarto rendering" },
    }

    -- Extend the existing ftplugin cleanup so changing filetype removes our
    -- mappings and setup guard while retaining the native/plugin cleanup.
    local undo = { "unlet! b:markup_keymaps_loaded" }
    if vim.b.undo_ftplugin and vim.b.undo_ftplugin ~= "" then
        table.insert(undo, 1, vim.b.undo_ftplugin)
    end
    for _, mapping in ipairs(mappings) do
        vim.keymap.set("n", mapping[1], mapping[2], {
            buf = 0, -- Neovim 0.12: make the mapping local to the current buffer.
            desc = mapping.desc,
            silent = true,
        })
        undo[#undo + 1] = "silent! nunmap <buffer> " .. mapping[1]
    end
    vim.b.undo_ftplugin = table.concat(undo, " | ")
    vim.b.markup_keymaps_loaded = true
end

return M
