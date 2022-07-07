vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})


require('config.lsp.providers')

-- try to import lspconfig
local lspconfig = require("lspconfig")
if not lspconfig then
  return
end

local lspinstaller = require("nvim-lsp-installer")
if not lspinstaller then
  return
end

-- do something on lsp attach
local function on_attach(client, bufnr)
  -- set mappings only in current buffer with lsp enabled
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  -- set options only in current buffer with lsp enabled
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local opts = { noremap = true, silent = true }

  buf_set_keymap("n", "gh", "<cmd>Telescope lsp_document_symbols<CR>", opts)
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  buf_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  buf_set_keymap("n", "<leader>gf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action({apply = true})<CR>", opts)
  buf_set_keymap("v", "<leader>ca", "<cmd>vim.lsp.buf.range_code_action()<CR>", opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

  buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "gc", "<cmd>Telescope lsp_incoming_calls<CR>", opts)
  buf_set_keymap("n", "<leader>gc", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)

  buf_set_keymap("n", "gl", "<cmd>Telescope diagnostics<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

  require 'illuminate'.on_attach(client)
end

-- Setup lspconfig.
local function setup_lsp()
  local installed_servers = lspinstaller.get_installed_servers()
  -- don't setup servers if atleast one server is installed, or it will throw an error
  if #installed_servers == 0 then return end

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  local default_options = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  for _, server in ipairs(installed_servers) do
    local lsp_options = default_options

    -- for lua
    if server.name == "sumneko_lua" then
      lsp_options.settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the 'vim', 'use' global
            globals = {'vim', 'use', 'require'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {enable = false},
        },
      }
    end

    -- for clangd (c/c++)
    -- [https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428]
    if server.name == "clangd" then
      capabilities.offsetEncoding = { "utf-16" }
      lsp_options.capabilities = capabilities
    end

    -- for gopls (go)
    if server.name == "gopls" then
      lsp_options.cmd = { 'gopls', '-remote=auto' }
    end

    lspconfig[server.name].setup(lsp_options)
  end
end

setup_lsp()
