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

local function setup_c_cpp_dap()
  local dap = require("dap")
  dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
      command = 'codelldb',
      args = {"--port", "${port}"},
    }
  }

  dap.configurations.c = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        local executable_choices = {}
        local files = vim.fn.glob(vim.fn.getcwd() .. '/*', false, true)
        for _, file in ipairs(files) do
          if vim.fn.executable(file) == 1 and vim.fn.isdirectory(file) == 0 then
            table.insert(executable_choices, file)
          end
        end

        if #executable_choices == 0 then
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        elseif #executable_choices == 1 then
          return executable_choices[1]
        else
          local choice = vim.fn.inputlist({"Select executable to debug:", unpack(executable_choices)})
          if choice > 0 and choice <= #executable_choices then
            return executable_choices[choice]
          else
            return nil
          end
        end
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = true,
    },
  }
  dap.configurations.cpp = dap.configurations.c

end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    local registry = require("mason-registry")
    local codelldb_pkg = registry.get_package("codelldb")
    if not codelldb_pkg:is_installed() then
      vim.api.nvim_notify("Installing codelldb for debugging... Please wait until this is finished.", vim.log.levels.INFO, { title = "nvim-dap" })
      codelldb_pkg:install():on("exit", function()
        vim.api.nvim_notify("codelldb installed successfully.", vim.log.levels.INFO, { title = "nvim-dap" })
        setup_c_cpp_dap()
      end)
    else
      setup_c_cpp_dap()
    end
  end,
})
