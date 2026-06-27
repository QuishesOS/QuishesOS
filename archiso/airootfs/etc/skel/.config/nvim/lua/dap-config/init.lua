-- DAP Configuration for C++
-- Debugging setup using codelldb

local M = {}

function M.setup()
  local dap = require("dap")

  -- codelldb adapter
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}" },
    },
  }

  -- C++ configurations
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
    {
      name = "Attach to process",
      type = "codelldb",
      request = "attach",
      pid = function()
        return vim.fn.input("Process ID: ")
      end,
      cwd = "${workspaceFolder}",
    },
  }

  -- C configurations (same as C++)
  dap.configurations.c = dap.configurations.cpp

  -- DAP keybindings
  vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { desc = "Step over" })
  vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { desc = "Step into" })
  vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { desc = "Step out" })
  vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
  vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Open REPL" })
  vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run last" })
end

return M
