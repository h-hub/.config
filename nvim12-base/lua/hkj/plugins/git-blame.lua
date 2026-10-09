vim.pack.add({
  { src = "https://github.com/f-person/git-blame.nvim" },
})

require("gitblame").setup({
  enabled = true,
  date_format = "%r",                                  -- "3 days ago"
  message_template = "  <author> · <date> · <summary>", -- virtual text at end of line
  message_when_not_committed = "  Not committed yet",
  highlight_group = "Comment",
  delay = 300,
  max_commit_summary_length = 60,                    -- keep the virtual text short
})

-- <leader>b = blame namespace (free: nothing else maps <leader>b)
vim.keymap.set("n", "<leader>bb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle inline git blame" })
vim.keymap.set("n", "<leader>bo", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "Open commit of current line in browser" })
vim.keymap.set("n", "<leader>bc", "<cmd>GitBlameCopySHA<cr>", { desc = "Copy commit SHA of current line" })
vim.keymap.set("n", "<leader>bu", "<cmd>GitBlameCopyFileURL<cr>", { desc = "Copy remote URL of current file/line" })
