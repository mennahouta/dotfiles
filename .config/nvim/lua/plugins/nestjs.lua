-- NestJS-specific plugins and configurations
return {
  -- NestJS-specific pickers, powered by snacks
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>nm",
        function()
          Snacks.picker.files({
            title = "NestJS Modules",
            dirs = { "src" },
            exclude = { "*.map", "node_modules", "dist", "build" },
          })
        end,
        desc = "NestJS: Find Modules",
      },
      {
        "<leader>nc",
        function()
          Snacks.picker.files({
            title = "NestJS Controllers",
            dirs = { "src" },
            pattern = "controller",
            exclude = { "*.map", "node_modules", "dist", "build" },
          })
        end,
        desc = "NestJS: Find Controllers",
      },
      {
        "<leader>ns",
        function()
          Snacks.picker.files({
            title = "NestJS Services",
            dirs = { "src" },
            pattern = "service",
            exclude = { "*.map", "node_modules", "dist", "build" },
          })
        end,
        desc = "NestJS: Find Services",
      },
    },
  },

  -- Auto-detect and configure NestJS projects
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Project-specific LSP configuration
      on_attach = function(client, bufnr)
        local is_nestjs = vim.fn.findfile("nest-cli.json", ".;") ~= "" or
                          vim.fn.findfile("package.json", ".;") ~= ""

        if is_nestjs then
          -- NestJS-specific keymaps
          local opts = { buffer = bufnr, silent = true }

          -- Create new NestJS files (pick a sibling, then name the new file)
          vim.keymap.set("n", "<leader>nn", function()
            Snacks.picker.files({
              title = "Create NestJS File",
              dirs = { "src" },
              confirm = function(picker, item)
                picker:close()
                vim.ui.input({
                  prompt = "Enter filename: ",
                  default = item and item.file or "src/",
                }, function(input)
                  if input then
                    vim.cmd("edit " .. input)
                  end
                end)
              end,
            })
          end, opts)

          -- Go to implementation (useful for NestJS dependency injection)
          vim.keymap.set("n", "gi", function()
            vim.lsp.buf.implementation()
          end, opts)
        end
      end,
    },
  },

  -- Neoconf for workspace configuration
  {
    "folke/neoconf.nvim",
    opts = {
      import = {
        coc = false,
        nlsp = false,
      },
      local_settings = ".neoconf.json",
      override = {
        json = {
          ["lspconfig"] = {
            ["ts_ls"] = {
              -- Better completion for NestJS
              typescript = {
                preferences = {
                  includePackageJsonAutoImports = "on",
                  importModuleSpecifierPreference = "relative",
                },
              },
            },
          },
        },
      },
    },
  },


  -- Todo-comments for NestJS decorators and annotations
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        -- Add NestJS-specific keywords
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        FIXME = { icon = " ", color = "error" },
        NOTE = { icon = " ", color = "hint" },
        DECORATOR = { icon = " ", color = "default" },
        MODULE = { icon = " ", color = "default" },
        CONTROLLER = { icon = " ", color = "default" },
        SERVICE = { icon = " ", color = "default" },
      },
    },
  },

  -- Add project.nvim for better workspace management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        manual_mode = false,
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "package.json", "nest-cli.json", "tsconfig.json" },
        scope_chdir = "global",
        silent_chdir = false,
        datapath = vim.fn.stdpath("data"),
      })
    end,
    keys = {
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Find projects",
      },
    },
  },
}
