
-- Must be set before the plugin's plugin/ scripts are sourced, otherwise its
-- own <C-hjkl> defaults are applied at the end of startup and clobber ours.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add({
  "https://github.com/christoomey/vim-tmux-navigator",
})

-- vim-tmux-navigator is a Vimscript plugin; it only defines the Tmux* commands.
-- Map them so <C-hjkl> moves between nvim splits and tmux panes alike:
local maps = {
  { "<C-h>", "TmuxNavigateLeft", "Navigate left (nvim/tmux)" },
  { "<C-j>", "TmuxNavigateDown", "Navigate down (nvim/tmux)" },
  { "<C-k>", "TmuxNavigateUp", "Navigate up (nvim/tmux)" },
  { "<C-l>", "TmuxNavigateRight", "Navigate right (nvim/tmux)" },
  { "<C-\\>", "TmuxNavigatePrevious", "Navigate to previous (nvim/tmux)" },
}

for _, map in ipairs(maps) do
  local key, cmd, desc = map[1], map[2], map[3]
  vim.keymap.set("n", key, "<cmd>" .. cmd .. "<CR>", {
    desc = desc,
    silent = true,
  })
end
