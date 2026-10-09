vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
})

require("diffview").setup({
  enhanced_diff_hl = true,
  file_panel = {
    listing_style = "tree",
    win_config = { position = "left", width = 35 },
  },
  keymaps = {
    view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
    file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
    file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
  },
})

-- true while a diffview tab is open
local function is_open()
  local ok, lib = pcall(require, "diffview.lib")
  return ok and lib.get_current_view() ~= nil
end

-- press once to open, again to close
local function toggle(cmd)
  return function()
    if is_open() then
      vim.cmd("DiffviewClose")
    else
      vim.cmd(cmd)
    end
  end
end

-- current buffer
vim.keymap.set("n", "<leader>gd", toggle("DiffviewOpen -- %"), { desc = "Diff current file vs HEAD (toggle)" })
vim.keymap.set("n", "<leader>gh", toggle("DiffviewFileHistory %"), { desc = "History of current file (toggle)" })

-- current buffer against any revision (branch, tag, commit, HEAD~2, ...)
vim.keymap.set("n", "<leader>gD", function()
  if is_open() then
    vim.cmd("DiffviewClose")
    return
  end
  local file = vim.fn.expand("%")
  if file == "" then
    vim.notify("No file in this buffer", vim.log.levels.WARN)
    return
  end
  vim.ui.input({ prompt = "Diff current file against revision: ", default = "HEAD~1" }, function(rev)
    if rev and rev ~= "" then
      vim.cmd(("DiffviewOpen %s -- %s"):format(rev, vim.fn.fnameescape(file)))
    end
  end)
end, { desc = "Diff current file vs revision (prompt)" })

-- whole repo
vim.keymap.set("n", "<leader>gs", toggle("DiffviewOpen"), { desc = "Diff all changed files (toggle)" })
vim.keymap.set("n", "<leader>gH", toggle("DiffviewFileHistory"), { desc = "History of repo (toggle)" })
vim.keymap.set("n", "<leader>gx", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" })
