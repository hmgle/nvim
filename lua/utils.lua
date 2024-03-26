local M = {}

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = M.merge(options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.merge(...)
  return vim.tbl_deep_extend('force', ...)
end

function M.merge_list(tbl1, tbl2)
  for _, v in ipairs(tbl2) do
    table.insert(tbl1, v)
  end
  return tbl1
end

CloseBufsButCurr = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()
  for _, i in ipairs(bufs) do
    if i ~= bufnr then
      vim.api.nvim_buf_delete(i, {})
    end
  end
end
vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>lua CloseBufsButCurr()<CR>', { noremap = true })

return M
