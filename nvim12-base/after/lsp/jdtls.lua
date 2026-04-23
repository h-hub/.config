-- use this when you can install jdtls via mason
-- return {
--   cmd = { "jdtls" },
--   filetypes = { "java" },
--   root_markers = {
--     "gradlew",
--     "mvnw",
--     "pom.xml",
--     "build.gradle",
--     "build.gradle.kts",
--     "settings.gradle",
--     "settings.gradle.kts",
--     ".git",
--   },
--   settings = {
--     java = {
--       -- This is what :LspJdtlsSetRuntime will update at runtime
--       -- (Set to your default JDK location)
--       home = "/Users/2279450/codes/jdk/zulu25.32.21-ca-jdk25.0.2-macosx_aarch64/",
--
--       configuration = {
--         -- Optional: list known JDK installs so jdtls can pick per-project
--         -- (names are arbitrary, but typically match major versions)
--         runtimes = {
--           {
--             name = "JavaSE-17",
--             path = "/path/to/jdk-17",
--             default = true,
--           },
--           {
--             name = "JavaSE-21",
--             path = "/path/to/jdk-21",
--           },
--         },
--       },
--
--       eclipse = {
--         downloadSources = true,
--       },
--       maven = {
--         downloadSources = true,
--       },
--       referencesCodeLens = {
--         enabled = true,
--       },
--       implementationsCodeLens = {
--         enabled = true,
--       },
--       signatureHelp = { enabled = true },
--
--       -- Common formatting knob (optional)
--       format = {
--         enabled = true,
--       },
--     },
--   }
-- }



-- downloading jdtls manully and starting
--


local jdtls_bin = vim.fn.expand("~/jdt-language-server-1.57.0-202602261110/bin/jdtls")
local lombok_jar = vim.fn.expand("~/lombok-1.18.44.jar")

return {
  -- We call the jdtls script directly and pass the lombok agent via --jvm-arg
  cmd = {
    jdtls_bin,
    "--jvm-arg=-javaagent:" .. lombok_jar
  },
  filetypes = { "java" },
  root_markers = {
    "gradlew",
    "mvnw",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
    ".git",
  },
  settings = {
    java = {
      -- Use your specific Zulu JDK for the server runtime
      home = "/users/2279450/codes/jdk/zulu25.32.21-ca-jdk25.0.2-macosx_aarch64/",

      configuration = {
        runtimes = {
          {
            name = "JavaSE-25",
            path = "/users/2279450/codes/jdk/zulu25.32.21-ca-jdk25.0.2-macosx_aarch64/", -- Update these to real paths if you have them
            default = true,
          },
        },
      },

      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      signatureHelp = { enabled = true },
      format = { enabled = true },
    },
  }
}
--
