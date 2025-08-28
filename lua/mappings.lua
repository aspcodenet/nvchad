require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Debugging keymaps (dap + dap-ui + dap-go)
local ok_dap, dap = pcall(require, "dap")
local ok_dapui, dapui = pcall(require, "dapui")

-- leader key is already set in init.lua to space
local leader = " "

-- Grouped under <leader>d
map("n", leader .. "dR", function() if ok_dap then dap.run_to_cursor() end end, { desc = "DAP: Run to cursor" })
map("n", leader .. "db", function() if ok_dap then dap.toggle_breakpoint() end end, { desc = "DAP: Toggle breakpoint" })
map("n", leader .. "dB", function() if ok_dap then dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end end, { desc = "DAP: Conditional breakpoint" })
map("n", leader .. "dc", function() if ok_dap then dap.continue() end end, { desc = "DAP: Continue" })
map("n", leader .. "di", function() if ok_dap then dap.step_into() end end, { desc = "DAP: Step into" })
map("n", leader .. "do", function() if ok_dap then dap.step_over() end end, { desc = "DAP: Step over" })
map("n", leader .. "dO", function() if ok_dap then dap.step_out() end end, { desc = "DAP: Step out" })
map("n", leader .. "dr", function() if ok_dap then dap.repl.open() end end, { desc = "DAP: Open REPL" })
map("n", leader .. "du", function() if ok_dapui then dapui.toggle() end end, { desc = "DAP: Toggle UI" })
map("n", leader .. "dq", function() if ok_dap then dap.terminate() end end, { desc = "DAP: Quit" })

-- Quick keys for evaluating and hovering
map("n", leader .. "de", function() if ok_dap then dap.eval() end end, { desc = "DAP: Eval" })
map("v", leader .. "de", function() if ok_dap then dap.eval() end end, { desc = "DAP: Eval (visual)" })

-- Go-specific: start debug session for current package/test
map("n", leader .. "dG", function()
	local ok, dapgo = pcall(require, "dap-go")
	if ok then dapgo.debug_test() end
end, { desc = "DAP-Go: Debug test" })

