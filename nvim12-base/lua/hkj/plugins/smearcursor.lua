vim.pack.add({
  "https://github.com/sphamba/smear-cursor.nvim",
})

require("smear_cursor").setup({
  cursor_color = "#F54927",

  smear_between_buffers = true,
  smear_between_neighbor_lines = true,
  scroll_buffer_space = true,
  legacy_computing_symbols_support = false,
  smear_insert_mode = true,
})
