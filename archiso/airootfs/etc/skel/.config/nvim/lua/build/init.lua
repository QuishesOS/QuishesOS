-- Build System Configuration for NovaForge
-- Using overseer for task running

local M = {}

function M.setup()
  local overseer = require("overseer")

  -- CMake build template
  overseer.register_template({
    name = "CMake Build",
    builder = function()
      return {
        cmd = { "cmake" },
        args = { "--build", "build" },
        cwd = vim.fn.getcwd(),
        components = { "default" },
      }
    end,
    condition = {
      filetype = { "cpp", "c" },
      callback = function()
        return vim.fn.filereadable("CMakeLists.txt") == 1
      end,
    },
  })

  -- CMake configure template
  overseer.register_template({
    name = "CMake Configure",
    builder = function()
      return {
        cmd = { "cmake" },
        args = { "-B", "build", "-DCMAKE_BUILD_TYPE=Debug" },
        cwd = vim.fn.getcwd(),
        components = { "default" },
      }
    end,
    condition = {
      filetype = { "cpp", "c" },
      callback = function()
        return vim.fn.filereadable("CMakeLists.txt") == 1
      end,
    },
  })

  -- Single file compile
  overseer.register_template({
    name = "Compile Current File",
    builder = function()
      local file = vim.fn.expand("%:p")
      local output = vim.fn.expand("%:p:r")
      return {
        cmd = { "g++" },
        args = { "-std=c++17", "-Wall", "-g", file, "-o", output },
        cwd = vim.fn.expand("%:p:h"),
        components = { "default" },
      }
    end,
    condition = {
      filetype = { "cpp" },
    },
  })
end

-- Build and run function (F5)
function M.build_and_run()
  local overseer = require("overseer")

  -- Check for CMake project
  if vim.fn.filereadable("CMakeLists.txt") == 1 then
    -- CMake project
    local task = overseer.new_task({
      name = "CMake Build and Run",
      strategy = {
        "orchestrator",
        tasks = {
          { "CMake Configure" },
          { "CMake Build" },
          {
            cmd = { "./build/main" }, -- Adjust based on your executable name
            components = { "default" },
          },
        },
      },
    })
    task:start()
  else
    -- Single file compile and run
    local file = vim.fn.expand("%:p")
    local output = vim.fn.expand("%:p:r")

    local compile_task = overseer.new_task({
      cmd = { "g++" },
      args = { "-std=c++17", "-Wall", "-g", file, "-o", output },
      cwd = vim.fn.expand("%:p:h"),
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    })

    compile_task:subscribe("on_exit", function(_, code)
      if code == 0 then
        -- Compilation successful, run the executable
        local run_task = overseer.new_task({
          cmd = { output },
          cwd = vim.fn.expand("%:p:h"),
          components = { "default" },
        })
        run_task:start()
      else
        vim.notify("Compilation failed", vim.log.levels.ERROR)
      end
    end)

    compile_task:start()
  end
end

return M
