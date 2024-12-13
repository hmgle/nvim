local lint = require 'lint'

lint.linters_by_ft = {
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  svelte = { 'eslint_d' },
  python = { 'mypy' },
  markdown = { 'markdownlint' },
  sh = { 'shellcheck' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

local ls = false
local toggle_lint = function()
  if ls == true then
    ls = false
    vim.diagnostic.reset(nil, 0)
  else
    ls = true
    lint.try_lint()
  end
end
vim.keymap.set({ 'n' }, '<leader>L', toggle_lint, { noremap = true, desc = 'Toggle Lint' })
