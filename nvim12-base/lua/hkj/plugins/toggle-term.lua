vim.pack.add({
  "https://github.com/akinsho/toggleterm.nvim",
})

require("toggleterm").setup({
  -- always open at the bottom as a split
  direction = "horizontal",

  -- fixed height (rows) for horizontal terminals
  size = 15,

  -- optional but commonly useful
  close_on_exit = false,
  shade_terminals = true,
})

-- Multiple dedicated bottom terminals
local Terminal = require("toggleterm.terminal").Terminal

local term1 = Terminal:new({ direction = "horizontal", size = 15, count = 1 })
local term2 = Terminal:new({ direction = "horizontal", size = 15, count = 2 })
local term3 = Terminal:new({ direction = "horizontal", size = 15, count = 3 })

vim.keymap.set("n", "<leader>t1", function() term1:toggle() end, { desc = "Terminal 1 (bottom)" })
vim.keymap.set("n", "<leader>tt", function() term1:toggle() end, { desc = "Terminal 1 (bottom)" })
vim.keymap.set("n", "<leader>t2", function() term2:toggle() end, { desc = "Terminal 2 (bottom)" })
vim.keymap.set("n", "<leader>t3", function() term3:toggle() end, { desc = "Terminal 3 (bottom)" })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    local opts = { buffer = true, silent = true }

    -- Leave terminal and move to adjacent window
    vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
    vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
    vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
    vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)

    -- Escape terminal-mode back to Normal mode
    vim.keymap.set("t", "jk", "<C-\\><C-n>", { buffer = true, silent = true })

    -- Optional: also allow "jk" to escape (common habit)
    -- vim.keymap.set("t", "jk", "<C-\\><C-n>", opts)
  end,
})

local function toggle_all_terminals()
  local Terminal = require("toggleterm.terminal")
  local terms = Terminal.get_all()

  -- Snapshot open terminals first (layout will change as we toggle)
  local open_terms = {}
  for _, term in pairs(terms) do
    if term:is_open() then
      table.insert(open_terms, term)
    end
  end

  if #open_terms > 0 then
    -- close all currently-open terminals
    for _, term in ipairs(open_terms) do
      term:close()
    end
  else
    -- none open => open all existing terminals
    for _, term in pairs(terms) do
      term:open()
    end
  end
end

vim.keymap.set("n", "<leader>ta", toggle_all_terminals, { desc = "Toggle all terminals" })

vim.keymap.set("n", "<leader>ta", toggle_all_terminals, { desc = "Toggle all terminals" })


local function reset_terminal_layouts()
  local terms = require("toggleterm.terminal").get_all()
  for _, term in pairs(terms) do
    if term:is_open() then
      term:close()
      -- Re-open with the explicit size of 15
      term:open(15, "horizontal")
    end
  end
end

-- Keymap to trigger the reset
vim.keymap.set("n", "<leader>tR", reset_terminal_layouts, { desc = "Reset Terminal Layouts" })
