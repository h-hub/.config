-- Per-machine Java toolchain paths for jdtls (loaded by after/lsp/jdtls.lua).
-- Edit paths as needed on each machine.

return {
  -- First entry is the JDK jdtls itself runs on (must be >= Java 21).
  -- Every entry is exposed to projects; jdtls matches `name` to the project's
  -- declared Java version (JavaSE-1.8 / -11 / -17 / -21 / -25 / ...).
  jdks = {
    { name = "JavaSE-25", path = "/Users/2279450/codes/jdk/zulu25.32.21-ca-jdk25.0.2-macosx_aarch64" },
  },

  lombok = vim.fn.expand("~/lombok-1.18.44.jar"),

  -- TODO: download java-debug (and optionally java-test), then point bundles_dir at it.
  -- bundles_dir = vim.fn.expand("~/jdtls-bundles"),
  -- bundles     = {},
}
