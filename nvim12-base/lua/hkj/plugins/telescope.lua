vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-telescope/telescope.nvim",           version = "master" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" }
})

local fzf_dir = vim.fn.stdpath("data")
    .. "/site/pack/core/opt/telescope-fzf-native.nvim"
-- Build fzf-native after pack changes (install/update)
vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Build telescope-fzf-native.nvim after vim.pack changes",
  callback = function(ev)
    -- ev.kind is typically "install"/"update"/etc (varies by Nvim version)
    -- ev.spec (or ev.data) contains the pack spec on some versions
    local name = (ev.spec and (ev.spec.name or ev.spec.src)) or ev.name or ""

    -- Be tolerant across Neovim versions: just pattern-match the repo name.
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
