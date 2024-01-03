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
    config = function()
      local mason_registry = require("mason-registry")
      local dap = require("dap")
      local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
      local codelldb_path = codelldb_root .. "adapter/codelldb"
      local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
      dap.adapters.rust = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
    end,
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
