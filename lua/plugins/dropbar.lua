local version = vim.inspect(vim.version())
local current_v = { version["major"], version["minor"], version["patch"] }
local target_v = { 0, 10, 0 }
if vim.version.gt(current_v, target_v) or vim.version.eq(current_v, target_v) then
  return {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  }
else
  return {}
end
