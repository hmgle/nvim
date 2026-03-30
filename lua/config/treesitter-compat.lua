local M = {}

local function unwrap_capture(node)
  if type(node) == 'table' then
    return node[1] or node
  end
  return node
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

  local original_iter_prepared_matches = query.iter_prepared_matches
  query.iter_prepared_matches = function(...)
    local iter = original_iter_prepared_matches(...)

    return function()
      local prepared_match = iter()
      if not prepared_match then
        return
      end

      local function normalize_nodes(value)
        if type(value) ~= 'table' then
          return
        end
        for key, nested in pairs(value) do
          if key == 'node' then
            value[key] = unwrap_capture(nested)
          else
            normalize_nodes(nested)
          end
        end
      end

      normalize_nodes(prepared_match)
      return prepared_match
    end
  end
end

M.patch_core()

return M
