return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {     -- Changed from 'python'
      analysis = {
        indexing = true, -- Add this line! It is the secret sauce for code actions
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard", -- Optional: basedpyright is 'all' by default (very loud)
      },
    },
    -- Some versions of the LSP still look here for the interpreter
    python = {
      pythonPath = ".venv/bin/python",
    },
  },
}
