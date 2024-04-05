local version = vim.inspect(vim.version())
local current_v = { version["major"], version["minor"], version["patch"] }
local target_v = { 0, 10, 0 }
local enabled = false
if vim.version.gt(current_v, target_v) or vim.version.eq(current_v, target_v) then
  enabled = true
end
local nvim_lsp = require("lspconfig")
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = enabled,
      },
      servers = {
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
          root_dir = function(fname)
            return nvim_lsp.util.root_pattern('.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json',
                  'compile_flgas.txt', 'configure.ac', '.git')(fname) or
                nvim_lsp.util.path.dirname(fname)
          end,
        }
      }
    },
  },
}
