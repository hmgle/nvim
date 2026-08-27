local M = {}

function M.map(modes, lhs, rhs, opts)
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  if opts and opts.buffer ~= nil and opts.buf == nil then
    opts.buf = opts.buffer
    opts.buffer = nil
  end
  local options = vim.tbl_extend('keep', opts or {}, { noremap = true, silent = true })
  vim.keymap.set(modes, lhs, rhs, options)
end

function M.termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.feedkeys(keys, mode)
  if mode == nil then
    mode = 'in'
  end
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

function M.is_floating_window(win)
  win = win or 0
  return vim.api.nvim_win_get_config(win).relative ~= ''
end

function M.set_local_window_option(win, name, value, opts)
  win = win or 0
  opts = opts or {}

  local local_value = value
  if M.is_floating_window(win) then
    local_value = opts.float_value
  end

  vim.api.nvim_set_option_value(name, local_value, { scope = 'local', win = win })
end

function M.close_other_buffers()
  local bufnr = vim.api.nvim_get_current_buf()
  local targets = {}
  local modified = {}

  for _, target in ipairs(vim.api.nvim_list_bufs()) do
    if target ~= bufnr and vim.api.nvim_buf_is_valid(target) then
      targets[#targets + 1] = target
      if vim.bo[target].modified then
        local name = vim.api.nvim_buf_get_name(target)
        modified[#modified + 1] = name == '' and ('[No Name] (buffer %d)'):format(target) or vim.fn.fnamemodify(name, ':~:.')
      end
    end
  end

  if #modified > 0 then
    vim.notify('Close other buffers aborted; unsaved changes in:\n' .. table.concat(modified, '\n'), vim.log.levels.WARN)
    return false
  end

  for _, target in ipairs(targets) do
    vim.api.nvim_buf_delete(target, {})
  end
  return true
end

vim.keymap.set('n', '<leader>o', M.close_other_buffers, { desc = 'Close other buffers' })

return M
