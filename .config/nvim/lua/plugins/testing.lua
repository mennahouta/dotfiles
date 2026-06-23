-- Simple testing for Nx monorepo
return {
  -- vim-test for running tests
  {
    "vim-test/vim-test",
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#javascript#runner"] = "jest"

      -- Key mappings
      vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<cr>", { desc = "Test: Nearest" })
      vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<cr>", { desc = "Test: File" })
      vim.keymap.set("n", "<leader>ta", "<cmd>TestSuite<cr>", { desc = "Test: All" })
      vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>", { desc = "Test: Last" })
    end,
  },

  -- Custom Nx test commands
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>xt",
        function()
          local file = vim.fn.expand("%:p")
          local project = file:match("/apps/([^/]+)/") or file:match("/libs/([^/]+)/")
          if project then
            vim.cmd(string.format("term pnpm nx test %s -- %s", project, file))
          else
            print("Could not detect project name from: " .. file)
          end
        end,
        desc = "Nx: Test current file",
      },
      {
        "<leader>xn",
        function()
          local file = vim.fn.expand("%:p")
          local project = file:match("/apps/([^/]+)/") or file:match("/libs/([^/]+)/")
          if project then
            vim.cmd("term pnpm nx test " .. project .. " -- " .. file)
          else
            print("Could not detect project name from: " .. file)
          end
        end,
        desc = "Nx: Test nearest (runs file)",
      },
    },
  },
}
