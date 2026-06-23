-- Snacks is now the single package for file finding, fuzzy (fzf-style)
-- matching, live-grep search, and the file explorer. The telescope and
-- neo-tree extras have been removed from lazyvim.json so snacks is the default.

-- Wide vertical layout: the list spans most of the screen width with the
-- preview moved below it, so long monorepo paths show in full instead of
-- being center-truncated to "apps/…/src".
local wide_vertical = {
  layout = {
    backdrop = false,
    width = 0.9,
    min_width = 100,
    height = 0.85,
    box = "vertical",
    border = "rounded",
    title = "{title} {live} {flags}",
    title_pos = "center",
    { win = "input", height = 1, border = "bottom" },
    { win = "list", border = "none" },
    { win = "preview", title = "{preview}", height = 0.4, border = "top" },
  },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          -- Full paths for the file finders via the wide layout above
          files = { layout = wide_vertical },
          git_files = { layout = wide_vertical },
          smart = { layout = wide_vertical },
          -- Search/grep: wide layout for full paths + include hidden files
          grep = { layout = wide_vertical, hidden = true },
          grep_word = { layout = wide_vertical, hidden = true },
          grep_buffers = { layout = wide_vertical, hidden = true },
          -- Explorer floats (centered) instead of docking as a left sidebar,
          -- so it doesn't fight no-neck-pain's centering (no padding gap).
          explorer = {
            hidden = true, -- always show dotfiles
            ignored = true, -- always show gitignored files
            jump = { close = true }, -- close the float when a file is opened
            layout = {
              preset = "vertical",
              preview = true,
              layout = { width = 0.4, height = 0.9 },
            },
          },
        },
      },
    },
  },
}
