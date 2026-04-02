local M = {}

function M.setup()
  require("nvim-treesitter-textobjects").setup {
    select = {
      lookahead = true,
    },
    move = {
      set_jumps = true,
    },
  }

  local map = require("utils").map
  local select = require("nvim-treesitter-textobjects.select")
  local move = require("nvim-treesitter-textobjects.move")
  local shared = require("nvim-treesitter-textobjects.shared")

  local function preview_textobject(capture)
    local range = shared.textobject_at_point(capture, "textobjects", 0, nil, {
      lookahead = true,
    })
    if not range then
      vim.notify(("No textobject found for %s"):format(capture), vim.log.levels.WARN)
      return
    end

    local start_row, start_col, end_row, end_col = range[1], range[2], range[4], range[5]
    local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
    if vim.tbl_isempty(lines) then
      return
    end

    vim.lsp.util.open_floating_preview(lines, vim.bo.filetype, {
      border = "none",
      focusable = true,
      close_events = { "CursorMoved", "CursorMovedI", "InsertEnter", "BufHidden" },
    })
  end

  local function select_textobject(mode, capture)
    return function()
      select.select_textobject(capture, "textobjects", mode)
    end
  end

  local function goto_textobject(fn, capture)
    return function()
      fn(capture, "textobjects")
    end
  end

  local select_keymaps = {
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["as"] = "@statement.outer",
    ["ib"] = "@block.inner",
    ["ab"] = "@block.outer",
    ["ak"] = "@comment.outer",
  }

  for lhs, capture in pairs(select_keymaps) do
    map("x", lhs, select_textobject("x", capture))
    map("o", lhs, select_textobject("o", capture))
  end

  map("n", "]]", goto_textobject(move.goto_next_start, "@function.outer"))
  map("n", "]m", goto_textobject(move.goto_next_start, "@class.outer"))
  map("n", ")", goto_textobject(move.goto_next_start, "@block.outer"))
  map("n", "][", goto_textobject(move.goto_next_end, "@function.outer"))
  map("n", "]M", goto_textobject(move.goto_next_end, "@class.outer"))
  map("n", "[[", goto_textobject(move.goto_previous_start, "@function.outer"))
  map("n", "[m", goto_textobject(move.goto_previous_start, "@class.outer"))
  map("n", "(", goto_textobject(move.goto_previous_start, "@block.outer"))
  map("n", "[]", goto_textobject(move.goto_previous_end, "@function.outer"))
  map("n", "[M", goto_textobject(move.goto_previous_end, "@class.outer"))
  map("n", "<leader>df", function()
    preview_textobject("@function.outer")
  end, "Preview function")
  map("n", "<leader>dF", function()
    preview_textobject("@class.outer")
  end, "Preview class")
end

return M
