require('toggleterm').setup {
  open_mapping = [[<C-S>]],
  start_in_insert = true,
  direction = 'float',
  close_on_exit = true,
  on_open = function()
    vim.o.background = 'dark'
  end,
  on_close = function()
    vim.o.background = 'light'
  end,
}
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  -- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
