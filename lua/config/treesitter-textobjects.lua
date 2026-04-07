local api = vim.api
local ts = vim.treesitter

local M = {}

local config = {
  select = {
    lookahead = true,
    lookbehind = false,
  },
  move = {
    set_jumps = true,
  },
}

local function row_col_to_byte(bufnr, row, col)
  local offset = api.nvim_buf_get_offset(bufnr, row)
  if offset < 0 then
    return 0
  end
  return offset + col
end

local function insert_to_path(object, path, value)
  local current = object
  for index = 1, (#path - 1) do
    local key = path[index]
    if current[key] == nil then
      current[key] = {}
    end
    current = current[key]
  end
  current[path[#path]] = value
end

local function get_at_path(object, path)
  local result = object
  for _, segment in ipairs(vim.split(path, ".", { plain = true })) do
    if type(result) ~= "table" then
      return nil
    end
    result = result[segment]
  end
  return result
end

local function add_bytes(bufnr, range)
  return {
    range[1],
    range[2],
    row_col_to_byte(bufnr, range[1], range[2]),
    range[3],
    range[4],
    row_col_to_byte(bufnr, range[3], range[4]),
  }
end

local function range_contains_pos(range, row, col)
  local starts_before = range[1] < row or (range[1] == row and range[2] <= col)
  local ends_after = row < range[4] or (row == range[4] and col < range[5])
  return starts_before and ends_after
end

local function range_contains_range(outer, inner)
  local start_ok = outer[1] < inner[1] or (outer[1] == inner[1] and outer[2] <= inner[2])
  local end_ok = inner[4] < outer[4] or (inner[4] == outer[4] and inner[5] <= outer[5])
  return start_ok and end_ok
end

local function get_query_matches(bufnr, query_group, root, lang)
  local query = ts.query.get(lang, query_group)
  if not query then
    return {}
  end

  local matches = {}
  local start_row, _, end_row, _ = root:range()
  for pattern, match, metadata in query:iter_matches(root, bufnr, start_row, end_row + 1) do
    if pattern then
      local prepared = {}

      for id, nodes in pairs(match) do
        local capture = query.captures[id]
        if capture ~= nil then
          local path = vim.split(capture, ".", { plain = true })
          if metadata[id] and metadata[id].range then
            insert_to_path(prepared, path, add_bytes(bufnr, metadata[id].range))
          else
            local start_node = nodes[1]
            local end_node = nodes[#nodes]
            local srow, scol, sbyte, erow, ecol, ebyte = start_node:range(true)
            if end_node ~= start_node then
              erow, ecol, ebyte = end_node:end_()
            end
            insert_to_path(prepared, path, { srow, scol, sbyte, erow, ecol, ebyte })
          end
        end
      end

      if metadata.range and metadata.range[7] then
        local path = vim.split(metadata.range[7], ".", { plain = true })
        insert_to_path(prepared, path, add_bytes(bufnr, metadata.range))
      end

      matches[#matches + 1] = prepared
    end
  end

  return matches
end

local function get_capture_ranges(bufnr, capture, query_group)
  local parser = ts.get_parser(bufnr)
  if not parser then
    return {}
  end

  parser:parse(true)

  local ranges = {}
  local path = capture:gsub("^@", "")
  parser:for_each_tree(function(tree, lang_tree)
    local matches = get_query_matches(bufnr, query_group, tree:root(), lang_tree:lang())
    for _, match in ipairs(matches) do
      local range = get_at_path(match, path)
      if range then
        ranges[#ranges + 1] = range
      end
    end
  end)

  return ranges
end

local function best_range_at_point(ranges, row, col, opts)
  local smallest
  local smallest_len
  local smallest_start
  local lookahead
  local lookahead_len
  local lookahead_start
  local lookbehind
  local lookbehind_len
  local lookbehind_start

  for _, range in ipairs(ranges) do
    if range_contains_pos(range, row, col) then
      local len = range[6] - range[3]
      if not smallest or len < smallest_len or (len == smallest_len and range[3] < smallest_start) then
        smallest = range
        smallest_len = len
        smallest_start = range[3]
      end
    elseif opts.lookahead then
      if range[1] > row or (range[1] == row and range[2] > col) then
        local len = range[6] - range[3]
        if not lookahead or range[3] < lookahead_start or (range[3] == lookahead_start and len > lookahead_len) then
          lookahead = range
          lookahead_len = len
          lookahead_start = range[3]
        end
      end
    elseif opts.lookbehind then
      if range[1] < row or (range[1] == row and range[2] < col) then
        local len = range[6] - range[3]
        if not lookbehind or range[3] > lookbehind_start or (range[3] == lookbehind_start and len < lookbehind_len) then
          lookbehind = range
          lookbehind_len = len
          lookbehind_start = range[3]
        end
      end
    end
  end

  return smallest or lookahead or lookbehind
end

function M.textobject_at_point(capture, query_group, bufnr, pos, opts)
  bufnr = bufnr or api.nvim_get_current_buf()
  pos = pos or api.nvim_win_get_cursor(0)
  opts = opts or {}

  local row, col = pos[1] - 1, pos[2]
  local ranges = get_capture_ranges(bufnr, capture, query_group)
  if vim.endswith(capture, ".outer") then
    return best_range_at_point(ranges, row, col, opts)
  end

  local outer_capture = capture:gsub("%..*$", ".outer")
  if outer_capture == capture then
    outer_capture = capture .. ".outer"
  end

  local outer_ranges = get_capture_ranges(bufnr, outer_capture, query_group)
  if vim.tbl_isempty(outer_ranges) then
    return best_range_at_point(ranges, row, col, opts)
  end

  local outer = best_range_at_point(outer_ranges, row, col, {})
  if not outer then
    return best_range_at_point(ranges, row, col, opts)
  end

  local nested = {}
  for _, range in ipairs(ranges) do
    if range_contains_range(outer, range) then
      nested[#nested + 1] = range
    end
  end

  if vim.tbl_isempty(nested) then
    return best_range_at_point(ranges, row, col, opts)
  end

  return best_range_at_point(nested, row, col, opts)
    or best_range_at_point(nested, outer[1], outer[2], { lookahead = true })
end

local function update_selection(range)
  local start_row, start_col, end_row, end_col = range[1], range[2], range[4], range[5]
  local mode = api.nvim_get_mode().mode
  if mode ~= "v" then
    vim.cmd.normal({ "v", bang = true })
  end

  if end_col == 0 then
    end_row = end_row - 1
    end_col = #api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1] + 1
  end

  local end_col_offset = vim.o.selection == "exclusive" and 0 or 1
  api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd("normal! o")
  api.nvim_win_set_cursor(0, { end_row + 1, end_col - end_col_offset })
end

local function select_textobject(capture)
  local range = M.textobject_at_point(capture, "textobjects", 0, nil, config.select)
  if range then
    update_selection(range)
  end
end

local function motion_target(range, use_start)
  if use_start then
    return range[1], range[2], range[3]
  end

  if range[5] == 0 then
    local line = api.nvim_buf_get_lines(0, range[4] - 1, range[4], true)[1] or ""
    return range[4] - 1, #line, range[6]
  end

  return range[4], range[5] - 1, range[6]
end

local function move_textobject(capture, opts)
  local cursor = api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]
  local ranges = get_capture_ranges(0, capture, "textobjects")
  local best
  local best_score

  for _, range in ipairs(ranges) do
    local target_row, target_col, score = motion_target(range, opts.start)
    local is_after = target_row > row or (target_row == row and target_col > col)
    local is_before = target_row < row or (target_row == row and target_col < col)
    local matches_direction = opts.forward and is_after or (not opts.forward and is_before)

    if matches_direction then
      local normalized = opts.forward and -score or score
      if best == nil or normalized > best_score then
        best = { row = target_row, col = target_col }
        best_score = normalized
      end
    end
  end

  if not best then
    return
  end

  if config.move.set_jumps then
    vim.cmd("normal! m'")
  end

  api.nvim_win_set_cursor(0, { best.row + 1, best.col })
end

local function preview_textobject(capture)
  local range = M.textobject_at_point(capture, "textobjects", 0, nil, { lookahead = true })
  if not range then
    vim.notify(("No textobject found for %s"):format(capture), vim.log.levels.WARN)
    return
  end

  local lines = api.nvim_buf_get_text(0, range[1], range[2], range[4], range[5], {})
  if vim.tbl_isempty(lines) then
    return
  end

  vim.lsp.util.open_floating_preview(lines, vim.bo.filetype, {
    border = "none",
    focusable = true,
    close_events = { "CursorMoved", "CursorMovedI", "InsertEnter", "BufHidden" },
  })
end

function M.setup()
  local map = require("utils").map

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
    map("x", lhs, function()
      select_textobject(capture)
    end)
    map("o", lhs, function()
      select_textobject(capture)
    end)
  end

  map("n", "]]", function()
    move_textobject("@function.outer", { forward = true, start = true })
  end)
  map("n", "]m", function()
    move_textobject("@class.outer", { forward = true, start = true })
  end)
  map("n", ")", function()
    move_textobject("@block.outer", { forward = true, start = true })
  end)
  map("n", "][", function()
    move_textobject("@function.outer", { forward = true, start = false })
  end)
  map("n", "]M", function()
    move_textobject("@class.outer", { forward = true, start = false })
  end)
  map("n", "[[", function()
    move_textobject("@function.outer", { forward = false, start = true })
  end)
  map("n", "[m", function()
    move_textobject("@class.outer", { forward = false, start = true })
  end)
  map("n", "(", function()
    move_textobject("@block.outer", { forward = false, start = true })
  end)
  map("n", "[]", function()
    move_textobject("@function.outer", { forward = false, start = false })
  end)
  map("n", "[M", function()
    move_textobject("@class.outer", { forward = false, start = false })
  end)
  map("n", "<leader>df", function()
    preview_textobject("@function.outer")
  end, "Preview function")
  map("n", "<leader>dF", function()
    preview_textobject("@class.outer")
  end, "Preview class")
end

return M
