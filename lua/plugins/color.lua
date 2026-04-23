return {
  { -- color of cursor's line number changes based on the mode
    "mawkler/modicator.nvim",
    config = function() require('modicator').setup() end,
  },
  { -- show the color of '#000000'
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
  { -- theme
    "LazyVim/LazyVim",
    dependencies = {
      "navarasu/onedark.nvim",
      -- "catppuccin/nvim",
      -- "projekt0n/github-nvim-theme",
    },
    opts = { colorscheme = "onedark" },
    -- opts = { colorscheme = "catppuccin-latte" },
    -- opts = { colorscheme = "github_dark" },
    -- opts = { colorscheme = "tokyonight-night" },
  },
}
