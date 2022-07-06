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

return M
