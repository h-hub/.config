local servers = {
  "basedpyright",
  "lua_ls",
  "gopls",
  "bashls",
  "tombi",
  "vtsls",        -- TypeScript / React
  "html",         -- HTML
  "cssls",        -- CSS
  "tailwindcss",  -- Tailwind
  "eslint",       -- Linting
  "jdtls",        -- Java
}

-- Enable them all
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
