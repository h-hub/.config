vim.pack.add({
  { src = "https://github.com/goolord/alpha-nvim" },
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
  "                                                       ",
  "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗                    ",
  "  ████╗  ██║██║   ██║██║████╗ ████║                    ",
  "  ██╔██╗ ██║██║   ██║██║██╔████╔██║                    ",
  "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║                    ",
  "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║                    ",
  "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝                    ",
  "                                   - w3.harsha.codes   ",
  "                                                       ",
  "                                                       ",
  "                                                       ",
}

-- Set menu
dashboard.section.buttons.val = {
  dashboard.button("e", " > New File", "<cmd>ene<CR>"),
  dashboard.button("SPC ee", " > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
  dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
  dashboard.button("SPC fs", " > Find Word", "<cmd>Telescope live_grep<CR>"),
  dashboard.button("SPC wr", "󰁯 > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
  dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
}

dashboard.section.footer.val = {
  " ",
  "📍" .. vim.fn.getcwd(), -- Icon + Path
  " "
}
-- Send config to alpha
alpha.setup(dashboard.opts)

-- put this after you set dashboard.section.header.val and dashboard.section.buttons.val

local function centered_layout()
  local win_h = vim.api.nvim_win_get_height(0)

  -- Estimate how many lines alpha will draw.
  -- header: #lines in your banner
  local header_h = #dashboard.section.header.val

  -- buttons: alpha adds some spacing; this approximation works well
  local button_h = #dashboard.section.buttons.val * 2

  -- extra spacing for header/buttons separators, etc.
  local extra = 4

  local content_h = header_h + button_h + extra
  local top_pad = math.max(0, math.floor((win_h - content_h) / 2))

  dashboard.config.layout = {
    { type = "padding", val = top_pad },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    dashboard.section.footer,
  }
end

centered_layout()

-- keep it centered if you resize the window
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    pcall(centered_layout)
    pcall(require("alpha").redraw)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })
  end,
})
