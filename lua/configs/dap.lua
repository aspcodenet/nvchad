local M = {}

-- Setup dap-go and dap-ui
local has_dap, dap = pcall(require, "dap")
local has_dapui, dapui = pcall(require, "dapui")
local has_dapgo, dapgo = pcall(require, "dap-go")

if has_dapui then
  dapui.setup({
    layouts = {
      {
        elements = { "scopes", "breakpoints", "stacks", "watches" },
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

-- Minimal adapter for delve if not provided by dap-go
if has_dap then
  dap.adapters.go = function(callback, config)
    local handle
    local pid_or_err
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    local port = 38697
    local dlv_cmd = vim.fn.exepath("dlv")
    if dlv_cmd == "" or dlv_cmd == nil then
      vim.schedule(function()
        vim.notify("delve (dlv) not found in PATH. Install delve and ensure it's on PATH.", vim.log.levels.ERROR)
      end)
      return
    end

    local args = { "dap", "-l", "127.0.0.1:" .. port }

    local ok, spawn_err = pcall(function()
      handle, pid_or_err = vim.loop.spawn(dlv_cmd, {
        args = args,
        stdio = { nil, stdout, stderr },
      }, function(code)
        stdout:close()
        stderr:close()
        if handle and not handle:is_closing() then
          handle:close()
        end
        if code ~= 0 then
          vim.schedule(function()
            vim.notify("delve exited with code: " .. tostring(code), vim.log.levels.ERROR)
          end)
        end
      end)
    end)

    if not ok then
      vim.schedule(function()
        vim.notify("Failed to spawn dlv: " .. tostring(spawn_err), vim.log.levels.ERROR)
      end)
      return
    end

    stdout:read_start(function(err, chunk)
      if err then
        vim.schedule(function()
          vim.notify("dlv stdout error: " .. tostring(err), vim.log.levels.WARN)
        end)
      end
      if chunk then
        -- optional: show delve stdout when debugging
        -- vim.schedule(function() vim.notify(chunk) end)
      end
    end)

    stderr:read_start(function(err, chunk)
      if err then
        vim.schedule(function()
          vim.notify("dlv stderr error: " .. tostring(err), vim.log.levels.WARN)
        end)
      end
      if chunk then
        vim.schedule(function()
          vim.notify("dlv stderr: " .. tostring(chunk), vim.log.levels.ERROR)
        end)
      end
    end)

    -- Enable dap debug logging to help diagnose adapter startup problems
    pcall(function()
      dap.set_log_level('DEBUG')
      vim.schedule(function()
        vim.notify('dap log level set to DEBUG for adapter troubleshooting', vim.log.levels.INFO)
      end)
    end)

    -- wait a bit longer for delve to start
    vim.defer_fn(function()
      callback({ type = "server", host = "127.0.0.1", port = port })
    end, 500)
  end
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
    },
    {
      type = "go",
      name = "Debug Package",
      request = "launch",
      program = "${fileDirname}",
    },
    {
      type = "go",
      name = "Debug Test",
      request = "launch",
      mode = "test",
      program = "${fileDirname}",
    },
    {
      type = "go",
      name = "Attach (127.0.0.1:38697)",
      request = "attach",
      mode = "remote",
      host = "127.0.0.1",
      port = 38697,
    },
  }
end

return M
