return {
  {
    "mawkler/modicator.nvim",
    config = function() require('modicator').setup() end,
  },
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
    "LazyVim/LazyVim",
    dependencies = {
      "projekt0n/github-nvim-theme",
    },
    opts = { colorscheme = "github_dark" },
    --opts = { colorscheme = "tokyonight-night" },
  },
  {
    "HiPhish/nvim-ts-rainbow2",
    config = function()
      require'nvim-treesitter.configs'.setup {
        rainbow = {
          enable = true,
          -- disable = { 'c', 'cpp' },
          query = 'rainbow-parens',
          strategy = require'ts-rainbow'.strategy.global,
        }
      }
    end
  },
}
