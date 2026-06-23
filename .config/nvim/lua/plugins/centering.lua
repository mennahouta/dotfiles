-- Always center opened files horizontally (zen-style padding on both sides).
-- no-neck-pain creates empty scratch buffers left/right to push the file into
-- a centered column. Loaded eagerly and enabled at startup + on each new tab.
return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  lazy = false, -- must load at startup so it can auto-enable
  priority = 100,
  keys = {
    { "<leader>np", "<cmd>NoNeckPain<cr>", desc = "Toggle centered view" },
  },
  opts = {
    width = 120, -- width of the centered content column
    autocmds = {
      enableOnTabEnter = true,
    },
    buffers = {
      -- Keep the side padding buffers plain (no numbers)
      setNames = false,
      left = { enabled = true },
      right = { enabled = true },
    },
  },
  config = function(_, opts)
    require("no-neck-pain").setup(opts)
    -- Enable once after startup so the very first buffer is centered too.
    vim.schedule(function()
      require("no-neck-pain").enable()
    end)
  end,
}
