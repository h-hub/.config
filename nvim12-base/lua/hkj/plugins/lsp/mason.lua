vim.pack.add({
  { src = "https://github.com/williamboman/mason.nvim",           version = "main" },
  { src = "https://github.com/neovim/nvim-lspconfig",             version = "master" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim", version = "main" },
})

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_lspconfig.setup({
  -- ensure_installed = { "pyright", "lua_ls", "gopls", "bashls", "jdtls" },
  ensure_installed = { "basedpyright", "lua_ls", "gopls", "bashls", "isort" },
})
