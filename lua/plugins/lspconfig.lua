return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
          root_dir = function(fname)
            local nvim_lsp = require("lspconfig")
            return nvim_lsp.util.root_pattern(
              '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json',
              'compile_flgas.txt', 'configure.ac', '.git'
            )(fname) or vim.fs.dirname(fname)
          end,
        }
      }
    },
  },
}
