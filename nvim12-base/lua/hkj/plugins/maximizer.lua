
vim.pack.add({
  "https://github.com/szw/vim-maximizer",
})

-- vim-maximizer is a Vimscript plugin; it doesn't expose `require("vim-maximizer")`.
-- Just map the command it defines:
vim.keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", {
  desc = "Maximize/minimize a split",
  silent = true,
})
