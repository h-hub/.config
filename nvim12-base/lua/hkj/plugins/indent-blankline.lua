vim.pack.add({
  {
    src = "https://github.com/lukas-reineke/indent-blankline.nvim",
    version = "master", -- or "main" if you prefer, but this repo typically uses master
  },
})

-- lazy-load-ish: only configure when a buffer is read/created
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("indent-blankline-pack", { clear = true }),
  callback = function()
    -- indent-blankline v3 uses the "ibl" module
    require("ibl").setup({
      indent = { char = "┊" },
    })
  end,
})
