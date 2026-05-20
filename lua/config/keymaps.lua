-- ============================================================================
-- TITLE: NeoVim Keymaps
-- ABOUT: Sets some quality-of-life keymaps
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

-- NeoTree keymaps
-- Open and close Neo-tree with <Leader> + e (explorer)
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true, desc = "Toggle Neo-tree" })


-- Markdown code blocks
-- PYTHON
vim.keymap.set('n', '<leader>mp', function()
  -- Inserta las 3 líneas del bloque
  vim.api.nvim_put({"```{python}", "", "```"}, "l", true, true)
  -- Sube el cursor una línea para quedar en medio
  vim.cmd("normal! k")
  -- Entra en modo inserción
  vim.cmd("startinsert")
end, { desc = 'Insertar bloque de Python' })

-- R
vim.keymap.set('n', '<leader>mr', function()
  -- Inserta las 3 líneas del bloque
  vim.api.nvim_put({"```{r}", "", "```"}, "l", true, true)
  -- Sube el cursor una línea para quedar en medio
  vim.cmd("normal! k")
  -- Entra en modo inserción
  vim.cmd("startinsert")
end, { desc = 'Insertar bloque de R ' })

-- bash

-- R
vim.keymap.set('n', '<leader>mb', function()
  -- Inserta las 3 líneas del bloque
  vim.api.nvim_put({"```{bash}", "", "```"}, "l", true, true)
  -- Sube el cursor una línea para quedar en medio
  vim.cmd("normal! k")
  -- Entra en modo inserción
  vim.cmd("startinsert")
end, { desc = 'Insertar bloque de Bash ' })
