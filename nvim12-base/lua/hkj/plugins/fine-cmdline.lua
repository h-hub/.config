vim.pack.add({
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/VonHeikemen/fine-cmdline.nvim" }
})

require('fine-cmdline').setup({
  popup = {
    -- This line makes it global across the whole screen
    relative = 'editor',
    position = {
      row = '10%',
      col = '50%',
    },
    size = {
      width = '60%',
    },
    border = {
      style = 'rounded',
      text = {
        top = ' Command ',
        top_align = 'center',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  },
})

-- Keep your keybinding
vim.keymap.set('n', ':', '<cmd>FineCmdline<CR>', { noremap = true })
