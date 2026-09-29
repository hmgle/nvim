local M = {}

function M.apply_overrides()
  if vim.g.colors_name ~= 'gruvbox-material' then
    return
  end

  local set_hl = vim.api.nvim_set_hl
  local groups = {
    Search = { bg = 'NONE', fg = '#ff2222' },
    CurSearch = { bg = 'NONE', fg = '#ff0000', bold = true },
    HlSearchNear = { bg = 'NONE', fg = '#ff0000' },
    HlSearchLens = { bg = 'NONE', fg = '#bbbbbb' },
    HlSearchLensNear = { bg = 'NONE', fg = '#888888' },
    BlinkCmpGhostText = { bg = 'NONE', fg = '#bbb090' },
  }

  for name, opts in pairs(groups) do
    set_hl(0, name, opts)
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup('GruvboxMaterialOverrides', { clear = true })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    pattern = 'gruvbox-material',
    callback = M.apply_overrides,
  })

  M.apply_overrides()
end

return M
