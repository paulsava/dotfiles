vim.g.mapleader = " "

------------------------------------------------------------------
--   Ungrouped, High-Frequency Commands
------------------------------------------------------------------
-- Format file or range
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

-- Undo Tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo Tree" })

-- Replace word under cursor
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace Word" })

------------------------------------------------------------------
-- GROUP: Project
------------------------------------------------------------------
vim.keymap.set("n", "<leader>p", "", { noremap = true, silent = true, desc = "Project" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find File" })
vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Search Project (Grep)" })

------------------------------------------------------------------
-- GROUP: Git
------------------------------------------------------------------
vim.keymap.set("n", "<leader>g", "", { noremap = true, silent = true, desc = "Git" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status" })

------------------------------------------------------------------
-- GROUP: Code
------------------------------------------------------------------
vim.keymap.set("n", "<leader>c", "", { noremap = true, silent = true, desc = "Code" })
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "Code Action" })

------------------------------------------------------------------
-- Harpoon Navigation, etc.
------------------------------------------------------------------
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: Add file" })
vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu, { desc = "Harpoon: Quick menu" })

vim.keymap.set("n", "<leader>1", function()
	ui.nav_file(1)
end, { desc = "Harpoon: Navigate to file 1" })
vim.keymap.set("n", "<leader>2", function()
	ui.nav_file(2)
end, { desc = "Harpoon: Navigate to file 2" })
vim.keymap.set("n", "<leader>3", function()
	ui.nav_file(3)
end, { desc = "Harpoon: Navigate to file 3" })
vim.keymap.set("n", "<leader>4", function()
	ui.nav_file(4)
end, { desc = "Harpoon: Navigate to file 4" })

-- File Explorer
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Explorer" })
