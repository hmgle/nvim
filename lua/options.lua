local map = require('utils').map

vim.g.mapleader = ','

vim.g.NERDTreeWinSize = 24
map('n', '<leader>tt', ':NERDTreeTabsToggle<CR>')

map('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>")
map('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>")
map('', 's', "<cmd>lua require'hop'.hint_char1({ current_line_only = false })<cr>")

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.mouse = 'a'

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
