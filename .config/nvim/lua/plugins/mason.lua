-- Mason configuration with improved package handling and ESLint fixes
return {
  -- Update Mason to the new package name and fix configuration
  {
    "mason-org/mason.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Prevent automatic installation of packages that don't exist
      local mason_registry = require("mason-registry")

      -- Override get_package to handle missing packages gracefully
      local original_get_package = mason_registry.get_package
      mason_registry.get_package = function(name)
        local success, result = pcall(original_get_package, name)
        if success then
          return result
        else
          -- If package not found, return nil instead of erroring
          return nil
        end
      end
    end,
  },

  -- Fix mason-lspconfig to prevent ESLint errors
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- Ensure we don't try to install non-existent packages
      if opts.ensure_installed then
        opts.ensure_installed = vim.tbl_filter(function(pkg)
          -- Filter out packages that don't exist in Mason
          return not (pkg == "eslint" or pkg == "\"eslint\"")
        end, opts.ensure_installed)
      end

      -- Add proper mappings for package names if needed
      if opts.ensure_installed then
        local mapped_packages = {}
        for _, pkg in ipairs(opts.ensure_installed) do
          if pkg == "eslint" then
            table.insert(mapped_packages, "eslint-lsp")
          else
            table.insert(mapped_packages, pkg)
          end
        end
        opts.ensure_installed = mapped_packages
      end

      return opts
    end,
  },

  -- Add Mason keybinding
  {
    "LazyVim/LazyVim",
    opts = {
      keys = {
        { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
      },
    },
  },
}
