vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-neotest/nvim-nio", -- required by nvim-dap-ui
})

vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap-python", opt = true },
  { src = "https://github.com/leoluz/nvim-dap-go",           opt = true },
})

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- Auto open/close the UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({reset = true})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


local is_python_dap_setup = false
-- # required pip install debugpy
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    if is_python_dap_setup then
      return
    end
    vim.cmd.packadd("nvim-dap-python")

    require("dap-python").setup(".venv/bin/python")

    require("dap-python").test_runner = "pytest"

    is_python_dap_setup = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.cmd.packadd("nvim-dap-go")

    -- optional: configure after loading
    require("dap-go").setup()
  end,
})

-- Java: adapter asks jdtls to start a debug session, then connects to the returned port.
-- Requires ~/jdtls-bundles/*.jar to include the java-debug plugin.
local function current_jdtls_client(bufnr)
  local clients = vim.lsp.get_clients({ name = "jdtls", bufnr = bufnr })
  if #clients == 0 then
    clients = vim.lsp.get_clients({ name = "jdtls" })
  end
  return clients[1]
end

local function jdtls_execute_command(command, arguments, callback, bufnr)
  local client = current_jdtls_client(bufnr)
  if not client then
    vim.notify("jdtls is not attached to any buffer", vim.log.levels.ERROR)
    return
  end
  client:request("workspace/executeCommand", {
    command = command,
    arguments = arguments,
  }, callback, bufnr)
end

local function current_java_main_class()
  if vim.bo.filetype ~= "java" then
    vim.notify("Current buffer is not a Java file", vim.log.levels.WARN)
    return nil
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local package_name
  local current_class
  local main_class

  for _, line in ipairs(lines) do
    if not package_name then
      package_name = line:match("^%s*package%s+([%w_%.]+)%s*;")
    end
    local declared_class = line:match("%f[%a]class%s+([%w_]+)")
      or line:match("%f[%a]interface%s+([%w_]+)")
      or line:match("%f[%a]enum%s+([%w_]+)")
      or line:match("%f[%a]record%s+([%w_]+)")
    if declared_class then
      current_class = declared_class
    end
    if line:match("static%s+void%s+main%s*%(") then
      main_class = current_class or vim.fn.expand("%:t:r")
      break
    end
  end

  if not main_class then
    vim.notify("Current Java file has no main method", vim.log.levels.WARN)
    return nil
  end

  if package_name then
    return package_name .. "." .. main_class
  end
  return main_class
end

local function enrich_java_launch_config(config, on_config)
  if config.request ~= "launch" then
    on_config(config)
    return
  end

  local resolved = vim.deepcopy(config)
  resolved.mainClass = resolved.mainClass or current_java_main_class()
  if not resolved.mainClass then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  jdtls_execute_command("vscode.java.resolveMainClass", nil, function(err, main_classes)
    if err then
      vim.notify("Failed to resolve Java main classes: " .. tostring(err.message), vim.log.levels.ERROR)
      return
    end

    if not resolved.projectName and main_classes then
      for _, entry in ipairs(main_classes) do
        if entry.mainClass == resolved.mainClass then
          resolved.projectName = entry.projectName
          break
        end
      end
    end

    jdtls_execute_command("vscode.java.resolveClasspath", {
      resolved.mainClass,
      resolved.projectName or "",
    }, function(classpath_err, paths)
      if classpath_err then
        vim.notify("Failed to resolve Java classpath: " .. tostring(classpath_err.message), vim.log.levels.ERROR)
        return
      end
      if not paths then
        vim.notify("Could not resolve classpath for Java launch", vim.log.levels.WARN)
        return
      end

      resolved.modulePaths = resolved.modulePaths or paths[1] or {}
      resolved.classPaths = resolved.classPaths or vim.tbl_filter(function(path)
        return vim.fn.isdirectory(path) == 1 or vim.fn.filereadable(path) == 1
      end, paths[2] or {})
      on_config(resolved)
    end, bufnr)
  end, bufnr)
end

dap.adapters.java = function(callback)
  jdtls_execute_command("vscode.java.startDebugSession", nil, function(err, port)
    if err then
      vim.notify("Failed to start java debug session: " .. tostring(err.message), vim.log.levels.ERROR)
      return
    end

    callback({
      type = "server",
      host = "127.0.0.1",
      port = port,
      enrich_config = enrich_java_launch_config,
    })
  end)
end

dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Launch current Java class",
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    mainClass = current_java_main_class,
  },
  {
    type = "java",
    request = "attach",
    name = "Attach to remote JVM (5005)",
    hostName = "127.0.0.1",
    port = 5005,
  },
}

-- Keymaps (edit to taste)
vim.keymap.set("n", "<leader>dc", function()
  if vim.bo.filetype == "java" then
    local main_class = current_java_main_class()
    if not main_class then
      return
    end

    local config = vim.deepcopy(dap.configurations.java[1])
    config.mainClass = main_class
    dap.run(config)
    return
  end

  dap.continue()
end, { desc = "DAP start/continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP step over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP step into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP step out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP conditional breakpoint" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL open" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP run last" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI toggle" })
vim.keymap.set('n', '<leader>dR', function()
  require("dapui").open({ reset = true })
end, { desc = "Restore DAP UI Layout" })


vim.keymap.set('n', '<leader>dX', function()
  dapui.open({ layout = 2, reset = true })
  local total_height = vim.opt.lines:get()
  local target_height = math.floor(total_height * 0.5)

  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

    if ft == "dapui_repl" or ft == "dapui_console" then
      vim.api.nvim_win_set_height(win, target_height)
    end
  end
end, { desc = "Make Debug Console 50% height" })
