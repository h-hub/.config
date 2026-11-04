-- Cargo.toml support: dependency version completion, hover with crate docs,
-- upgrade/update code actions. Runs an in-process LSP so nvim-cmp's nvim_lsp
-- source picks up completions without an extra cmp source. Needs `curl`.
vim.pack.add({ "https://github.com/saecki/crates.nvim" })

local crates = require("crates")

crates.setup({
  lsp = {
    enabled = true,
    actions = true,
    completion = true,
    hover = true,
    on_attach = function(_, bufnr)
      local opts = { buffer = bufnr, silent = true }

      opts.desc = "Crates: toggle versions/features virtual text"
      vim.keymap.set("n", "<leader>crt", crates.toggle, opts)

      opts.desc = "Crates: show versions popup"
      vim.keymap.set("n", "<leader>crv", crates.show_versions_popup, opts)

      opts.desc = "Crates: show features popup"
      vim.keymap.set("n", "<leader>crf", crates.show_features_popup, opts)

      opts.desc = "Crates: show dependencies popup"
      vim.keymap.set("n", "<leader>crd", crates.show_dependencies_popup, opts)

      opts.desc = "Crates: update crate (semver compatible)"
      vim.keymap.set("n", "<leader>cru", crates.update_crate, opts)
      vim.keymap.set("v", "<leader>cru", crates.update_crates, opts)

      opts.desc = "Crates: update all crates"
      vim.keymap.set("n", "<leader>cra", crates.update_all_crates, opts)

      opts.desc = "Crates: upgrade crate (latest)"
      vim.keymap.set("n", "<leader>crU", crates.upgrade_crate, opts)
      vim.keymap.set("v", "<leader>crU", crates.upgrade_crates, opts)

      opts.desc = "Crates: upgrade all crates"
      vim.keymap.set("n", "<leader>crA", crates.upgrade_all_crates, opts)

      opts.desc = "Crates: open docs.rs"
      vim.keymap.set("n", "<leader>crD", crates.open_documentation, opts)

      opts.desc = "Crates: open crates.io"
      vim.keymap.set("n", "<leader>crC", crates.open_crates_io, opts)

      opts.desc = "Crates: open repository"
      vim.keymap.set("n", "<leader>crR", crates.open_repository, opts)
    end,
  },
  completion = {
    crates = { enabled = true },
  },
  popup = {
    autofocus = true,
    border = "rounded",
  },
})
