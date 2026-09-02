-- jdtls binary comes from mason (see lua/hkj/plugins/lsp/mason.lua).
-- Machine-specific paths (JDK list, lombok, DAP/test bundles) live in
-- nvim-java.lua at the root of this config dir. First entry of `jdks` is the
-- JDK jdtls itself runs on.

local java = dofile(vim.fn.stdpath("config") .. "/nvim-java.lua")

local workspace = vim.fn.expand("~/.cache/jdtls/workspace/")
  .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" }
if java.lombok then
  table.insert(cmd, "--jvm-arg=-javaagent:" .. java.lombok)
end
vim.list_extend(cmd, { "-data", workspace })

local bundles = java.bundles or {}
if java.bundles_dir then
  vim.list_extend(bundles, vim.fn.glob(java.bundles_dir .. "/*.jar", true, true))
end

return {
  cmd = cmd,
  filetypes = { "java" },
  root_markers = {
    "gradlew", "mvnw", "pom.xml",
    "build.gradle", "build.gradle.kts",
    "settings.gradle", "settings.gradle.kts",
    ".git",
  },
  init_options = { bundles = bundles },
  settings = {
    java = {
      home = java.jdks[1].path,
      configuration = { runtimes = java.jdks },
      eclipse = { downloadSources = true },
      maven   = { downloadSources = true },
      referencesCodeLens      = { enabled = true },
      implementationsCodeLens = { enabled = true },
      signatureHelp = { enabled = true },
      format        = { enabled = true },
    },
  },
}
