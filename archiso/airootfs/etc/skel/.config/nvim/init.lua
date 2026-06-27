-- NovaForge.nvim - C++ Development Environment for QuishesOS
-- Main configuration file

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Core settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "100"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Load plugins
require("plugins")

-- Load LSP configuration
require("lsp")

-- Load DAP configuration
require("dap-config")

-- Load build system
require("build")

-- Load linting
require("linting")

-- Load snippets
require("snippets")

-- Core keymaps
local keymap = vim.keymap.set

-- File operations
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- F4: Insert C++ template
keymap("n", "<F4>", function()
  require("snippets").insert_cpp_template()
end, { desc = "Insert C++ template" })

-- F5: Build and run
keymap("n", "<F5>", function()
  require("build").build_and_run()
end, { desc = "Build and run" })

-- :NovaForgeHelp command
vim.api.nvim_create_user_command("NovaForgeHelp", function()
  require("help.novaforge").show()
end, {})

-- Auto-format on save (optional)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.cpp", "*.h", "*.hpp", "*.c" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

print("NovaForge.nvim loaded - Press :NovaForgeHelp for keybindings")
