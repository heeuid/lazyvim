return {
  { -- enable inlay_hints with snacks toggle function (<space>uh)
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },
}
