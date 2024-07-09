local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { { "yamlfix", "prettier" } },
    markdown = { "markdownlint", "prettier" },
    graphql = { "prettier" },
    liquid = { "prettier" },
    lua = { "stylua" },
    python = { "isort", "black" },
    sh = { "shfmt" },
    rust = { "rustfmt" },
    go = { "goimports", "gofumpt" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 3000,
  },
})
