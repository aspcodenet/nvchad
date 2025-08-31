return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Debugging for Go (nvim-dap + dap-ui + dap-go)
  {
    "mfussenegger/nvim-dap",
    lazy = false,
  },
  {
    "nvim-neotest/nvim-nio",
    lazy = false,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "leoluz/nvim-dap-go",
    lazy = false,
    config = function()
      require("configs.dap")
    end,
  },
  -- {
  --   "github/copilot.vim",
  --   lazy = false,
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_assume_mapped = true
  --     -- This is the most reliable way to disable suggestions
  --     vim.g.copilot_suggestion_enabled = false

  --     -- This also disables the panel which can sometimes trigger suggestions
  --     vim.g.copilot_panel_enabled = false      
  --   end,
    
  -- },
    {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- This disables the visual suggestions, as copilot-cmp will handle them
        suggestion = { enabled = false },
        throttle_ms = 1500, 
        debounce=75,
        panel = { enabled = false },
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
-- In your plugins.lua file or a similar config location

{
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip") -- 
        cmp.setup({
            sources = cmp.config.sources({
                -- Add this line to include Copilot as a source
                { name = "copilot" },
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
            }),
            window = {
                completion = {
                    -- side = "right",
                    col_offset = 8,
                    -- side_padding = 10
                }
            },
            mapping = cmp.mapping.preset.insert({
                -- `<C-n>` and `<C-p>` are for navigating the list
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),

                -- The intelligent Tab key
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        -- When the menu is visible, accept the current selection
                        cmp.confirm({ select = true })
                    elseif luasnip.expandable() then
                        -- If a snippet is expandable, expand it
                        luasnip.expand()
                    elseif luasnip.jumpable(1) then
                        -- If you're inside a snippet, jump to the next placeholder
                        luasnip.jump(1)
                    else
                        -- If nothing is happening, insert a tab character
                        fallback()
                    end
                end, { "i", "s" }),
            }),
        })
    end,
},
-- {
--   "L3MON4D3/LuaSnip",
--   -- Add friendly-snippets as a dependency
--   dependencies = { "rafamadriz/friendly-snippets" },
--   event = "InsertEnter",
--   config = function()
--     require("luasnip.loaders.from_vscode").lazy_load()
--   end,
-- },



  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter",
  --   config = function()
  --     local cmp = require("cmp")
  --     cmp.setup({
  --       sources = cmp.config.sources({
  --         {
  --           name = "nvim_lsp",
  --           -- This filter function is the key to preventing overlap
  --           filter = function(item)
  --             return not vim.fn["copilot#is_visible"]()
  --           end
  --         },
  --         {
  --           name = "luasnip",
  --           filter = function(item)
  --             return not vim.fn["copilot#is_visible"]()
  --           end
  --         },
  --         -- Add the filter to other sources like "buffer" or "path" as needed
  --         {
  --           name = "buffer",
  --           filter = function(item)
  --             return not vim.fn["copilot#is_visible"]()
  --           end
  --         },
  --       }),
  --       -- Add a custom keymap for Tab to handle Copilot and cmp
  --       mapping = {
  --         ["<Tab>"] = cmp.mapping(function(fallback)
  --           if cmp.visible() then
  --             cmp.select_next_item()
  --           elseif vim.fn["copilot#is_visible"]() then
  --             vim.fn["copilot#Accept"]()
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" }),
  --       },
  --     })
  --   end,
  --   -- test new blink
  --   -- { import = "nvchad.blink.lazyspec" },
  -- },
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc","php",
  			--"html", "css", "javascript", "typescript", "javacriptreact", "typescriptreact",
  			--"php","csharp","go"
  		},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
  	},
  },
}
