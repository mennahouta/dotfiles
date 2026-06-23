-- Formatting and linting for NestJS/TypeScript
return {
  -- Conform.nvim for code formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Use Prettier for TypeScript/TSX
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        -- Configure Prettier for NestJS projects
        prettier = {
          condition = function(self, ctx)
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              ".prettierrc.mjs",
            }, { path = ctx.filepath, upward = true })[1]
          end,
        },
        -- Configure ESLint
        eslint_d = {
          condition = function(self, ctx)
            return vim.fs.find({
              "eslint.config.js",
              "eslint.config.mjs",
              ".eslintrc.js",
              ".eslintrc.json",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc",
            }, { path = ctx.filepath, upward = true })[1]
          end,
        },
      },
    },
  },

  -- Configure Linting with nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
      },
      linters = {
        eslint = {
          args = {
            "--format",
            "json",
            "--stdin",
            "--stdin-filename",
            "%:p",
          },
          stdin = true,
        },
      },
    },
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Auto-commands for formatting
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Enable format on save for TypeScript files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
        callback = function()
          local lsp_clients = vim.lsp.get_active_clients({ bufnr = 0 })
          for _, client in ipairs(lsp_clients) do
            if client.supports_method("textDocument/formatting") then
              vim.lsp.buf.format({ timeout_ms = 2000, async = false })
              break
            end
          end
        end,
      })

      return opts
    end,
  },

  -- Add formatting capabilities to LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      capabilities = {
        textDocument = {
          formatting = {
            dynamicRegistration = true,
          },
        },
      },
    },
  },

  -- Mason setup for formatters and linters
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- TypeScript language servers
        "typescript-language-server",
        "biome",
        "eslint-lsp",
        "prettier",
        "prettierd",
        "eslint",
        -- Additional tools
        "json-lsp",
        "yaml-language-server",
        "dockerfile-language-server",
        "markdownlint",
      },
    },
  },

  -- Disable formatting for certain files
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      format_after_save = {
        lsp_fallback = true,
      },
    },
  },
}
