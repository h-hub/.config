vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/rose-pine/neovim",
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" }
})

local bg = "#011628"
local bg_dark = "#011423"
local bg_highlight = "#143652"
local bg_search = "#0A64AC"
local bg_visual = "#275378"
local fg = "#CBE0F0"
local fg_dark = "#B4D0E9"
local fg_gutter = "#627E97"
local border = "#547998"

-- Tokyo Night Setup
require("tokyonight").setup({
  style = "night",
  on_colors = function(colors)
    colors.bg = bg
    colors.bg_dark = bg_dark
    colors.bg_float = bg_dark
    colors.bg_highlight = bg_highlight
    colors.bg_popup = bg_dark
    colors.bg_search = bg_search
    colors.bg_sidebar = bg_dark
    colors.bg_statusline = bg_dark
    colors.bg_visual = bg_visual
    colors.border = border
    colors.fg = fg
    colors.fg_dark = fg_dark
    colors.fg_float = fg
    colors.fg_gutter = fg_gutter
    colors.fg_sidebar = fg_dark
  end,
})

-- Rose Pine Setup
require("rose-pine").setup({
  variant = "main", -- main, moon, or dawn
  dark_variant = "main",
  styles = {
    italic = true,
    transparency = false,
  },
  highlight_groups = {
    -- Your custom Visual highlight
    -- "iris" or "gold" work great for contrast in Rose Pine
    Visual = { fg = "#000000", bg = "#BFF5F0", inherit = false },

    -- The other objects you mentioned
    Comment = { fg = "foam", italic = true },
    StatusLine = { fg = "love", bg = "love", blend = 15 },
    VertSplit = { fg = "muted", bg = "muted" },
  },
})


require("catppuccin").setup({
    flavour = "mocha", -- Force mocha
    custom_highlights = function(colors)
        return {
            Visual = { bg = colors.surface2, style = { "bold" } }, -- Custom visual selection
            LineNr = { fg = colors.overlay0 }, -- Subtle line numbers
        }
    end,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
    },
})

-- 3. Load the colorscheme
-- Swap these lines to change your look:
-- vim.cmd([[colorscheme tokyonight]])
vim.cmd([[colorscheme rose-pine]])

local prog_lang_theme = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    if prog_lang_theme then
      return
    end
    vim.cmd([[colorscheme tokyonight]])
    prog_lang_theme = true
  end,
})



vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    if prog_lang_theme then
      return
    end
    vim.cmd([[colorscheme rose-pine]])
    prog_lang_theme = true
  end,
})



vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    if prog_lang_theme then
      return
    end
    vim.cmd([[colorscheme catppuccin]])
    prog_lang_theme = true
  end,
})
