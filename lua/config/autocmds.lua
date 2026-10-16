-- ================================================================================================
-- TITLE : auto-commands
-- ABOUT : automatically run code on defined events (e.g. save, yank)
-- ================================================================================================

-- Keep desc beside callback so Neovim can display each autocmd's purpose.
-- HELP: :help nvim_create_autocmd()

-- Restore last cursor position when reopening a file
-- NOTE: First I create the group the autocmd will be part of
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
-- Now I can define the autocmd
vim.api.nvim_create_autocmd("BufReadPost", {
	group = last_cursor_group, -- Assign created group to this autocmd
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"') -- Last saved cursor position
		local lcount = vim.api.nvim_buf_line_count(0) -- Number of lines in the buffer
		-- Restore only when the saved line still exists in the buffer.
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark) -- Restore the saved line and column
		end
	end,
	desc = "Restore last cursor position when reopening a file",
})

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*", -- Apply to every buffer
	callback = function()
		vim.hl.on_yank({ -- Acts on yank event
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
	desc = "Highlight the yanked text for 200ms",
})

-- Keep programming assistance inside Markdown and Quarto code chunks.
local prose = require("config.prose")
local prose_group = vim.api.nvim_create_augroup("QuartoProse", {})

vim.api.nvim_create_autocmd("FileType", {
    group = prose_group,
    pattern = { "markdown", "quarto" },
    callback = function(args)
        local highlighted = pcall(vim.treesitter.start, args.buf, "markdown")
        local inline_ok, inline_loaded = pcall(vim.treesitter.language.add, "markdown_inline")
        vim.opt_local.spelllang = { "en", "es" }
        -- Both syntax trees are needed to exclude code blocks and inline code.
        vim.opt_local.spell = highlighted and inline_ok and inline_loaded == true
    end,
    desc = "Enable Markdown syntax trees and English/Spanish prose spelling",
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = prose_group,
    callback = function(args)
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
    end,
    desc = "Use only Otter's code-chunk LSP bridge in markup buffers",
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = prose_group,
    callback = function(args)
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
    end,
    desc = "Keep only code-chunk diagnostics in markup buffers",
})

-- Start source-file highlighting separately from the markup/spelling setup above.
-- Installing parsers in plugins/treesitter.lua does not enable their highlighters.
-- HELP: :help treesitter-highlight, :help vim.treesitter.start()
local source_treesitter_group = vim.api.nvim_create_augroup("SourceTreesitter", {})
vim.api.nvim_create_autocmd("FileType", {
    group = source_treesitter_group,
    pattern = { "lua", "python", "r", "sh", "bash", "vim" },
    callback = function(args)
        -- Shell scripts normally use the "sh" filetype, but their parser is "bash".
        local language = args.match == "sh" and "bash" or args.match
        -- Parser installation is asynchronous; allow files to open while it finishes.
        pcall(vim.treesitter.start, args.buf, language)
    end,
    desc = "Enable Treesitter highlighting for configured source filetypes",
})
