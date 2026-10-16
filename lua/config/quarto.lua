-- ============================================================================
-- TITLE: Markdown/Quarto coordination
-- ABOUT: Document guards, Otter language discovery, and LSP popup policy
-- LINKS:
--   > Quarto: https://github.com/quarto-dev/quarto-nvim
--   > Otter: https://github.com/jmbuhr/otter.nvim
--   > Noice: https://github.com/folke/noice.nvim
-- ============================================================================

local M = {}
local prose = require("config.prose")

-- Keep native document guards eager: config.autocmds calls setup() before Lazy
-- installs Quarto's filetype/command triggers. Registration only needs native
-- APIs; Quarto/Otter are resolved inside callbacks after configuration is available.
-- Otter-specific assumptions stay here: the host bridge is named otter-ls[buf],
-- forwarded diagnostics use otter-lang-* namespaces, and keeper.rafts[buf]
-- tracks language buffers and their diagnostic namespaces. Review these details
-- against the pinned upstream implementation when upgrading Otter.

--- Enable the Markdown highlighter and parser-aware prose spelling.
---@param args table FileType event; args.buf is the document buffer.
local function configure_prose(args)
    local highlighted = pcall(vim.treesitter.start, args.buf, "markdown")
    local inline_ok, inline_loaded = pcall(vim.treesitter.language.add, "markdown_inline")
    vim.opt_local.spelllang = { "en", "es" }
    -- Both syntax trees are needed to exclude code blocks and inline code.
    -- after/queries/markdown/highlights.scm supplies the prose spelling captures.
    vim.opt_local.spell = highlighted and inline_ok and inline_loaded == true
end

--- Keep only Otter's host-buffer bridge attached to markup documents.
---@param args table LspAttach event with args.buf and args.data.client_id.
local function restrict_lsp_attachment(args)
    if not prose.is_markup(args.buf) then
        return
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name ~= "otter-ls[" .. args.buf .. "]" then
        -- Wait for attachment to finish before detaching whole-document servers.
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) and prose.is_markup(args.buf) then
                vim.lsp.buf_detach_client(args.buf, client.id)
            end
        end)
    end
end

--- Filter forwarded diagnostics to fenced code bodies in the host document.
---@param args table DiagnosticChanged event with its buffer and diagnostic list.
local function filter_diagnostics(args)
    if not prose.is_markup(args.buf) then
        return
    end
    local diagnostics = args.data.diagnostics
    local namespace = diagnostics[1] and diagnostics[1].namespace
    if not namespace then
        return
    end
    if not vim.startswith(vim.diagnostic.get_namespace(namespace).name, "otter-lang-") then
        -- Detached whole-document clients can still publish queued diagnostics.
        vim.diagnostic.reset(namespace, args.buf)
        return
    end

    -- Missing Markdown trees produce no code ranges, so assistance stays quiet.
    local chunks = prose.code_chunks(args.buf)
    local filtered = {}
    local changed = false
    -- Read copies: Otter shares the incoming diagnostic objects with its buffers.
    for _, diagnostic in ipairs(vim.diagnostic.get(args.buf, { namespace = namespace })) do
        local code_chunk
        for _, chunk in ipairs(chunks) do
            if diagnostic.lnum >= chunk.start_row and diagnostic.lnum < chunk.end_row then
                code_chunk = chunk
                break
            end
        end
        if code_chunk then
            if diagnostic.end_lnum >= code_chunk.end_row then
                diagnostic.end_lnum = code_chunk.end_row - 1
                local line = vim.api.nvim_buf_get_lines(args.buf, diagnostic.end_lnum, diagnostic.end_lnum + 1, false)[1]
                diagnostic.end_col = #line
                changed = true
            end
            filtered[#filtered + 1] = diagnostic
        else
            changed = true
        end
    end
    -- Only rewrite changed lists, since set() emits DiagnosticChanged again.
    if changed then
        vim.diagnostic.set(namespace, args.buf, filtered)
    end
end

--- Discover newly introduced chunk languages in an automatically managed Quarto buffer.
---@param bufnr integer Host buffer from an InsertEnter/InsertLeave/BufWritePost event.
local function refresh_chunk_languages(bufnr)
    -- A filetype/command trigger loads Quarto and supplies its configuration.
    -- Wait for that table before resolving plugin modules for language discovery.
    local config = _G.QuartoConfig
    if vim.bo[bufnr].filetype ~= "quarto" or not config or not config.lspFeatures.enabled then
        return
    end
    local quarto = require("quarto")
    local keeper = require("otter.keeper")
    local raft = keeper.rafts[bufnr]
    if not raft then
        vim.api.nvim_buf_call(bufnr, quarto.activate)
        return
    end

    -- A raft belongs to one host document. Its buffers table maps each language
    -- to an embedded buffer; diagnostics_namespaces is keyed by those buffer IDs.
    local chunks = keeper.extract_code_chunks(bufnr)
    for _, language in ipairs(config.lspFeatures.languages) do
        if chunks[language] and not raft.buffers[language] then
            -- Reactivation replaces the raft while reusing existing buffers/clients.
            vim.api.nvim_buf_call(bufnr, quarto.activate)
            -- Keep the old raft reference to clear diagnostics for omitted languages.
            for active_language, buffer in pairs(raft.buffers) do
                if not keeper.rafts[bufnr].buffers[active_language] then
                    local namespace = raft.diagnostics_namespaces[buffer]
                    if namespace then
                        vim.diagnostic.reset(namespace, bufnr)
                    end
                end
            end
            return
        end
    end
end

--- Apply the document policy to Noice hover/signature messages.
--- Extend an existing stay predicate so a popup closes when the cursor enters prose.
---@param message table Noice LSP message, optionally containing opts.stay.
---@return boolean skip Whether Noice should suppress this message.
function M.suppress_lsp_message(message)
    if not prose.is_markup() then
        return false
    end
    local stay = message.opts.stay
    if stay then
        message.opts.stay = function()
            return not prose.is_prose() and stay()
        end
    end
    return prose.is_prose()
end

--- Register document events before plugins can activate Otter or attach LSPs.
--- Named groups are cleared on setup so re-sourcing replaces these handlers.
function M.setup()
    local prose_group = vim.api.nvim_create_augroup("QuartoProse", {})
    vim.api.nvim_create_autocmd("FileType", {
        group = prose_group,
        pattern = { "markdown", "quarto" },
        callback = configure_prose,
        desc = "Enable Markdown syntax trees and English/Spanish prose spelling",
    })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = prose_group,
        callback = restrict_lsp_attachment,
        desc = "Use only Otter's code-chunk LSP bridge in markup buffers",
    })
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        group = prose_group,
        callback = filter_diagnostics,
        desc = "Keep only code-chunk diagnostics in markup buffers",
    })

    -- Ordinary Markdown uses explicit :QuartoActivate, including reactivation
    -- after adding another chunk language. Only .qmd files get automatic discovery.
    local chunk_group = vim.api.nvim_create_augroup("QuartoChunkLanguages", {})
    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "BufWritePost" }, {
        group = chunk_group,
        pattern = "*.qmd",
        callback = function(args)
            refresh_chunk_languages(args.buf)
        end,
        desc = "Activate Quarto LSP support for newly introduced chunk languages",
    })
end

return M
