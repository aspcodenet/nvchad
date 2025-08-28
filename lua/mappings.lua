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
map("n", "<F5>", function()
	if ok_dap then
		local ft = vim.bo.filetype or ""
		local configs = (dap.configurations and dap.configurations[ft]) or nil
		if configs and #configs > 0 then
			-- vim.cmd("enew")
			dap.continue()
		else
			vim.notify("No DAP configurations found for '" .. ft .. "'. Add one to `dap.configurations[<filetype>]` or configure an adapter.", vim.log.levels.ERROR)
		end
	end
end, { desc = "DAP: Start/Continue (F5)" })
map("n", "<S-F5>", function() if ok_dap then dap.terminate() end end, { desc = "DAP: Stop/Terminate (Shift+F5)" })
map("n", "<C-F5>", function()
	if ok_dap then
		vim.cmd("enew")
		dap.run_last()
	end
end, { desc = "DAP: Run Last (Ctrl+F5)" })

map("n", "<F9>", function() if ok_dap then dap.toggle_breakpoint() end end, { desc = "DAP: Toggle Breakpoint (F9)" })
map("n", "<C-F9>", function() if ok_dap then dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end end, { desc = "DAP: Conditional Breakpoint (Ctrl+F9)" })

map("n", "<F10>", function()
	if ok_dap then
		vim.cmd("enew")
		dap.step_over()
	end
end, { desc = "DAP: Step Over (F10)" })
map("n", "<F11>", function()
	if ok_dap then
		vim.cmd("enew")
		dap.step_into()
	end
end, { desc = "DAP: Step Into (F11)" })
map("n", "<S-F11>", function()
	if ok_dap then
		vim.cmd("enew")
		dap.step_out()
	end
end, { desc = "DAP: Step Out (Shift+F11)" })

map("n", "<F12>", function() if ok_dapui then dapui.toggle() end end, { desc = "DAP: Toggle UI (F12)" })
map("n", "<leader>dr", function()
	if ok_dap then
		vim.cmd("enew")
		dap.repl.open()
	end
end, { desc = "DAP: Open REPL" })

-- Quick keys for evaluating
map("n", "<leader>de", function() if ok_dap then dap.eval() end end, { desc = "DAP: Eval" })
map("v", "<leader>de", function() if ok_dap then dap.eval() end end, { desc = "DAP: Eval (visual)" })

-- Go-specific: start debug session for current package/test (kept on leader)
map("n", "<leader>dG", function()
	local ok, dapgo = pcall(require, "dap-go")
	if ok then
		-- open a new buffer so the debug session starts from its own buffer
		vim.cmd("enew")
		dapgo.debug_test()
	end
end, { desc = "DAP-Go: Debug test" })


map("n","<leader>ts", function()
		-- prefer serving from the current buffer directory so requests match files you edit
		local buf_dir = vim.fn.expand("%:p:h")
		local project_root = vim.fn.getcwd()
		local local_bin_project = project_root .. "/node_modules/.bin/live-server"
		local local_bin_buf = buf_dir .. "/node_modules/.bin/live-server"

		local function start_server(exec, dir)
			local cmd = exec .. " --port=8080"
			-- open a new empty buffer and start a terminal in it so live-server runs in its own buffer
			vim.cmd("enew")
			-- use termopen so we can set cwd reliably across shells
			vim.fn.termopen(cmd, { cwd = dir })
			vim.cmd("startinsert")
		end

		-- check local installs: prefer project-level, then buffer-local
		if vim.loop.fs_stat(local_bin_project) then
			start_server(local_bin_project, project_root)
			return
		end
		if vim.loop.fs_stat(local_bin_buf) then
			start_server(local_bin_buf, buf_dir)
			return
		end

		if vim.fn.executable("live-server") == 1 then
			start_server("live-server", buf_dir)
			return
		end

		-- Not installed: decide between installing in project (if package.json exists) or global
		local install_cmd = { "npm" }
		if vim.fn.filereadable(project_root .. "/package.json") == 1 then
			table.insert(install_cmd, "install")
			table.insert(install_cmd, "--save-dev")
			table.insert(install_cmd, "live-server")
		else
			table.insert(install_cmd, "install")
			table.insert(install_cmd, "-g")
			table.insert(install_cmd, "live-server")
		end

		vim.notify("live-server not found, running npm install...", vim.log.levels.INFO)

		vim.fn.jobstart(install_cmd, {
			cwd = project_root,
			on_exit = function(_, code)
				vim.schedule(function()
					if code == 0 then
						vim.notify("live-server installed successfully — starting server", vim.log.levels.INFO)
						if vim.loop.fs_stat(local_bin_project) then
							start_server(local_bin_project, project_root)
						elseif vim.loop.fs_stat(local_bin_buf) then
							start_server(local_bin_buf, buf_dir)
						elseif vim.fn.executable("live-server") == 1 then
							start_server("live-server", buf_dir)
						else
							vim.notify("Installed but executable not found in PATH", vim.log.levels.ERROR)
						end
					else
						vim.notify("live-server installation failed (exit code: " .. tostring(code) .. ")", vim.log.levels.ERROR)
					end
				end)
			end,
		})
end, {desc = "Start live server"})

-- Start live-server in a new tab
map("n","<leader>tt", function()
	local buf_dir = vim.fn.expand("%:p:h")
	local project_root = vim.fn.getcwd()
	local local_bin_project = project_root .. "/node_modules/.bin/live-server"
	local local_bin_buf = buf_dir .. "/node_modules/.bin/live-server"

	local function start_server_in_tab(exec, dir)
		local cmd = exec .. " --port=8080"
		-- open a new buffer for the terminal (not a tab)
		vim.cmd("enew")
		vim.fn.termopen(cmd, { cwd = dir })
		vim.cmd("startinsert")
	end

	if vim.loop.fs_stat(local_bin_project) then
		start_server_in_tab(local_bin_project, project_root)
		return
	end
	if vim.loop.fs_stat(local_bin_buf) then
		start_server_in_tab(local_bin_buf, buf_dir)
		return
	end
	if vim.fn.executable("live-server") == 1 then
		start_server_in_tab("live-server", buf_dir)
		return
	end

	vim.notify("live-server not found. Use <leader>ts to install and start.", vim.log.levels.WARN)
end, {desc = "Start live server in tab"})


