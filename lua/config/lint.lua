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

local function run_lint(bufnr)
  if not lint_enabled then
    return
  end
  if bufnr then
    vim.api.nvim_buf_call(bufnr, function()
      lint.try_lint()
    end)
  else
    lint.try_lint()
  end
end

local function clear_lint(bufnr)
  local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  local linters = lint.linters_by_ft[ft]
  if not linters then
    return
  end
  for _, name in ipairs(linters) do
    local ns = lint.get_namespace(name)
    if ns then
      vim.diagnostic.reset(ns, bufnr)
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function(event)
    run_lint(event.buf)
  end,
})

local function toggle_lint()
  lint_enabled = not lint_enabled
  local bufnr = vim.api.nvim_get_current_buf()
  if lint_enabled then
    run_lint(bufnr)
  else
    clear_lint(bufnr)
  end
end

vim.keymap.set('n', '<leader>L', toggle_lint, { noremap = true, desc = 'Toggle Lint' })
