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
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


local is_python_dap_setup = false
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
