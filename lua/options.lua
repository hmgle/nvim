local map = require('utils').map

map('n', 'gt', '<cmd>bn<cr>')
map('n', 'gT', '<cmd>bp<cr>')

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.mouse = 'a'
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard
end)

-- https://github.com/preservim/tagbar/wiki#zig
vim.g.tagbar_type_zig = {
  ctagstype = 'zig',
  kinds = {
    'f:functions',
    's:structs',
    'e:enums',
    'u:unions',
    'E:errors',
  },
}

local function fcitx2en()
  if vim.fn.executable 'fcitx5-remote' == 1 then
    -- fcitx5 support
    vim.fn.jobstart({ 'fcitx5-remote' }, {
      on_stdout = function(_, data, _)
        if data and data[1] and data[1]:match '2' then -- 简体中文输入状态
          vim.fn.jobstart 'fcitx5-remote -c' -- 切换到英文输入状态
        end
      end,
    })
  elseif vim.fn.executable 'fcitx-remote' == 1 then
    -- fcitx support
    vim.fn.jobstart({ 'fcitx-remote' }, {
      on_stdout = function(_, data, _)
        if data and data[1] and data[1]:match '2' then -- 简体中文输入状态
          vim.fn.jobstart 'fcitx-remote -c' -- 切换到英文输入状态
        end
      end,
    })
  end
end

if vim.fn.executable 'fcitx5-remote' == 1 or vim.fn.executable 'fcitx-remote' == 1 then
  vim.api.nvim_create_augroup('fcitx', {})
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = 'fcitx',
    pattern = '*',
    callback = fcitx2en,
  })
end

vim.g.node_host_prog = io.open("nvm which default")

-- Some performance issues that seems to be related to the foldexpr setting
-- https://github.com/akinsho/toggleterm.nvim/issues/610
-- -- https://github.com/LazyVim/LazyVim/discussions/1233
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.opt.foldenable = false
