require("nvchad.configs.lspconfig").defaults()


local servers = {
  html = {
    filetypes = { "html", "css", "scss", "less", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    init_options = {
        html = {
          -- This ensures Emmet works for JSX and TSX files
          options = {
            useBem = false,
          },
        },
      },
  },
  gopls = {
    filetypes = { "go", "gomod", "gowork", "gotmpl" },	
    cmd = {"gopls"},
    settings = {
      gopls = {
	completeUnimported = true,
      	usePlaceholders = true,
      	analyses = {
        	unusedparams = true,
      	},       
      },
    },
  },
  -- Add this block for intelephense
  intelephense = {
    filetypes = { "php" },
    init_options = {
      global_symbol_namespaces = true,
      -- Optional settings, customize as needed
      -- e.g., to configure code formatting or validation
    },
  },
    -- Add this block for clangd
  clangd = {
    filetypes = { "c", "cpp", "h", "hpp" },
    cmd = {
      "clangd",
      "--query-driver=" .. "C:\\msys64\\ucrt64\\bin\\gcc.exe,C:\\msys64\\ucrt64\\bin\\g++.exe",
    },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)  -- nvim v0.11.0 or above required
  vim.lsp.config(name, opts) -- nvim v0.11.0 or above required
end



-- read :h vim.lsp.config for changing options of lsp servers 


-- In your custom init.lua
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
  group = format_sync_grp,
})


