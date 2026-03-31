local M = {}

local function unwrap_capture(value)
  while type(value) == "table" and value[1] ~= nil do
    value = value[1]
  end
  return value
end

local function unwrap_node(value)
  while type(value) == "table" and value[1] ~= nil do
    value = value[1]
  end
  return value
end

function M.patch_vim_treesitter()
  local ts = vim.treesitter
  if ts._capture_compat_patched then
    return
  end
  ts._capture_compat_patched = true

  local get_range = ts.get_range
  local get_node_text = ts.get_node_text

  ts.get_range = function(node, source, metadata)
    return get_range(unwrap_node(node), source, metadata)
  end

  ts.get_node_text = function(node, source, opts)
    return get_node_text(unwrap_node(node), source, opts)
  end
end

function M.patch_nvim_treesitter()
  local ok, query = pcall(require, "nvim-treesitter.query")
  if not ok or query._capture_compat_patched then
    return
  end
  query._capture_compat_patched = true

  -- Neovim 0.12 wraps captures from iter_matches(..., { all = false }).
  -- nvim-treesitter-textobjects still expects bare TSNode values here.
  local tsrange = require("nvim-treesitter.tsrange")

  query.iter_prepared_matches = function(ts_query, qnode, bufnr, start_row, end_row)
    local function split(to_split)
      local parts = {}
      for part in string.gmatch(to_split, "([^.]+)") do
        table.insert(parts, part)
      end
      return parts
    end

    local matches = ts_query:iter_matches(qnode, bufnr, start_row, end_row, { all = false })

    return function()
      local pattern, match, metadata = matches()
      if pattern == nil then
        return
      end

      local prepared_match = {}

      for id, node in pairs(match) do
        local name = ts_query.captures[id]
        if name ~= nil then
          query.insert_to_path(prepared_match, split(name .. ".node"), unwrap_capture(node))
          query.insert_to_path(prepared_match, split(name .. ".metadata"), metadata[id])
        end
      end

      local preds = ts_query.info.patterns[pattern]
      if preds then
        for _, pred in pairs(preds) do
          if pred[1] == "set!" and type(pred[2]) == "string" then
            query.insert_to_path(prepared_match, split(pred[2]), pred[3])
          end
          if pred[1] == "make-range!" and type(pred[2]) == "string" and #pred == 4 then
            query.insert_to_path(
              prepared_match,
              split(pred[2] .. ".node"),
              tsrange.TSRange.from_nodes(bufnr, unwrap_capture(match[pred[3]]), unwrap_capture(match[pred[4]]))
            )
          end
        end
      end

      return prepared_match
    end
  end
end

return M
