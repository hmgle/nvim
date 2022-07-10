local null_ls = require("null-ls")
local sources = {
  -- golang
  null_ls.builtins.formatting.gofumpt,
  null_ls.builtins.formatting.goimports,
  -- null_ls.builtins.formatting.golines,
  -- null_ls.builtins.diagnostics.revive,
  -- null_ls.builtins.diagnostics.golangci_lint,

  -- shell
  null_ls.builtins.formatting.shfmt,
  null_ls.builtins.diagnostics.shellcheck,

  null_ls.builtins.formatting.trim_whitespace.with({
    disabled_filetypes = { "rust" }, -- use rustfmt
  }),
  -- null_ls.builtins.code_actions.gitsigns,
  null_ls.builtins.formatting.prettier.with({
    filetypes = { "html", "css", "yaml", "markdown", "json" },
  }),
}

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      -- apply whatever logic you want (in this example, we'll only use null-ls)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end
end

null_ls.setup({sources = sources, on_attach = on_attach, debug = false})
