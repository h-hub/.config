vim.pack.add({
	"https://github.com/folke/which-key.nvim",
})

vim.o.timeout = true
vim.o.timeoutlen = 500

require("which-key").setup({
	preset = "modern",
})
