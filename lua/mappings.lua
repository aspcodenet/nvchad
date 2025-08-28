require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Debugging keymaps (dap + dap-ui + dap-go)
local ok_dap, dap = pcall(require, "dap")
local ok_dapui, dapui = pcall(require, "dapui")
-- Visual Studio-like keybindings
map("n", "<F5>", function() if ok_dap then dap.continue() end end, { desc = "DAP: Start/Continue (F5)" })
map("n", "<S-F5>", function() if ok_dap then dap.terminate() end end, { desc = "DAP: Stop/Terminate (Shift+F5)" })
map("n", "<C-F5>", function() if ok_dap then dap.run_last() end end, { desc = "DAP: Run Last (Ctrl+F5)" })

map("n", "<F9>", function() if ok_dap then dap.toggle_breakpoint() end end, { desc = "DAP: Toggle Breakpoint (F9)" })
map("n", "<C-F9>", function() if ok_dap then dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end end, { desc = "DAP: Conditional Breakpoint (Ctrl+F9)" })

map("n", "<F10>", function() if ok_dap then dap.step_over() end end, { desc = "DAP: Step Over (F10)" })
map("n", "<F11>", function() if ok_dap then dap.step_into() end end, { desc = "DAP: Step Into (F11)" })
map("n", "<S-F11>", function() if ok_dap then dap.step_out() end end, { desc = "DAP: Step Out (Shift+F11)" })

map("n", "<F12>", function() if ok_dapui then dapui.toggle() end end, { desc = "DAP: Toggle UI (F12)" })
map("n", "<leader>dr", function() if ok_dap then dap.repl.open() end end, { desc = "DAP: Open REPL" })

-- Quick keys for evaluating
map("n", "<leader>de", function() if ok_dap then dap.eval() end end, { desc = "DAP: Eval" })
map("v", "<leader>de", function() if ok_dap then dap.eval() end end, { desc = "DAP: Eval (visual)" })

-- Go-specific: start debug session for current package/test (kept on leader)
map("n", "<leader>dG", function()
	local ok, dapgo = pcall(require, "dap-go")
	if ok then dapgo.debug_test() end
end, { desc = "DAP-Go: Debug test" })

