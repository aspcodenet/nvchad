return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- DAP Plugins (consolidated and lazy = false, as they are a group)
  {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
    lazy = false,
    config = function()
      require("dapui").setup()
      require("configs.dap")
    end,
  },

  -- Copilot Plugins
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- Disables visual suggestions to let copilot-cmp handle them
        suggestion = { enabled = false },
        -- CopilotChat requires the panel to be enabled
        panel = { enabled = true },
        -- Optional, but helps reduce suggestion frequency
        throttle_ms = 1500,
        debounce = 75,
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

 {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- snacks.nvim must be inside this dependencies table
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    opts = {
      port = 12000,
      embedded = {
        enabled = true,
      },
    },
  },  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "main",
  --   cmd = { "CopilotChat", "CopilotChatFix", "CopilotChatExplain" },
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim" },
  --     { "zbirenbaum/copilot.lua" },
  --     { "nvim-telescope/telescope.nvim" },
  --   },
  --   build = "make tiktoken",
  --   opts = {},
  -- },

  -- nvim-cmp and LuaSnip
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets" -- Add this if you want snippet collection
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
        }),
        window = {
          -- Move your window options here
          completion = {
            border = "rounded",
            col_offset = 8,
            -- This is the key line to move the popup more to the right
            side_padding = 1,
            win_pos = 'manual',
            manual_win_pos_adjust = function(info)
                return {
                    row = info.cursor.row,
                    col = info.cursor.col + 15
                }
            end,
          },
          documentation = {
            border = "rounded",
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "vim", "lua", "vimdoc", "php" },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
    },
  },
}