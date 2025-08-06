return {
  "kylechui/nvim-surround", -- good for mini.surround (S => visual => S: add string)
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup()
  end
}
