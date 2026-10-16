-- ============================================================================
-- TITLE: Markdown and Quarto prose context
-- ABOUT: Separate fenced code bodies from prose using the Markdown syntax tree
-- HELP: :help treesitter-parsers, :help treesitter-query
-- ============================================================================

local M = {}

--- Identify the document filetypes governed by the code/prose assistance policy.
---@param bufnr integer? Buffer handle; nil or 0 means the current buffer.
---@return boolean
function M.is_markup(bufnr)
  local filetype = vim.bo[bufnr or 0].filetype
  return filetype == "markdown" or filetype == "quarto"
end

---@class ProseCodeChunk
---@field start_row integer First code-body row, zero-based and inclusive.
---@field end_row integer Row after the code body, zero-based and exclusive.

--- Find fenced code bodies, excluding fence delimiters and language annotations.
--- Return an empty list if the Markdown parser/tree is unavailable.
---@param bufnr integer? Buffer handle; nil or 0 means the current buffer.
---@return ProseCodeChunk[]
function M.code_chunks(bufnr)
  bufnr = bufnr or 0
  local ok, trees = pcall(function()
    return vim.treesitter.get_parser(bufnr, "markdown"):parse()
  end)
  if not ok or not trees or not trees[1] then
    return {}
  end

  local chunks = {}
  local query = vim.treesitter.query.parse("markdown", "(fenced_code_block) @chunk")
  for _, node in query:iter_captures(trees[1]:root(), bufnr) do
    local start_row, _, node_end_row, end_col = node:range()
    local end_row = node_end_row + (end_col > 0 and 1 or 0)
    local closed = false
    -- Fence delimiters and language annotations are not code bodies.
    for child in node:iter_children() do
      if child:type() == "fenced_code_block_delimiter" then
        local fence_row = child:range()
        if fence_row > start_row then
          end_row = fence_row
          closed = true
        end
      end
    end
    -- An unfinished fence can include an empty editable line at actual EOF.
    if not closed and node_end_row == vim.api.nvim_buf_line_count(bufnr) - 1 then
      local last_line = vim.api.nvim_buf_get_lines(bufnr, node_end_row, node_end_row + 1, false)[1]
      if end_col == #last_line then
        end_row = node_end_row + 1
      end
    end
    if start_row + 1 < end_row then
      chunks[#chunks + 1] = { start_row = start_row + 1, end_row = end_row }
    end
  end
  return chunks
end

--- Treat every row outside a fenced code body as prose in markup documents.
--- An unavailable parser therefore keeps programming assistance quiet throughout.
---@param bufnr integer? Buffer handle; nil or 0 means the current buffer.
---@param row integer? Zero-based row; defaults to the current window's cursor row.
---@return boolean prose False for ordinary source buffers or fenced code bodies.
function M.is_prose(bufnr, row)
  if not M.is_markup(bufnr) then
    return false
  end
  row = row or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  for _, chunk in ipairs(M.code_chunks(bufnr)) do
    if row >= chunk.start_row and row < chunk.end_row then
      return false
    end
  end
  return true
end

return M
