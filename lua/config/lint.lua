local lint = require 'lint'

lint.linters_by_ft = {
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  svelte = { 'eslint_d' },
  python = { 'mypy' },
  -- markdown = { 'markdownlint' },
  sh = { 'shellcheck' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

local lint_enabled = true

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function(event)
    if not lint_enabled then
      return
    end
    lint.try_lint(event.buf)
  end,
})

local function toggle_lint()
  lint_enabled = not lint_enabled
  if lint_enabled then
    lint.try_lint()
  else
    vim.diagnostic.reset(lint.get_namespace())
  end
end

vim.keymap.set('n', '<leader>L', toggle_lint, { noremap = true, desc = 'Toggle Lint' })
