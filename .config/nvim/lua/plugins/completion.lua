-- Enhanced code completion for NestJS/TypeScript
return {
  -- Configure nvim-cmp for better completions
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- npm completion source
      "David-Kunz/cmp-npm",
      -- Emoji completion
      "hrsh7th/cmp-emoji",
      -- Path completion
      "hrsh7th/cmp-path",
      -- Buffer completion
      "hrsh7th/cmp-buffer",
      -- Command line completion
      "hrsh7th/cmp-cmdline",
      -- LSP signature help for better function completion
      "hrsh7th/cmp-nvim-lsp-signature-help",
      -- Snippets for completion
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
      },
      -- cmp-npm configuration (must be loaded after nvim-cmp)
      {
        "David-Kunz/cmp-npm",
        opts = {
          ignore = {},
        },
      },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Ensure LSP source is present and at the beginning
      local has_lsp_source = false
      for _, source in ipairs(opts.sources) do
        if source.name == "nvim_lsp" then
          has_lsp_source = true
          break
        end
      end
      if not has_lsp_source then
        table.insert(opts.sources, 1, { name = "nvim_lsp", group_index = 1 })
      end

      -- Add additional completion sources
      table.insert(opts.sources, {
        name = "nvim_lsp_signature_help", -- LSP signature help
        group_index = 2,
      })
      table.insert(opts.sources, {
        name = "npm", -- NPM package completions
        keyword_length = 3,
        group_index = 3,
      })
      table.insert(opts.sources, {
        name = "emoji", -- Emoji completions
        group_index = 4,
      })

      -- Enhanced completion behavior for TypeScript
      opts.completion = {
        completeopt = "menu,menuone,noinsert,noselect",
        keyword_length = 1,
      }

      -- Preselect first item
      opts.preselect = cmp.PreselectMode.Item

      -- Add snippet expansion
      opts.snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      }

      -- Mapping for better completion experience
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.complete(),
      })

      -- Add icons
      opts.formatting = {
        format = function(entry, item)
          local icons = {
            Text = "  ",
            Method = "  ",
            Function = "  ",
            Constructor = "  ",
            Field = "  ",
            Variable = "  ",
            Class = "  ",
            Interface = "  ",
            Module = "  ",
            Property = "  ",
            Unit = "  ",
            Value = "  ",
            Enum = "  ",
            Keyword = "  ",
            Snippet = "  ",
            Color = "  ",
            File = "  ",
            Reference = "  ",
            Folder = "  ",
            EnumMember = "  ",
            Constant = "  ",
            Struct = "  ",
            Event = "  ",
            Operator = "  ",
            TypeParameter = "  ",
          }

          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end

          return item
        end,
      }

      -- Add NestJS/TypeScript-specific sorting
      opts.sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }

      return opts
    end,
  },

  -- Add LSP signature help (shows function signatures)
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        tsserver = function(_, opts)
          -- Enable signature help
          opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
            textDocument = {
              signatureHelp = {
                dynamicRegistration = false,
              },
            },
          })
        end,
      },
    },
  },

  -- Auto pairs for better completion
  {
    "echasnovski/mini.pairs",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      map = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
      },
    },
  },

  -- Surround text objects
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- Add cmp-cmdline for command completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline",
      config = function()
        local cmp = require("cmp")

        -- Command line completion
        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
          }, {
            { name = "cmdline" },
          }),
        })

        -- Search completion
        cmp.setup.cmdline("/", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" },
          },
        })
      end,
    },
  },
}
