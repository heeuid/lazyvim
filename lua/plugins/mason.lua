return {
  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  --{ import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
        "flake8",
        "bash-language-server",
        "lemminx",
        "taplo",
        --"shfmt",
        --"clangd",
        --"pyright",
        --"rust-analyzer",
        --"stylua",
        --"yaml-language-server",
        --"json-lsp",
        --"markdownlint",
      },
    },
  },
}
