vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-telescope/telescope.nvim",           version = "master" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" }
})

local fzf_dir = vim.fn.stdpath("data")
    .. "/site/pack/core/opt/telescope-fzf-native.nvim"

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Build telescope-fzf-native.nvim after vim.pack changes",
  callback = function(ev)
    local name = (ev.spec and (ev.spec.name or ev.spec.src)) or ev.name or ""

    if type(name) == "string" and name:find("telescope%-fzf%-native") then
      vim.notify("Building telescope-fzf-native.nvim (make)...", vim.log.levels.INFO)

      vim.system({ "make" }, { cwd = fzf_dir }, function(res)
        if res.code == 0 then
          vim.schedule(function()
            vim.notify("Built telescope-fzf-native.nvim successfully", vim.log.levels.INFO)
          end)
        else
          vim.schedule(function()
            vim.notify(
              ("Build failed for telescope-fzf-native.nvim (exit %s)\n%s"):format(
                tostring(res.code),
                res.stderr or ""
              ),
              vim.log.levels.ERROR
            )
          end)
        end
      end)
    end
  end,
})

-- Configure Telescope
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    path_display = { "smart" },
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
    get_selection_window = function()
      local wins = vim.api.nvim_list_wins()
      table.insert(wins, 1, vim.api.nvim_get_current_win())
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "" then
          return win
        end
      end
      return 0
    end,
  },
})

-- Don't hard-error if build hasn't happened yet
pcall(telescope.load_extension, "fzf")

-- Keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List open buffers" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_status<cr>", { desc = "Git diff preview" })
