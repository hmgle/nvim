local lint = require 'lint'

lint.linters_by_ft = {
  javascript = { 'biomejs' },
  typescript = { 'biomejs' },
  javascriptreact = { 'biomejs' },
  typescriptreact = { 'biomejs' },
  svelte = { 'biomejs' },
  python = { 'ruff' },
  -- markdown = { 'markdownlint' },
  sh = { 'shellcheck' },
  yaml = { 'yamllint' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
local yaml_validate_augroup = vim.api.nvim_create_augroup('yaml_validate', { clear = true })

local lint_enabled = true

local missing_linters = {}
local missing_linter_messages = {
  yamllint = 'YAML diagnostics and write validation skipped: install yamllint with :MasonInstall yamllint',
}

local function warn_missing_linter(cmd, message)
  if missing_linters[cmd] then
    return
  end
  missing_linters[cmd] = true
  vim.notify(message, vim.log.levels.WARN)
end

local function is_helm_template(bufnr)
  local chart = vim.fs.root(bufnr, 'Chart.yaml')
  return chart ~= nil and vim.fs.relpath(vim.fs.joinpath(chart, 'templates'), vim.api.nvim_buf_get_name(bufnr)) ~= nil
end

local function resolve_linter(name)
  local linter = lint.linters[name]
  if type(linter) == 'function' then
    linter = linter()
  end
  return linter
end

local function resolve_cmd(linter)
  if not linter then
    return nil
  end
  local cmd = linter.cmd
  if type(cmd) == 'function' then
    cmd = cmd()
  end
  if type(cmd) == 'table' then
    cmd = cmd[1]
  end
  return cmd
end

local function available_linters(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return nil
  end
  local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
  if ft == 'yaml' and is_helm_template(bufnr) then
    return nil
  end
  local configured = lint.linters_by_ft[ft]
  if not configured then
    return nil
  end

  local runnable = {}
  for _, name in ipairs(configured) do
    local linter = resolve_linter(name)
    if linter then
      local cmd = resolve_cmd(linter)
      if not cmd or vim.fn.executable(cmd) == 1 then
        table.insert(runnable, name)
      else
        warn_missing_linter(cmd, missing_linter_messages[name] or string.format('nvim-lint: skipping `%s` because `%s` is not executable', name, cmd))
      end
    end
  end

  if #runnable == 0 then
    return nil
  end
  return runnable
end

local function run_lint(bufnr)
  if not lint_enabled then
    return
  end
  local target = bufnr or vim.api.nvim_get_current_buf()
  local linters = available_linters(target)
  if not linters then
    return
  end
  if bufnr then
    vim.api.nvim_buf_call(bufnr, function()
      lint.try_lint(linters)
    end)
  else
    lint.try_lint(linters)
  end
end

local function clear_lint(bufnr)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
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

local function validate_yaml_before_write(bufnr)
  if vim.bo[bufnr].filetype ~= 'yaml' or vim.bo[bufnr].buftype ~= '' or vim.b[bufnr].yaml_validate_on_save == false or is_helm_template(bufnr) then
    return
  end
  if vim.fn.executable 'yamllint' ~= 1 then
    warn_missing_linter('yamllint', missing_linter_messages.yamllint)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- A yamllint style opt-out must not disable syntax validation.
  if lines[1] and lines[1]:match '^#%s*yamllint disable%-file%s*$' then
    lines[1] = '#'
  end
  local result = vim
    .system({ 'yamllint', '-d', '{rules: {}}', '-' }, {
      stdin = table.concat(lines, '\n') .. (vim.bo[bufnr].endofline and '\n' or ''),
      text = true,
    })
    :wait(3000)

  if result.code == 124 then
    error('YAML write validation timed out after 3000 ms; write aborted', 0)
  elseif result.code ~= 0 then
    error('YAML syntax check failed; write aborted:\n' .. (result.stdout or '') .. (result.stderr or ''), 0)
  end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  group = yaml_validate_augroup,
  callback = function(event)
    validate_yaml_before_write(event.buf)
  end,
})
