local M = {}

-- Setup dap-go and dap-ui
local has_dap, dap = pcall(require, "dap")
local has_dapui, dapui = pcall(require, "dapui")
local has_dapgo, dapgo = pcall(require, "dap-go")

if has_dapui then
  dapui.setup({
    layouts = {
      {
        elements = { "scopes", "breakpoints", "stacks", "watches","console" },
        size = 40,
        position = "right",
      },
    },
    floating = { border = "rounded" },
  })
end

if has_dap and has_dapui then
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

if has_dapgo then
  dapgo.setup()
end



-- Add default configurations for Go (so dap.ext.vscode can fallback and dap has presets)
if has_dap then
  dap.configurations = dap.configurations or {}
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
        console = "integratedTerminal",
    },
    {
      type = "go",
      name = "Debug Package",
      request = "launch",
      program = "${fileDirname}",
        console = "integratedTerminal",
    },
    {
      type = "go",
      name = "Debug Test",
      request = "launch",
      mode = "test",
      program = "${fileDirname}",
        console = "integratedTerminal",
    },
    {
      type = "go",
      name = "Attach (127.0.0.1:38697)",
      request = "attach",
      mode = "remote",
      host = "127.0.0.1",
      port = 38697,
        console = "integratedTerminal",
    },
  }   

    dap.adapters.gdb = {
    type = "executable",
    command = "c:\\msys64\\mingw64\\bin\\gdb.exe",
    args = { "-i", "dap" },
    }
    dap.configurations.c = {
    {
        name = "Launch with GDB",
        externalConsole = true ,
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
    -- The crucial addition
        preLaunchTask = function()
          local job = vim.fn.jobstart({ "c:\\msys64\\mingw64\\bin\\mingw32-make" }, {
            cwd = vim.fn.getcwd(),
            on_exit = function(j, code, reason)
              if code ~= 0 then
                vim.schedule(function()
                  vim.notify("Make failed with code " .. code, vim.log.levels.ERROR)
                end)
              end
            end,
          })
          -- Return the job ID to wait for its completion
          return job   
        end,     
    },
}

dap.configurations.cpp = dap.configurations.c    
  end
    






return M
