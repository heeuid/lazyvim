return {
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "debugpy", -- for nvim-dap-python
        }
      }
    },
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },
}
