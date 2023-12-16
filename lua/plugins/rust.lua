return {
  { "rust-lang/rust.vim" },
  {
    "Saecki/crates.nvim",
    tag = "stable",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    opts = {
      tools = {
        inlay_hints = {
          highlight = "RustTypeHint",
        },
      },
    },
  },
}
