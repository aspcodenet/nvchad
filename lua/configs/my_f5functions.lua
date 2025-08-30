local M = {} -- M is a common convention for the module table

function M.install_live_server(project_root, buf_dir)
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
          -- Now that it's installed, we call the main function again
          start_live_server()
        else
          vim.notify("live-server installation failed (exit code: " .. tostring(code) .. ")", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end

-- Start live-server in a new tab
function M.start_live_server()
  local buf_dir = vim.fn.expand("%:p:h")
  local project_root = vim.fn.getcwd()
  local local_bin_project = project_root .. "/node_modules/.bin/live-server"
  local local_bin_buf = buf_dir .. "/node_modules/.bin/live-server"

  local function start_server(exec, dir)
    local cmd = exec .. " --port=8080"
    vim.cmd("enew")
    vim.fn.termopen(cmd, { cwd = dir })
    vim.cmd("startinsert")
  end

  -- Check local installs first
  if vim.loop.fs_stat(local_bin_project) then
    start_server(local_bin_project, project_root)
    return
  end
  if vim.loop.fs_stat(local_bin_buf) then
    start_server(local_bin_buf, buf_dir)
    return
  end
  
  -- Check for global install
  if vim.fn.executable("live-server") == 1 then
    start_server("live-server", buf_dir)
    return
  end

  -- If not found, start the installation process
  install_live_server(project_root, buf_dir)
end



function M.start_php_server()
  local project_root = vim.fn.getcwd()

  local php_cmd = "php -S localhost:8000"
  if vim.fn.executable("php") == 0 then
    php_cmd = "c:\\php\\php -S localhost:8000"
  end

  -- Open a new empty buffer and start a terminal in it
  vim.cmd("enew")
  -- Use termopen so we can set cwd reliably across shells
  vim.fn.termopen(php_cmd, { cwd = project_root })
  vim.cmd("startinsert")

  vim.notify("PHP development server started on http://localhost:8000", vim.log.levels.INFO)
  local open_cmd
  if vim.fn.has("mac") == 1 then
    open_cmd = "open http://localhost:8000"
  elseif vim.fn.has("win32") == 1 then
    open_cmd = "start http://localhost:8000"
  else
    open_cmd = "xdg-open http://localhost:8000"
  end

  -- Execute the command in the shell
  vim.fn.system(open_cmd)  
end

return M