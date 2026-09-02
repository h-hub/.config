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
  ensure_installed = {
    "basedpyright",
    "lua_ls",
    "gopls",
    "bashls",
    "tombi",
    "vtsls",               -- High-performance TypeScript/JavaScript (replaces ts_ls)
    "html",                -- HTML
    "cssls",               -- CSS/SCSS/Less
    "tailwindcss",         -- Tailwind CSS (if applicable)
    "eslint",              -- Linting for JS/TS/React
    "emmet_language_server", -- Fast HTML/JSX expansion (optional but recommended)
    "clangd"
  },
})
