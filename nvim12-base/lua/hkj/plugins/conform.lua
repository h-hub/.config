vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})

vim.keymap.set("n", "<leader>cf", function()
  local ft = vim.bo.filetype

  if ft == "python" then
    conform.format({
      async = true,
      lsp_fallback = true,
    })
    print("Formatted with Conform")
  else
    vim.lsp.buf.format({ async = true })
    print("Formatted with LSP")
  end
end, { desc = "Code [F]ormat (Python: Conform, Others: LSP)" })
