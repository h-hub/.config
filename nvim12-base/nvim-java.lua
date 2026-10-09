-- Per-machine Java toolchain paths for jdtls (loaded by after/lsp/jdtls.lua).
-- Edit paths as needed on each machine.

return {
  -- First entry is the JDK jdtls itself runs on (must be >= Java 21).
  -- Every entry is exposed to projects; jdtls matches `name` to the project's
  -- declared Java version (JavaSE-1.8 / -11 / -17 / -21 / -25 / ...).
  jdks = {
    { name = "JavaSE-25", path = "/Users/harshajayamanna/.sdkman/candidates/java/25.0.1-amzn" },
    { name = "JavaSE-21", path = "/Users/harshajayamanna/.sdkman/candidates/java/21.0.6-amzn" },
    { name = "JavaSE-17", path = "/Users/harshajayamanna/.sdkman/candidates/java/17.0.14-amzn" },
    { name = "JavaSE-1.8", path = "/Users/harshajayamanna/.sdkman/candidates/java/8.0.452-amzn" },
  },

  -- lombok = vim.fn.expand("~/lombok-1.18.44.jar"),

  bundles_dir = vim.fn.expand("~/jdtls-bundles"),
  -- bundles     = {},
}
