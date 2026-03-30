local M = {}

local function has_method(value, method)
  local ok, result = pcall(function()
    return type(value[method]) == "function"
  end)
  return ok and result
end

local function is_node_like(value)
  local value_type = type(value)
  if value_type ~= "table" and value_type ~= "userdata" then
    return false
  end

  return has_method(value, "start") and has_method(value, "end_") and has_method(value, "range")
end

local function unwrap_capture(value)
  if type(value) == "table" and not is_node_like(value) and is_node_like(value[1]) then
    return value[1]
  end

  return value
end

function M.patch_core()
  if vim.g._treesitter_capture_compat_patched then
    return
  end
  vim.g._treesitter_capture_compat_patched = true

  local ts = vim.treesitter
  if not ts then
    return
  end

  local original_get_range = ts.get_range
  if type(original_get_range) == 'function' then
    ts.get_range = function(node, ...)
      return original_get_range(unwrap_capture(node), ...)
    end
  end

  local original_get_node_text = ts.get_node_text
  if type(original_get_node_text) == 'function' then
    ts.get_node_text = function(node, ...)
      return original_get_node_text(unwrap_capture(node), ...)
    end
  end
end

function M.patch_nvim_treesitter()
  local ok, query = pcall(require, 'nvim-treesitter.query')
  if not ok or query._capture_compat_patched then
    return
  end
  query._capture_compat_patched = true

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

  local original_iter_captures = query.iter_captures
  query.iter_captures = function(bufnr, query_name, root, lang)
    local iter = original_iter_captures(bufnr, query_name, root, lang)

    return function()
      local name, node, metadata = iter()
      if name == nil then
        return
      end

      return name, unwrap_capture(node), metadata
    end
  end
end

M.patch_core()

return M
