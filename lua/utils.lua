local M = {}

function M.map(modes, lhs, rhs, opts)
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  local options = vim.tbl_extend('keep', opts or {}, { noremap = true, silent = true })
  vim.keymap.set(modes, lhs, rhs, options)
end

function M.termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.feedkeys(keys, mode)
  if mode == nil then mode = 'in' end
  return vim.api.nvim_feedkeys(M.termcodes(keys), mode, true)
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
