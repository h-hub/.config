-- nvim-treesitter via vim.pack (Neovim 0.12+)
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main"
  },
  {
    src = "https://github.com/windwp/nvim-ts-autotag",
    version = "main"
  },
})

-- (Optional) If you want the TSUpdate behavior on install/update:
pcall(vim.cmd, "TSUpdate")

require("nvim-ts-autotag").setup({})

-- Configure
local treesitter = require("nvim-treesitter")

treesitter.install({
  "json",
  "javascript",
  "typescript",
  "tsx",
  "yaml",
  "markdown",
  "markdown_inline",
  "bash",
  "lua",
  "vim",
  "gitignore",
  "vimdoc",
  "python",
  "go",
  "java",
})

treesitter.setup({
  highlight = { enable = true },
  indent = { enable = true },

  autotag = { enable = true },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})


local SKIP_FT = {
  [""] = true,
  qf = true,
  help = true,
  man = true,
  noice = true,
  notify = true,
  snacks_notif = true,
  snacks_notif_history = true,
  snacks_picker_list = true,
  snacks_picker_input = true,
  snacks_input = true,
  snacks_terminal = true,
  dapui_scopes = true,
  dapui_breakpoints = true,
  dapui_stacks = true,
  dapui_watches = true,
  dapui_console = true,
  dap_repl = true,
  gitcommit = true,
  gitrebase = true,
  lazy = true,
  lspinfo = true,
  checkhealth = true,
  startuptime = true,
  TelescopePrompt = true,
  TelescopeResults = true,
  spectre_panel = true,
  ["grug-far"] = true,
  trouble = true,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function()
    local ft = vim.bo.filetype
    if SKIP_FT[ft] then
      return
    end

    local ok = pcall(vim.treesitter.start)
    if not ok then
      return
    end

    -- Only set expr folds when treesitter successfully started
    -- vim.wo[0].foldmethod = "expr"
    -- vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
