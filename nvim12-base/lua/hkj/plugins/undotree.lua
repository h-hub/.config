vim.pack.add({ 'https://github.com/mbbill/undotree' })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "undotree",
    callback = function()
        vim.cmd("vertical resize 30")
    end,
})
