vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.g.encoding = 'UTF-8'
vim.o.fileencoding = 'utf-8'
vim.opt.fileencodings = { 'utf-8', 'gbk', 'ucs-bom', 'cp936', 'gb18030' }

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.jumpoptions = 'stack'

vim.keymap.set('n', '<leader>cp', function()
  local path = vim.fn.expand '%:.'
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end, { desc = 'Copy relative path' })

vim.keymap.set('n', '<leader>cP', function()
  vim.fn.setreg('+', vim.fn.expand '%:p')
  vim.notify('Copied: ' .. vim.fn.expand '%:p')
end, { desc = 'Copy absolute path' })

vim.keymap.set('n', '<leader>cf', function()
  vim.fn.setreg('+', vim.fn.expand '%:t')
  vim.notify('Copied: ' .. vim.fn.expand '%:t')
end, { desc = 'Copy filename' })
