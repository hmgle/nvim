local status_ok, neoclip = pcall(require, "neoclip")
if not status_ok then
  return
end

local telescope_status_ok, telescope = pcall(require, "telescope")
if not telescope_status_ok then
  return
end
telescope.load_extension('neoclip')

neoclip.setup {
  history = 100,
  keys = { telescope = { i = {
    paste_behind = '<nop>',
  }}}
}
vim.keymap.set("n", "<leader>y", ":Telescope neoclip<CR>")
