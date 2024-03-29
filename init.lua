require("basic")
vim.cmd("source $HOME/.config/nvim/viml/conf.vim")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
require("options")
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
  -- defaults = { lazy = true },
  -- install = { colorscheme = { "gruvbox-material" } },
  -- checker = { enabled = true },
})
