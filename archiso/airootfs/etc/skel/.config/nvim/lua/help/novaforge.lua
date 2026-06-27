-- NovaForge Help Module
-- :NovaForgeHelp command

local M = {}

local help_content = [[
# NovaForge.nvim - C++ Development Environment

## Quick Start
1. Open a .cpp file
2. Press <F4> to insert C++ template
3. Write your code
4. Press <F5> to build and run

## Core Keybindings

### File Operations
- <leader>w - Save file
- <leader>q - Quit
- <leader>e - Toggle file explorer

### LSP (Language Server)
- gd - Go to definition
- K - Hover documentation
- <leader>vca - Code actions
- <leader>vrn - Rename symbol
- <leader>vrr - Find references
- [d - Next diagnostic
- ]d - Previous diagnostic

### Debugging (F9-F12)
- <F5> - Build and run
- <F9> - Toggle breakpoint
- <F10> - Step over
- <F11> - Step into
- <F12> - Step out
- <leader>dc - Continue
- <leader>dr - Open debug REPL

### Build System
- <F5> - Build and run current project/file
- Detects CMake projects automatically
- Falls back to single-file compilation

### Code Navigation
- <leader>ff - Find files
- <leader>fg - Live grep
- <leader>fb - Find buffers
- <C-h/j/k/l> - Navigate windows

### Diagnostics & Problems
- <leader>xx - Toggle Trouble (problems panel)
- <leader>xw - Workspace diagnostics
- <leader>xd - Document diagnostics
- <leader>l - Run cppcheck manually

### Code Editing
- gcc - Toggle line comment
- gc (visual) - Toggle block comment
- < / > (visual) - Indent/unindent
- J / K (visual) - Move lines up/down

## Supported Features
✓ clangd LSP with code completion
✓ DAP debugging with codelldb
✓ CMake project detection
✓ Single-file C++ compilation
✓ clang-tidy integration
✓ cppcheck linting
✓ Syntax highlighting (treesitter)
✓ Fuzzy finding (telescope)
✓ Git integration (gitsigns)

## Tips
- Use :NovaForgeHelp anytime to see this help
- F4 inserts C++ template at cursor
- F5 automatically detects project type
- Works with compile_commands.json for CMake

## Troubleshooting
- No completion? Check :LspInfo
- Debugging not working? Install codelldb
- Build fails? Check CMakeLists.txt or g++ version

Press q to close this window
]]

function M.show()
  -- Create floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(help_content, "\n"))
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(win, "wrap", true)

  -- Close on q
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
end

return M
