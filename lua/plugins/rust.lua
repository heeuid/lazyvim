return {
  {
    "rust-lang/rust.vim",
    ft = { "rust" },
  },
  {
    "Saecki/crates.nvim",
    ft = { "rust" },
    tag = "stable",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = {
      tools = {
        inlay_hints = {
          highlight = "RustTypeHint",
        },
      },
    },
  },
  {
    "vxpm/ferris.nvim",
    ft = { "rust" },
    config = function()
      require("ferris").setup({
        -- your options here
      })
      vim.keymap.set(
        "n",
        "gm",
        require("ferris.methods.view_memory_layout"),
        { desc = "view memory layout of rust values" }
      )
    end,
  },
}
