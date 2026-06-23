-- TypeScript/TSX and NestJS configuration
return {
  -- Enable TypeScript/TSX extras
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- Enhanced TypeScript language server configuration (vtsls)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Use vtsls (configured by LazyVim TypeScript extra) with custom settings
        vtsls = {
          settings = {
            javascript = {
              preferences = {
                importModuleSpecifierPreference = "relative",
                importModuleSpecifierEnding = "js",
                quoteStyle = "single",
                -- Enhanced auto-import settings
                includeAutomaticOptionalChainCompletions = true,
                includeCompletionsForImportStatements = true,
                importStatementSuggestions = "fromPackageImportsOnly",
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
              suggest = {
                completeFunctionCalls = true,
                autoImports = true,
              },
              codeActions = {
                enabled = true,
              },
            },
            typescript = {
              preferences = {
                importModuleSpecifierPreference = "relative",
                importModuleSpecifierEnding = "js",
                quoteStyle = "single",
                autoImportFileExcludePatterns = {
                  "node_modules",
                  "dist",
                  "build",
                },
                -- Enhanced auto-import settings
                includeAutomaticOptionalChainCompletions = true,
                includeCompletionsForImportStatements = true,
                importStatementSuggestions = "fromPackageImportsOnly",
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
              suggest = {
                completeFunctionCalls = true,
                autoImports = true,
              },
              codeActions = {
                enabled = true,
              },
            },
            vtsls = {
              autoUseWorkspaceTsdk = true,
              enableMoveToFileCodeAction = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
                maxInlayHintLength = 30,
              },
            },
          },
          -- Enhanced capabilities for auto-import
          capabilities = {
            textDocument = {
              codeAction = {
                codeActionLiteralSupport = {
                  codeActionKind = {
                    valueSet = {
                      "",
                      "quickfix",
                      "refactor",
                      "refactor.extract",
                      "refactor.inline",
                      "refactor.rewrite",
                      "source",
                      "source.organizeImports",
                    },
                  },
                },
                dynamicRegistration = true,
                isPreferredSupport = true,
              },
            },
          },
        },
        -- Add Biome for fast linting/formatting (alternative to ESLint)
        biome = {},
      },
    },
    -- Add auto-import keybindings
    keys = {
      {
        "<leader>co",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = { "source.organizeImports" },
            },
            apply = true,
          })
        end,
        desc = "Organize Imports",
      },
      {
        "<leader>ci",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = { "source.addMissingImports", "source.fixAll" },
            },
            apply = true,
          })
        end,
        desc = "Fix Imports",
      },
    },
  },

  -- Add NestJS-specific snippets
  {
    "rafamadriz/friendly-snippets",
    dependencies = {
      "LazyVim/LazyVim",
    },
    config = function()
      -- Add custom NestJS snippets
      local snippets_path = vim.fn.stdpath("config") .. "/snippets"
      vim.opt.rtp:append(snippets_path)
    end,
  },

  -- Better TypeScript folding
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
        "javascript",
        "jsdoc",
      })
      opts.indent = {
        enable = true,
        disable = { "yaml" },
      }
    end,
  },

  -- Auto-import support for NestJS
  {
    "windwp/nvim-ts-autotag",
    ft = { "typescript", "tsx", "javascript", "jsx" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },
}
