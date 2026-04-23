vim.pack.add({
  {
    src = "https://github.com/kylechui/nvim-surround",
    version = "main"-- latest tag (stable)
  },
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("nvim-surround-pack", { clear = true }),
  once = true,
  callback = function()
    require("nvim-surround").setup({})
  end,
})
