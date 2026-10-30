vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

local harpoon = require("harpoon")

-- Upstream only restores the stored row/col when select() has to create the
-- buffer, so jumping to an already-open file leaves the cursor wherever it was.
-- Wrap the default select and put the cursor back on every jump.
local default_select = require("harpoon.config").get_default_config().default.select

local function restore_position(row, col)
  local lines = vim.api.nvim_buf_line_count(0)
  row = math.min(math.max(row or 1, 1), lines)
  local text = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
  col = math.min(math.max(col or 0, 0), #text)

  vim.api.nvim_win_set_cursor(0, { row, col })
end

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
  default = {
    -- A mark is a pin, not a bookmark that trails after the cursor. Upstream's
    -- BufLeave handler rewrites context to the live cursor every time you
    -- leave the buffer -- including when a picker merely steals focus -- so
    -- the line you marked never survived long enough to be jumped back to.
    -- Drop it entirely: only <leader>a sets a position. "Back where I was"
    -- belongs to `"` and the recent-files pickers, not to harpoon.
    BufLeave = function() end,

    select = function(list_item, list, options)
      local ctx = list_item and list_item.context or {}
      local row, col = ctx.row, ctx.col

      default_select(list_item, list, options)
      if list_item ~= nil then
        restore_position(row, col)
      end
    end,
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

-- remove() clears a slot in place rather than shifting, so the list is sparse:
-- the quick menu renders each hole as a blank line and ipairs() stops at the
-- first one. Squash the gaps before anything reads the list, so what you see
-- numbered in the menu is also what <leader>1..5 address.
local function compact(list)
  local items = {}

  for idx = 1, list:length() do
    local item = list.items[idx]
    if item ~= nil then
      table.insert(items, item)
    end
  end

  list.items = items
  list._length = #items

  return list
end

-- add() ignores a file already in the list, so with pinned marks there would
-- otherwise be no way to move one. Re-marking overwrites the stored position.
keymap.set("n", "<leader>a", function()
  local list = harpoon:list()
  local item = list.config.create_list_item(list.config)
  local existing = list:get_by_value(item.value)

  if existing then
    existing.context = item.context
    vim.notify(
      string.format("Harpoon: re-marked %s:%d", item.value, item.context.row)
    )
  else
    list:add(item)
  end
end, { desc = "Harpoon: mark current file and line" })

keymap.set("n", "<C-e>", function()
  focus_editor_win()
  harpoon.ui:toggle_quick_menu(compact(harpoon:list()))
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

-- telescope picker over the harpoon list. Selecting goes back through
-- list:select() so the mark's row/col is honoured, same as <leader>1..5.
keymap.set("n", "<leader>fh", function()
  local ok, conf = pcall(function()
    return require("telescope.config").values
  end)
  if not ok then
    harpoon.ui:toggle_quick_menu(compact(harpoon:list()))
    return
  end

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local list = compact(harpoon:list())

  local entries = {}
  for idx, item in ipairs(list.items) do
    table.insert(entries, { idx = idx, item = item })
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = entries,
        entry_maker = function(entry)
          local ctx = entry.item.context or {}
          local row = ctx.row or 1
          return {
            value = entry,
            display = string.format(
              "%d. %s:%d",
              entry.idx,
              entry.item.value,
              row
            ),
            ordinal = entry.item.value,
            path = entry.item.value,
            filename = entry.item.value,
            lnum = row,
            col = (ctx.col or 0) + 1,
          }
        end,
      }),
      previewer = conf.grep_previewer({}),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            focus_editor_win()
            list:select(selection.value.idx)
          end
        end)
        return true
      end,
    })
    :find()
end, { desc = "Harpoon: find marked files (telescope)" })
