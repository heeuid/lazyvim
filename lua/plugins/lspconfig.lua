local version = vim.version()
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
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()

      -- lua_ls
      nvim_lsp.lua_ls.setup({
        settings = {
          Lua = {
            hint = {
              enable = true, -- necessary
            }
          }
        }
      })

      -- clangd
      nvim_lsp.clangd.setup({
        settings = {
          clangd = {
            InlayHints = {
              Designators = true,
              Enabled = true,
              ParameterNames = true,
              DeducedTypes = true,
            },
            fallbackFlags = { "-std=c++20" },
          },
        }
      })
    end
  },
}
