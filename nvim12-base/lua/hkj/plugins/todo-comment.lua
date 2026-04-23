vim.pack.add({
  { src = "https://github.com/folke/todo-comments.nvim", version = "main" },
  { src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("todo-comments-pack", { clear = true }),
  once = true,
  callback = function()
    local todo_comments = require("todo-comments")

    vim.keymap.set("n", "]t", function()
      todo_comments.jump_next()
    end, { desc = "Next todo comment" })

    vim.keymap.set("n", "[t", function()
      todo_comments.jump_prev()
    end, { desc = "Previous todo comment" })

    todo_comments.setup()
  end,
})
