local M = {}

M.parsers = {
  'c',
  'erlang',
  'go',
  'html',
  'javascript',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'ruby',
  'rust',
  'typescript',
  'yaml',
  'zig',
}

M.rainbow = {
  'c',
  'erlang',
  'go',
  'javascript',
  'lua',
  'markdown',
  'python',
  'ruby',
  'rust',
  'zig',
}

local install_task

function M.install()
  if not install_task then
    install_task = require('nvim-treesitter').install(M.parsers)
  end
  return install_task
end

return M
