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

-- Install document guards before Lazy configures Quarto/Otter. The coordinator
-- owns markup highlighting/spelling, LSP filtering, and chunk-language discovery.
require("config.quarto").setup()

-- Source-file highlighting has its own scope; config.quarto owns document setup.
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
