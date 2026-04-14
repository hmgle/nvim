vim.lsp.log.set_level 'WARN'

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
  return
end

mason.setup {
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
}

local masonlspconf_ok, masonlspconf = pcall(require, 'mason-lspconfig')
if not masonlspconf_ok then
  return
end

local function normalize_supports_method(client)
  if client._supports_method_compat then
    return
  end

  local mt = getmetatable(client)
  local supports = mt and mt.supports_method
  if type(supports) ~= 'function' then
    return
  end

  client.supports_method = function(arg1, ...)
    if arg1 == client then
      return supports(client, ...)
    else
      return supports(client, arg1, ...)
    end
  end
  client._supports_method_compat = true
end

local function enable_builtin_lsp_features(client, bufnr)
  if client:supports_method 'textDocument/codeLens' then
    vim.lsp.codelens.enable(false, { bufnr = bufnr })
  end

  if client:supports_method 'textDocument/inlayHint' then
    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
  end

  if client:supports_method 'textDocument/linkedEditingRange' then
    vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
  end
end

local function set_lsp_keymaps(bufnr)
  local function notify_toggle(feature, enabled)
    vim.notify(string.format('%s: %s', feature, enabled and 'ON' or 'OFF'), vim.log.levels.INFO)
  end

  local opts = { buffer = bufnr, noremap = true, silent = true }

  vim.keymap.set('n', 'gh', '<cmd>Telescope lsp_document_symbols<CR>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
  vim.keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references include_current_line=true<CR>', opts)
  vim.keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.keymap.set('n', 'gc', '<cmd>Telescope lsp_incoming_calls<CR>', opts)
  vim.keymap.set('n', '<leader>gc', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
  vim.keymap.set('n', 'gl', '<cmd>Telescope diagnostics<CR>', opts)
  vim.keymap.set('n', '<leader>k', function()
    vim.lsp.buf.hover {
      border = 'rounded',
    }
  end, { buffer = bufnr, silent = true })
  vim.keymap.set('n', 'gs', function()
    vim.lsp.buf.signature_help {
      border = 'rounded',
    }
  end, { buffer = bufnr, silent = true })
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump {
      count = -1,
    }
  end, { buffer = bufnr, silent = true })
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump {
      count = 1,
    }
  end, { buffer = bufnr, silent = true })

  vim.keymap.set('n', '<leader>H', function()
    local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
    local next_enabled = not enabled
    vim.lsp.inlay_hint.enable(next_enabled, { bufnr = bufnr })
    notify_toggle('Inlay hints', next_enabled)
  end, { buffer = bufnr, silent = true, desc = 'Toggle inlay hints' })
  vim.keymap.set('n', '<leader>C', function()
    local enabled = vim.lsp.codelens.is_enabled { bufnr = bufnr }
    local next_enabled = not enabled
    vim.lsp.codelens.enable(next_enabled, { bufnr = bufnr })
    notify_toggle('Code lens', next_enabled)
  end, { buffer = bufnr, silent = true, desc = 'Toggle code lens' })
end

local attach_group = vim.api.nvim_create_augroup('native-lsp-attach', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = attach_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local bufnr = args.buf
    normalize_supports_method(client)
    enable_builtin_lsp_features(client, bufnr)

    if not vim.b[bufnr].native_lsp_keymaps then
      set_lsp_keymaps(bufnr)
      vim.b[bufnr].native_lsp_keymaps = true
    end

    if vim.b[bufnr].native_lsp_signature then
      return
    end

    if client:supports_method 'textDocument/signatureHelp' then
      local signature_ok, signature = pcall(require, 'lsp_signature')
      if signature_ok then
        signature.on_attach(client, bufnr)
        vim.b[bufnr].native_lsp_signature = true
      end
    end
  end,
})

-- Setup LSP defaults first, then let mason-lspconfig enable installed servers.
-- Relying on get_installed_servers() is fragile with newer mason-lspconfig
-- because the package registry is initialized asynchronously.
local function setup_lsp()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local blink_ok, blink = pcall(require, 'blink.cmp')
  if blink_ok and blink.get_lsp_capabilities then
    capabilities = blink.get_lsp_capabilities(capabilities, true)
  end

  local default_options = {
    capabilities = capabilities,
  }
  vim.lsp.config('*', default_options)
  masonlspconf.setup()
end

setup_lsp()
