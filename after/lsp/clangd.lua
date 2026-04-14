return {
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- Clangd expects utf-16 offsets for locations and edits.
    capabilities.offsetEncoding = { 'utf-16' }
    return capabilities
  end)(),
}
