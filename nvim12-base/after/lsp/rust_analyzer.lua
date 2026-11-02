-- rust-analyzer binary comes from mason (see lua/hkj/plugins/lsp/mason.lua).
-- Alternatively `rustup component add rust-analyzer` keeps it in lockstep with
-- the toolchain; whichever is first on PATH wins (mason/bin is prepended).
--
-- cmd / filetypes / root_dir (Cargo workspace via `cargo metadata`) come from
-- nvim-lspconfig's lsp/rust_analyzer.lua; this file is deep-merged on top.

return {
  on_attach = function(client, bufnr)
    -- Inlay hints (types, parameter names, chaining) are rust-analyzer's
    -- headline feature, so turn them on for Rust buffers only.
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        buildScripts = { enable = true },
      },
      procMacro = { enable = true },
      -- Run clippy instead of `cargo check` on save.
      check = { command = "clippy" },
      checkOnSave = true,
      lens = {
        enable = true,
        run = { enable = true },
        debug = { enable = true },
        references = {
          adt = { enable = true },
          method = { enable = true },
          trait = { enable = true },
        },
      },
      inlayHints = {
        chainingHints = { enable = true },
        parameterHints = { enable = true },
        typeHints = { enable = true },
        closureReturnTypeHints = { enable = "with_block" },
        lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
      },
      completion = {
        fullFunctionSignatures = { enable = true },
      },
      diagnostics = {
        enable = true,
        experimental = { enable = true },
      },
    },
  },
}
