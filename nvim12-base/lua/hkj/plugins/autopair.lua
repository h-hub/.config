-- plugins
vim.pack.add({
  { src = "https://github.com/windwp/nvim-autopairs", version = "master" },
  -- dependency (needed for the cmp integration below)
  { src = "https://github.com/hrsh7th/nvim-cmp", version = "main" },
})

-- lazy-load-ish: configure on first InsertEnter
vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("nvim-autopairs-pack", { clear = true }),
  once = true,
  callback = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    })

    -- nvim-cmp integration
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
})
