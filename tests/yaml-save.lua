-- Run with installed plugins and yamllint:
-- nvim --headless -u NONE -i NONE -l tests/yaml-save.lua
local config = vim.fs.dirname(vim.fs.dirname(vim.fs.abspath(arg[0])))
vim.opt.runtimepath:prepend(config)
for _, plugin in ipairs { 'conform.nvim', 'nvim-lint' } do
  vim.opt.runtimepath:append(vim.fn.stdpath 'data' .. '/lazy/' .. plugin)
end
assert(vim.fn.executable 'yamllint' == 1, 'yamllint must be installed')

local scratch = vim.fn.tempname()
vim.fn.mkdir(scratch, 'p')
vim.fn.writefile({ 'rules:', '  document-start:', '    level: warning' }, scratch .. '/.yamllint')
local original_cwd = vim.fn.getcwd()
vim.cmd.cd(scratch)
local original_path = vim.env.PATH
local warnings = {}
vim.notify = function(message, level)
  if level == vim.log.levels.WARN then
    warnings[#warnings + 1] = message
  end
end

-- Use Conform's real save hook with a formatter that needs no external tool.
require('conform').setup {
  formatters_by_ft = { yaml = { 'trim_whitespace' } },
  format_on_save = { timeout_ms = 1000 },
}
require 'config.lint'
local lint = require 'lint'

local function settle_lint()
  assert(
    vim.wait(5000, function()
      return #lint.get_running() == 0
    end, 10),
    'asynchronous lint did not finish'
  )
end

local function edit(name, lines)
  settle_lint()
  local path = scratch .. '/' .. name
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  vim.fn.writefile({ 'key: old' }, path)
  vim.cmd.edit { path, bang = true }
  vim.bo.filetype = 'yaml'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines or { 'key: new   ' })
  return path
end

local function read(path)
  return table.concat(vim.fn.readfile(path, 'b'), '\n')
end

local function rejects(command, message)
  local ok, err = pcall(vim.cmd, command or 'write')
  assert(not ok, 'invalid YAML must fail the write command')
  assert(err:find(message or 'YAML syntax check failed', 1, true), err)
  assert(vim.bo.modified, 'failed write must retain unsaved edits')
end

local function check()
  local path = edit 'normal.yaml'
  vim.cmd.write()
  assert(read(path) == 'key: new\n', 'save must run Conform')
  assert(not vim.bo.modified, 'successful save must clear modified')
  settle_lint()
  assert(#vim.diagnostic.get(0, { namespace = lint.get_namespace 'yamllint' }) > 0, 'save must still produce style diagnostics')

  path = edit 'copy.yaml'
  local target = scratch .. '/copy-target.yaml'
  vim.cmd.write { target }
  assert(read(path) == 'key: old\n', 'write-to-file must preserve the original')
  assert(read(target) == 'key: new\n', 'write-to-file must use the requested target')
  assert(vim.bo.modified, 'writing a copy must retain modified')

  path = edit 'saveas.yaml'
  target = scratch .. '/renamed.yaml'
  vim.cmd.saveas { target }
  assert(vim.api.nvim_buf_get_name(0) == target, 'saveas must rename the buffer')
  assert(read(path) == 'key: old\n' and read(target) == 'key: new\n', 'saveas must preserve the original')

  path = edit 'readonly.yaml'
  vim.bo.readonly = true
  vim.cmd.write { bang = true }
  assert(read(path) == 'key: new\n', 'write! must override readonly')
  vim.bo.readonly = false

  path = edit('dos.yaml', { 'key: new', 'other: value' })
  vim.cmd 'write ++ff=dos'
  assert(read(path) == 'key: new\r\nother: value\r\n', 'write must preserve ++ff')

  path = edit('invalid.yaml', { 'key: [unterminated' })
  rejects()
  assert(read(path) == 'key: old\n', 'syntax errors must not reach disk')
  rejects 'wq'
  local toggle_lint = vim.fn.maparg('<leader>L', 'n', false, true).callback
  toggle_lint()
  rejects()
  toggle_lint()

  path = edit('disabled-style.yaml', { '# yamllint disable-file', 'key: [unterminated' })
  rejects()
  assert(read(path) == 'key: old\n', 'disabling style checks must not disable syntax validation')

  path = edit('changed-filetype.yaml', { 'key: [unterminated' })
  vim.bo.filetype = 'text'
  vim.cmd.write()
  assert(read(path) == 'key: [unterminated\n', 'validation must follow the current filetype')

  path = edit('opt-out.yaml', { 'key: [unterminated' })
  vim.b.yaml_validate_on_save = false
  vim.cmd.write()
  assert(read(path) == 'key: [unterminated\n', 'explicit per-buffer opt-out must work')

  vim.fn.mkdir(scratch .. '/chart', 'p')
  vim.fn.writefile({ 'apiVersion: v2', 'name: test', 'version: 0.1.0' }, scratch .. '/chart/Chart.yaml')
  path = edit('chart/templates/nested/deployment.yaml', { '{{- if .Values.enabled }}', 'key: value', '{{- end }}' })
  vim.cmd.write()
  assert(read(path):find('{{- if .Values.enabled }}', 1, true), 'Helm templates must be writable')
  assert(#lint.get_running(0) == 0, 'Helm templates must skip yamllint')

  for _, name in ipairs { 'chart/values.yaml', 'chart/templates-other/plain.yaml', 'templates/plain.yaml' } do
    edit(name, { 'key: [unterminated' })
    rejects()
  end

  -- Re-sourcing must neither duplicate validation nor leave stale buffer hooks.
  dofile(config .. '/lua/config/lint.lua')
  path = edit 'reloaded.yaml'
  vim.cmd.write()
  assert(read(path) == 'key: new\n', 'saving must survive a config reload')
  assert(#vim.api.nvim_get_autocmds { group = 'yaml_validate', event = 'BufWritePre' } == 1, 'reload must replace the save hook')

  path = edit 'missing-checker.yaml'
  settle_lint()
  warnings = {}
  vim.env.PATH = scratch
  vim.cmd.write()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'key: another' })
  vim.cmd.write()
  assert(read(path) == 'key: another\n', 'missing yamllint must not lock users out of saving')
  assert(#warnings == 1 and warnings[1]:find('write validation skipped', 1, true), 'missing yamllint must warn once')
  vim.env.PATH = original_path

  path = edit 'timeout.yaml'
  settle_lint()
  local bin = scratch .. '/bin'
  vim.fn.mkdir(bin, 'p')
  vim.fn.writefile({ '#!/bin/sh', 'exec /bin/sleep 30' }, bin .. '/yamllint')
  assert(vim.fn.setfperm(bin .. '/yamllint', 'rwx------') == 1)
  vim.env.PATH = bin
  local started = vim.uv.hrtime()
  rejects('write', 'YAML write validation timed out')
  assert((vim.uv.hrtime() - started) / 1e9 < 6, 'validation timeout must bound the wait')
  assert(read(path) == 'key: old\n', 'timeout must not write unchecked content')
  vim.env.PATH = original_path
end

local ok, err = xpcall(check, debug.traceback)
vim.env.PATH = original_path
settle_lint()
vim.cmd 'silent! %bwipeout!'
vim.cmd.cd(original_cwd)
vim.fn.delete(scratch, 'rf')
if not ok then
  error(err, 0)
end
print 'YAML save regression checks passed'
