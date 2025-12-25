local conform = require 'conform'

conform.setup {
  formatters = {
    ['biome-json'] = {
      command = 'biome',
      args = {
        'format',
        '--indent-style=space',
        '--indent-width=2',
        '--json-parse-allow-trailing-commas=true',
        '--stdin-file-path',
        '$FILENAME',
      },
    },
  },
  formatters_by_ft = {
    javascript = { 'biome', 'prettier', stop_after_first = true },
    typescript = { 'biome', 'prettier', stop_after_first = true },
    javascriptreact = { 'biome', 'prettier', stop_after_first = true },
    typescriptreact = { 'biome', 'prettier', stop_after_first = true },
    svelte = { 'prettier' },
    css = { 'biome', 'prettier', stop_after_first = true },
    html = { 'biome', 'prettier', stop_after_first = true },
    json = { 'biome-json', 'prettier', stop_after_first = true },
    jsonc = { 'biome-json', 'prettier', stop_after_first = true },
    yaml = { 'yamlfix', 'prettier', stop_after_first = true },
    markdown = { 'markdownlint', 'prettier' },
    graphql = { 'prettier' },
    liquid = { 'prettier' },
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    sh = { 'shfmt' },
    rust = { 'rustfmt' },
    go = { 'goimports', 'gofumpt' },
    c = { 'trim_whitespace', 'trim_newlines' }, -- didn't want LSP formatting on C
    cpp = { 'trim_whitespace', 'trim_newlines' }, -- didn't want LSP formatting on CPP
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 3000,
  },
}
