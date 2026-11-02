return {
  "stevearc/conform.nvim",
  opts = {
    -- Define your formatters by file type
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      python = { "isort", "black" },
    },
    -- Set up format on save
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback", -- Use LSP if no dedicated formatter is found
    },
  },
}
