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
      elseif not missing_linters[cmd] then
        missing_linters[cmd] = true
        vim.notify(string.format('nvim-lint: skipping `%s` because `%s` is not executable', name, cmd), vim.log.levels.WARN)
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
  if vim.fn.executable 'ruby' ~= 1 then
    vim.notify('YAML write validation skipped: ruby is not executable', vim.log.levels.WARN)
    return false
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local result = vim
    .system({
      'ruby',
      '-e',
      'require "yaml"; YAML.parse_stream($stdin)',
    }, {
      stdin = table.concat(lines, '\n'),
      text = true,
    })
    :wait()

  if result.code == 0 then
    return true
  end

  vim.notify('YAML syntax error; write aborted:\n' .. result.stderr, vim.log.levels.ERROR)
  return false
end

vim.api.nvim_create_autocmd('FileType', {
  group = yaml_validate_augroup,
  pattern = 'yaml',
  callback = function(event)
    local bufnr = event.buf
    if vim.b[bufnr].yaml_write_cmd_installed then
      return
    end
    vim.b[bufnr].yaml_write_cmd_installed = true

    vim.api.nvim_create_autocmd('BufWriteCmd', {
      group = yaml_validate_augroup,
      buffer = bufnr,
      callback = function()
        if not validate_yaml_before_write(bufnr) then
          return
        end

        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd 'noautocmd write'
        end)
        run_lint(bufnr)
      end,
    })
  end,
})
