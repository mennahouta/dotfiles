-- Claude Code integration for Neovim
-- https://github.com/coder/claudecode.nvim
return {
  "coder/claudecode.nvim",
  cmd = { "ClaudeCode", "ClaudeCodeAdd", "ClaudeCodeSend" },
  keys = {
    -- Toggle Claude
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude: Toggle" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude: Focus" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Claude: Resume" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude: Continue" },

    -- Add context
    { "<leader>aa", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "Claude: Add current file" },
    { "<leader>aa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: Send selection" },
  },
}
