-- C++ Snippets for NovaForge
-- F4 template insertion

local M = {}

-- C++ template
local cpp_template = [[#include <iostream>

int main() {
    
    return 0;
}]]

function M.insert_cpp_template()
  local lines = vim.split(cpp_template, "\n")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
  -- Move cursor to inside main
  vim.api.nvim_win_set_cursor(0, { row + 3, 4 })
end

return M
