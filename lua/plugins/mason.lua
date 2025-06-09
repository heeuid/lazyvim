return {
  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  --{ import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    opts = {
      ensure_installed = {
        "shellcheck",
        "flake8",
        "bash-language-server",
        "lemminx",
        "taplo",
        "codelldb", -- for c, c++, rust debugging (llvm)
        --"shfmt",
        --"clangd",
        --"basedpyright",
        --"rust-analyzer",
        --"stylua",
        --"yaml-language-server",
        --"json-lsp",
        --"markdownlint",
      },
    },
  },
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
