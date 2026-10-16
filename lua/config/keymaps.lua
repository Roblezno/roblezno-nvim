-- ============================================================================
-- TITLE: NeoVim Keymaps
-- ABOUT: Native editor-wide mappings; plugin mappings live in their specifications
-- HELP: :help vim.lsp.buf.format(), :help vim.ui.select(), :help package-undotree
-- ============================================================================

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<Cmd>split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Clear search clutter (nohlsearch)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clears search results (nohlsearch)' })

--- Format the current source buffer with one attached LSP provider.
--- Python uses Ruff; other source buffers offer a picker if several qualify.
local function format_source_buffer()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    -- Mixed-language documents need a separate formatting policy; special
    -- buffers such as help pages and terminals are not source-editing targets.
    if vim.bo[bufnr].buftype ~= "" or filetype == "markdown" or filetype == "quarto" then
        vim.notify("Formatting is available only for ordinary source buffers.", vim.log.levels.INFO)
        return
    end

    -- Check live capabilities on use, since servers may attach after setup.
    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        method = "textDocument/formatting",
        name = filetype == "python" and "ruff" or nil,
    })
    if #clients == 0 then
        local message = filetype == "python"
            and "No Ruff formatter is attached to this Python buffer."
            or "No LSP formatter is attached to this buffer."
        vim.notify(message, vim.log.levels.INFO)
        return
    end

    --- Format the captured buffer synchronously with the selected client.
    ---@param client vim.lsp.Client? nil when the provider picker is cancelled.
    local function format_with(client)
        if client and vim.api.nvim_buf_is_valid(bufnr) then
            vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
        end
    end

    if #clients == 1 then
        format_with(clients[1])
    else
        -- Include the client ID to distinguish multiple instances of one server.
        vim.ui.select(clients, {
            prompt = "Choose LSP formatter:",
            format_item = function(client)
                return client.name .. " (" .. client.id .. ")"
            end,
        }, format_with)
    end
end

-- Formatting is an explicit Normal-mode action on the whole source buffer.
vim.keymap.set("n", "<leader>cf", format_source_buffer, { desc = "Format source buffer (LSP)" })

-- Neovim 0.12 bundles this optional package; load it before toggling its viewer.
vim.keymap.set("n", "<leader>u", function()
    vim.cmd("packadd nvim.undotree")
    vim.cmd("Undotree")
end, { desc = "Toggle undo tree" })
