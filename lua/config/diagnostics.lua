local M = {}

local function open_diagnostic_float_on_jump(diagnostic, bufnr)
  if not diagnostic then
    return
  end

  vim.diagnostic.open_float({
    bufnr = bufnr,
    scope = "cursor",
    focus = false,
  })
end

function M.setup()
  vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    virtual_text = {
      source = "if_many",
      spacing = 2,
    },
    float = {
      border = "rounded",
      source = "if_many",
    },
    jump = {
      on_jump = open_diagnostic_float_on_jump,
    },
  })
end

return M
