-- Theme switching commands (Nightfox + Kanagawa)
local themes = {
  "dayfox",
  "nightfox",
}
local current_theme_index = 1

-- Switch to next theme
vim.api.nvim_create_user_command("Theme", function()
  current_theme_index = (current_theme_index % #themes) + 1
  local theme = themes[current_theme_index]
  vim.cmd.colorscheme(theme)
  print("Switched to: " .. theme)
end, {
  desc = "Cycle through themes",
})

-- Switch to specific theme
vim.api.nvim_create_user_command("ThemeSet", function(opts)
  local theme = opts.args
  if theme == "" then
    print("Usage: :ThemeSet <theme>")
    print("Available themes: " .. table.concat(themes, ", "))
    return
  end
  -- Find matching theme (case-insensitive)
  for i, t in ipairs(themes) do
    if t:lower() == theme:lower() then
      current_theme_index = i
      vim.cmd.colorscheme(t)
      print("Switched to: " .. t)
      return
    end
  end
  print("Theme not found. Available: " .. table.concat(themes, ", "))
end, {
  nargs = "?",
  complete = function()
    return themes
  end,
  desc = "Set specific theme",
})

-- List available themes
vim.api.nvim_create_user_command("ThemeList", function()
  print("Available themes:")
  for i, theme in ipairs(themes) do
    local marker = (i == current_theme_index) and " *" or ""
    print("  " .. theme .. marker)
  end
end, {
  desc = "List available themes",
})

-- Key mappings
vim.keymap.set("n", "<leader>fs", "<cmd>Theme<cr>", { desc = "Theme: Switch next" })
vim.keymap.set("n", "<leader>fL", "<cmd>ThemeList<cr>", { desc = "Theme: List themes" })

-- Backward compatibility with old command names
vim.api.nvim_create_user_command("Fox", function()
  vim.cmd("Theme")
end, { desc = "Cycle through themes (alias)" })

vim.api.nvim_create_user_command("FoxSet", function(opts)
  vim.cmd("ThemeSet " .. opts.args)
end, {
  nargs = "?",
  desc = "Set theme (alias)",
})

vim.api.nvim_create_user_command("FoxList", function()
  vim.cmd("ThemeList")
end, { desc = "List themes (alias)" })

return {}
