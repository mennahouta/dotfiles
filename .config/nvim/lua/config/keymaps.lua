-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Find files including hidden files (dotfiles like .env.example)
vim.keymap.set("n", "<leader>fF", function()
  Snacks.picker.files({ hidden = true })
end, { desc = "Find files (including hidden)" })

-- Copy relative path of current file to system clipboard
vim.keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path" })
