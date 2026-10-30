-- In-buffer markdown rendering (headings, code blocks, tables, checkboxes).
-- Relies on the markdown / markdown_inline treesitter parsers installed in
-- treesitter.lua and on nvim-web-devicons for code-block language icons.
vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require("render-markdown").setup({
  file_types = { "markdown" },
  -- Keep the rendered view while reading; drop back to raw text when editing
  -- the current line so the source stays visible under the cursor.
  render_modes = { "n", "c", "t" },
  heading = {
    icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
  },
  code = {
    style = "full",
    width = "block",
    left_pad = 1,
    right_pad = 1,
  },
  checkbox = {
    unchecked = { icon = "󰄱 " },
    checked = { icon = "󰱒 " },
  },
  completions = { lsp = { enabled = true } },
  latex = { enabled = false },
})

vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", {
  desc = "Markdown: toggle rendering",
})
