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

local is_js_dap_setup = false
-- JS/TS: vscode-js-debug's DAP server, installed to ~/.local/share/js-debug via
--   curl -sL https://github.com/microsoft/vscode-js-debug/releases/download/v1.140.0/js-debug-dap-v1.140.0.tar.gz \
--     | tar xz -C ~/.local/share/js-debug --strip-components=1
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  callback = function()
    if is_js_dap_setup then
      return
    end

    local js_debug = vim.fn.expand("~/.local/share/js-debug/src/dapDebugServer.js")
    if vim.fn.filereadable(js_debug) == 0 then
      vim.notify("js-debug not found at " .. js_debug, vim.log.levels.WARN)
      return
    end

    -- js-debug reports the real failure (dead attach target, spawn error) on
    -- its stderr and then exits 0 — and nvim-dap deletes the adapter stderr log
    -- on a zero exit (session.lua: `if code == 0 then stderrlog:remove()`), so
    -- the cause is destroyed and all you get is "Debug adapter disconnected".
    -- Keep our own copy, outside nvim-dap's control.
    local stderr_log = vim.fn.stdpath("cache") .. "/js-debug-stderr.log"

    -- Probe a TCP port so an attach can fail with a useful message instead of
    -- the adapter dying silently. Async: enrich_config is callback-based.
    local function probe(host, port, cb)
      local uv = vim.uv or vim.loop
      local sock, timer, done = uv.new_tcp(), uv.new_timer(), false
      local function finish(ok)
        if done then
          return
        end
        done = true
        timer:stop()
        timer:close()
        sock:close()
        cb(ok)
      end
      timer:start(700, 0, function()
        finish(false)
      end)
      sock:connect(host, port, function(err)
        finish(err == nil)
      end)
    end

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "127.0.0.1",
      port = "${port}",
      -- `exec` keeps the PID nvim-dap spawned, so it can still kill the adapter.
      -- ${port} is substituted in every executable arg (session.lua:1469).
      executable = {
        command = "sh",
        args = {
          "-c",
          ('exec node %s "$@" 2>>%s'):format(vim.fn.shellescape(js_debug), vim.fn.shellescape(stderr_log)),
          "sh",
          "${port}",
        },
      },
      -- An attach to a port nothing is listening on makes js-debug log
      -- "Could not find any debuggable target" to stderr, never answer the
      -- attach request, and close the socket — which surfaces as the useless
      -- pair "Debug adapter disconnected" / "Debug adapter didn't respond".
      -- Catch it before the session starts.
      enrich_config = function(config, on_config)
        if config.request ~= "attach" then
          on_config(config)
          return
        end
        local host = config.address or config.host or "127.0.0.1"
        local port = tonumber(config.port) or 9229
        probe(host, port, function(ok)
          vim.schedule(function()
            if ok then
              on_config(config)
            else
              vim.notify(
                ("Nothing is listening on %s:%d — start the process with --inspect-brk first, e.g.\n"):format(host, port)
                  .. "  node --inspect-brk --import tsx src/handlers/<handler>.ts\n"
                  .. "  npx vitest --inspect-brk --no-file-parallelism --project unit <file>",
                vim.log.levels.ERROR
              )
            end
          end)
        end)
      end,
    }
    -- A .vscode/launch.json written for VS Code says `"type": "node"`, which
    -- nvim-dap looks up verbatim. Without this alias dap.ext.vscode reports
    -- "Config references missing adapter `node`".
    dap.adapters.node = dap.adapters["pwa-node"]

    -- Fallback when a project has no launch.json: attach to --inspect-brk.
    local attach = {
      type = "pwa-node",
      request = "attach",
      name = "Attach to :9229",
      address = "127.0.0.1",
      port = 9229,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      -- tsx transforms through a loader, so its inline maps can land in paths
      -- js-debug excludes by default. Without this, breakpoints silently fail
      -- to bind instead of erroring.
      resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**/*.map" },
      skipFiles = { "<node_internals>/**" },
    }
    for _, ft in ipairs({ "typescript", "javascript" }) do
      dap.configurations[ft] = { attach }
    end

    -- A project's .vscode/launch.json is picked up automatically on-demand by
    -- nvim-dap (:help dap-providers), so there is no load_launchjs call here —
    -- it is deprecated and warns. Registering the adapters above is all that
    -- launch.json needs; its configs merge with the fallback below.

    is_js_dap_setup = true
  end,
})

-- Java: adapter asks jdtls to start a debug session, then connects to the returned port.
-- Requires ~/.config/jdtls/bundles/*.jar to include the java-debug plugin.
dap.adapters.java = function(callback)
  local clients = vim.lsp.get_clients({ name = "jdtls" })
  if #clients == 0 then
    vim.notify("jdtls is not attached to any buffer", vim.log.levels.ERROR)
    return
  end
  clients[1]:request("workspace/executeCommand", {
    command = "vscode.java.startDebugSession",
  }, function(err, port)
    if err then
      vim.notify("Failed to start java debug session: " .. tostring(err.message), vim.log.levels.ERROR)
      return
    end
    callback({ type = "server", host = "127.0.0.1", port = port })
  end)
end

dap.configurations.java = {
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
  require("dap").continue()
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
