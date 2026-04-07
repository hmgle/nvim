local M = {}

local disabled_highlights = {
  yaml = true, -- Disable yaml highlighting because Helm sucks :<
}

local group = vim.api.nvim_create_augroup("native-treesitter", { clear = true })

local function maybe_start(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  if vim.bo[bufnr].buftype ~= "" or disabled_highlights[vim.bo[bufnr].filetype] then
    pcall(vim.treesitter.stop, bufnr)
    return
  end

  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    return
  end

  vim.treesitter.start(bufnr)
end

function M.setup()
  vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
    group = group,
    callback = function(args)
      maybe_start(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "filetype",
    callback = function()
      maybe_start(vim.api.nvim_get_current_buf())
    end,
  })

  maybe_start(vim.api.nvim_get_current_buf())
end

M.setup()

return M
