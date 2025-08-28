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

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
