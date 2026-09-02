vim.pack.add({
  'https://github.com/andymass/vim-matchup',
})

require('match-up').setup({
  treesitter = {
    stopline = 500
  }
})
