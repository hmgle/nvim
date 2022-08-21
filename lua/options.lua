local map = require('utils').map

vim.g.mapleader = ','

vim.g.NERDTreeWinSize = 24
map('n', '<leader>tt', ':NERDTreeTabsToggle<CR>')

map('n', '<c-w><c-e>', ':TagbarToggle<CR>')


map('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>")
map('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>")
map('', 's', "<cmd>lua require'hop'.hint_char1({ current_line_only = false })<cr>")

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.mouse = 'a'
