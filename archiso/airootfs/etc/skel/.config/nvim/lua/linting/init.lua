-- Linting Configuration for C++
-- Using none-ls with clang-tidy and cppcheck

local M = {}

function M.setup()
  local null_ls = require("null-ls")

  null_ls.setup({
    sources = {
      -- clang-tidy for C++
      null_ls.builtins.diagnostics.cppcheck.with({
        extra_args = { "--enable=all", "--suppress=missingIncludeSystem" },
      }),
    },
    on_attach = function(client, bufnr)
      -- Format on save (optional)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
  })

  -- Manual lint trigger
  vim.keymap.set("n", "<leader>l", function()
    vim.cmd("!cppcheck --enable=all --suppress=missingIncludeSystem " .. vim.fn.expand("%"))
  end, { desc = "Run cppcheck" })
end

return M
