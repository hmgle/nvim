require('toggleterm').setup {
  open_mapping = [[<C-s>]],
  start_in_insert = true,
  direction = 'float',
  close_on_exit = true,
  -- on_open = function()
  --   vim.o.background = 'dark'
  -- end,
  -- on_close = function()
  --   vim.o.background = 'light'
  -- end,
}

local group = vim.api.nvim_create_augroup('toggleterm_config', { clear = true })

vim.api.nvim_create_autocmd('TermEnter', {
  group = group,
  callback = function()
    vim.o.background = 'dark'
  end,
})

vim.api.nvim_create_autocmd('TermLeave', {
  group = group,
  callback = function()
    vim.o.background = 'light'
    require('config.gruvbox-material').apply_overrides()
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = group,
  pattern = 'term://*',
  callback = function(args)
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], {
      buffer = args.buf,
      desc = 'Leave terminal mode',
    })
  end,
})
