return {
  "NvChad/nvim-colorizer.lua",
  lazy = false,
  config = function()
    require("colorizer").setup({
      filetypes = {
        "*", -- Highlight all files, but customize some others.
        cmp_docs = { always_update = true },
      },
    })
  end,
}
