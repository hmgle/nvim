require('nvim-lightbulb').setup({
  sign = {
    enabled = false,
  },
  float = {
    enabled = false,
  },
  virtual_text = {
    enabled = true,
    text = "Ω",
  },
  status_text = {
    enabled = false,
  },
  autocmd = {
    enabled = true,
    events = {"CursorHold"}
  }
})

vim.g.cursorhold_updatetime = 100
