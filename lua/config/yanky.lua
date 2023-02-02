local status_ok, yanky = pcall(require, "yanky")
if not status_ok then
  return
end

local telescope_status_ok, telescope = pcall(require, "telescope")
if not telescope_status_ok then
  return
end
telescope.load_extension "yank_history"

local actions = require "telescope.actions"
local mapping = require "yanky.telescope.mapping"
local utils = require "yanky.utils"

yanky.setup {
  ring = {
    history_length = 10,
    storage = "shada",
    sync_with_numbered_registers = true,
  },
  picker = {
    select = {
      action = nil, -- nil to use default put action
    },
    telescope = {
      mappings = {
        default = mapping.put("p"),
        i = {
          ["<c-j>"] = actions.move_selection_next,
          ["<c-k>"] = actions.move_selection_previous,
          ["<cr>"] = mapping.put("p"),
          ["<c-p>"] = mapping.put("P"),
          ["<c-x>"] = mapping.delete(),
          ["<c-r>"] = mapping.set_register(utils.get_default_register()),
        },
        n = {
          j = actions.move_selection_next,
          k = actions.move_selection_previous,
          p = mapping.put("p"),
          P = mapping.put("P"),
          x = mapping.delete(),
          r = mapping.set_register(utils.get_default_register()),
        }
      }
    },
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 500,
  },
  preserve_cursor_position = {
    enabled = true,
  },
}

vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-j>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-k>", "<Plug>(YankyCycleBackward)")
vim.keymap.set("n", "<leader>y", ":Telescope yank_history<CR>")
