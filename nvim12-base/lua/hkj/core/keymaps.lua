-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })                   -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })                 -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })                    -- make split windows equal width & height
keymap.set("n", "<leader>sz", function()
    -- Check if we have more than one tab open
    if vim.fn.tabpagenr('$') > 1 then
        vim.cmd("tabclose")
    else
        -- Open current buffer in a new tab
        vim.cmd("tabedit %")
    end
end, { desc = "Toggle maximize (Zoom)" })

keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })               -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })                     --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                 --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Half-page scrolling
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Full-page scrolling (if you use it)
keymap.set("n", "<C-f>", "<C-f>zz")
keymap.set("n", "<C-b>", "<C-b>zz")
vim.opt.scrolloff = 999

-- Keep cursor central when searching
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")


-- Paste over visual selection without losing the current clipboard
keymap.set("x", "<leader>p", [["_dP]])
keymap.set({ "n", "v" }, "<leader>d", [["_d]])
keymap.set({ "n", "v" }, "x", [["_x]])

vim.opt.clipboard = "unnamedplus"

keymap.set("n", "Q", "<nop>")

-- Stay in visual mode while indenting
keymap.set("v", "<", "<gv", { desc = "Indent left and re-select" })
keymap.set("v", ">", ">gv", { desc = "Indent right and re-select" })
