-- ================================================================================================
-- TITLE : auto-commands
-- ABOUT : automatically run code on defined events (e.g. save, yank)
-- ================================================================================================

-- Restore last cursor position when reopening a file
-- NOTE: First I create the group the autocmd will be part of
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
-- Now I can define the autocmd
vim.api.nvim_create_autocmd("BufReadPost", {
	group = last_cursor_group, -- Assign created group to this autocmd
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"') -- Get cursor for current buff 
		local lcount = vim.api.nvim_buf_line_count(0) -- Get buffer line
        -- If mark is not in line 0 or last line...
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark) -- Sets the cursor line
		end
        desc = "Restore last cursor position when reopening a file"
	end,
})

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*", -- Highlights everything selected
	callback = function()
		vim.hl.on_yank({ -- Acts on yank event
			higroup = "IncSearch",
			timeout = 200,
		})
    	desc = "Highlight the yanked text for 200ms"
	end,
})

-- Treesitter autocmds
local treesitter_group = vim.api.nvim_create_augroup('Treesitter', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*' }, -- Enabled in any file type
  callback = function() 
      vim.treesitter.start()
      -- Enables treesitter based folding
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      desc = "Enables treesitter syntax highlighting"
  end,
})
