local ok, _ = pcall(require, 'impatient')

if not ok then
  vim.notify('impatient.nvim not installed', vim.log.levels.WARN)
end

require("basic")
require("plugins")
require("options")

vim.cmd("source $HOME/.config/nvim/viml/conf.vim")
