-- pack.lua (or wherever you call vim.pack.add during startup)
vim.pack.add({
  { src = "https://github.com/rmagatti/auto-session" },
})

-- auto-session.lua (your config module)
local auto_session = require("auto-session")

auto_session.setup({
  auto_restore_enabled = false,
  auto_session_suppress_dirs = {
    vim.fn.expand("~/"),
    vim.fn.expand("~/Dev/"),
    vim.fn.expand("~/Downloads"),
    vim.fn.expand("~/Documents"),
    vim.fn.expand("~/Desktop/"),
  },
})

vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
