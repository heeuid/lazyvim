local version = vim.inspect(vim.version())
local current_v = { version["major"], version["minor"], version["patch"] }
local target_v = { 0, 10, 0 }
if vim.version.gt(current_v, target_v) or vim.version.eq(current_v, target_v) then
  return {
    {
      "neovim/nvim-lspconfig",
      opts = {
        inlay_hints = {
          enabled = true,
        },
      },
    },
  }
else
  return {}
end
