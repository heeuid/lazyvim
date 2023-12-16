return {
  {
    "NvChad/nvim-colorizer.lua",
    lazy = true,
    config = function()
      require("colorizer").setup({
        filetypes = {
          "*", -- Highlight all files, but customize some others.
          cmp_docs = { always_update = true },
        },
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = { style = "night" },
    config = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme tokyonight-night")
    end,
  },
  {
    "mrjones2014/nvim-ts-rainbow",
    config = function()
      require("nvim-treesitter.configs").setup({
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
      })
    end,
  },
}
