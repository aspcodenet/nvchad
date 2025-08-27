require("nvchad.configs.lspconfig").defaults()


local servers = {
  html = {},
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


