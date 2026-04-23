-- plugins
vim.pack.add({
  { src = "https://github.com/numToStr/Comment.nvim", version = "master" },
  { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring", version = "main" },
})

-- lazy-load-ish: configure on BufReadPre/BufNewFile
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("comment-pack", { clear = true }),
  once = true,
  callback = function()
    local comment = require("Comment")
    local ts_integration =
      require("ts_context_commentstring.integrations.comment_nvim")

    comment.setup({
      -- lets TS pick the right comment string for embedded languages (tsx/jsx/svelte/html, etc.)
      pre_hook = ts_integration.create_pre_hook(),
    })
  end,
})
