local map = require('utils').map

vim.g.mapleader = ','

map('n', 'gt', "<cmd>bn<cr>")
map('n', 'gT', "<cmd>bp<cr>")

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard

-- https://github.com/preservim/tagbar/wiki#zig
vim.g.tagbar_type_zig = {
    ctagstype = 'zig',
    kinds = {
        'f:functions',
        's:structs',
        'e:enums',
        'u:unions',
        'E:errors',
    }
}

local function fcitx2en()
    vim.fn.jobstart({ 'fcitx-remote' }, {
        on_stdout = function(_, data, _)
            if data and data[1] and data[1]:match("2") then -- 简体中文输入状态
                vim.fn.jobstart('fcitx-remote -c') -- 切换到英文输入状态
            end
        end,
    })
end

if vim.fn.executable('fcitx-remote') == 1 then
    vim.api.nvim_create_augroup("fcitx", {})
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = "fcitx",
        pattern = "*",
        callback = fcitx2en,
    })
end
