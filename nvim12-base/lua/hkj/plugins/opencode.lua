return {
  event = "VeryLazy",
  config = function()
    local function setup_opencode_keymaps()
      if vim.bo.filetype == 'terminal' then
        local opts = { buffer = true, silent = true, noremap = true }

        vim.keymap.set("n", "j", function() vim.fn.chansend(vim.b.terminal_job_id, "j") end, opts)
        vim.keymap.set("n", "k", function() vim.fn.chansend(vim.b.terminal_job_id, "k") end, opts)
        vim.keymap.set("n", "h", function() vim.fn.chansend(vim.b.terminal_job_id, "h") end, opts)
        vim.keymap.set("n", "l", function() vim.fn.chansend(vim.b.terminal_job_id, "l") end, opts)

        vim.notify("Opencode hjkl keymaps activated for this terminal.", vim.log.levels.INFO)
      else
        vim.notify("This is not a terminal buffer. No keymaps set.", vim.log.levels.WARN)
      end
    end

    vim.api.nvim_create_user_command('OpencodeKeys', setup_opencode_keymaps, {
      nargs = 0,
      desc = "Setup hjkl keymaps for opencode running in the current terminal",
    })
  end,
}

