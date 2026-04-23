-- plugins
vim.pack.add({
  { src = "https://github.com/hrsh7th/nvim-cmp",             version = "main" },
  { src = "https://github.com/hrsh7th/cmp-buffer",           version = "main" },
  { src = "https://github.com/hrsh7th/cmp-path",             version = "main" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp",         version = "main" },

  -- LuaSnip (tag v2.* like your lazy config)
  { src = "https://github.com/L3MON4D3/LuaSnip",             version = "master" },

  { src = "https://github.com/saadparwaiz1/cmp_luasnip",     version = "master" },
  { src = "https://github.com/rafamadriz/friendly-snippets", version = "main" },
  { src = "https://github.com/onsails/lspkind.nvim",         version = "master" },
  "https://github.com/zbirenbaum/copilot.lua",
  "https://github.com/zbirenbaum/copilot-cmp",
})

-- Optional: LuaSnip build step equivalent of `build = "make install_jsregexp"`
-- (runs on demand; run :!make install_jsregexp in the LuaSnip directory if you want it)
-- With vim.pack there isn't a standard "post-install build" hook like lazy.nvim,
-- so you either run it manually or add your own install/update hook.

-- lazy-load-ish: configure on InsertEnter
--

require("copilot").setup({ suggestion = { enabled = false }, panel = { enabled = false } })
require("copilot_cmp").setup()

vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("nvim-cmp-pack", { clear = true }),
  once = true,
  callback = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- load vscode-style snippets (friendly-snippets, etc.)
    require("luasnip.loaders.from_vscode")
    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "copilot" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
})
