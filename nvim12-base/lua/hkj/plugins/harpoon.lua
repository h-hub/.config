vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

local harpoon = require("harpoon")

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

local keymap = vim.keymap

-- Terminals, nvim-tree, alpha etc. must never end up hosting a file. Hop to a
-- real editor window first, creating one if a terminal is all that's open.
local function focus_editor_win()
  local function is_editor(win)
    return vim.api.nvim_win_get_config(win).relative == ""
      and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == ""
  end

  if is_editor(vim.api.nvim_get_current_win()) then
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_editor(win) then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  vim.cmd("topleft new")
end

keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon: add current file" })

keymap.set("n", "<C-e>", function()
  focus_editor_win()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: toggle quick menu" })

-- jump straight to a marked file
for i = 1, 5 do
  keymap.set("n", "<leader>" .. i, function()
    focus_editor_win()
    harpoon:list():select(i)
  end, { desc = "Harpoon: go to file " .. i })
end

keymap.set("n", "<leader>hp", function()
  focus_editor_win()
  harpoon:list():prev()
end, { desc = "Harpoon: previous file" })

keymap.set("n", "<leader>hn", function()
  focus_editor_win()
  harpoon:list():next()
end, { desc = "Harpoon: next file" })

keymap.set("n", "<leader>hx", function()
  harpoon:list():remove()
end, { desc = "Harpoon: remove current file" })

keymap.set("n", "<leader>hc", function()
  harpoon:list():clear()
end, { desc = "Harpoon: clear list" })

-- telescope picker over the harpoon list
keymap.set("n", "<leader>fh", function()
  local ok, conf = pcall(function()
    return require("telescope.config").values
  end)
  if not ok then
    harpoon.ui:toggle_quick_menu(harpoon:list())
    return
  end

  local files = {}
  for _, item in ipairs(harpoon:list().items) do
    table.insert(files, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({ results = files }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end, { desc = "Harpoon: find marked files (telescope)" })
