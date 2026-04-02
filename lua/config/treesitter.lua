require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "go", "python", "javascript", "typescript" },
  auto_install = false,
  sync_install = false,
  highlight = {
    enable = true,
    disable = { "yaml" }, -- Disable yaml highlighting because Helm sucks :<
    additional_vim_regex_highlighting = false,
  },
}

-- Neovim 0.12 still hands singleton capture wrappers to core helpers in some
-- markdown injection paths, and nvim-treesitter query consumers still expect
-- bare TSNodes.
if vim.fn.has("nvim-0.12") == 1 then
  local compat = require("config.treesitter-compat")
  compat.patch_vim_treesitter()
  compat.patch_nvim_treesitter()
end
