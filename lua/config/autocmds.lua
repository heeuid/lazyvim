-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Color
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.rs",
  callback = function()
    vim.api.nvim_set_hl(0, "RustTypeHint", {
      fg = "#000000",
      bg = "#406060", --#80c0c0
    })
  end,
})

-- Filetype
local filetype_pattern_pairs = {
  { "t32", "*.cmm" },
}
for _, elem in pairs(filetype_pattern_pairs) do
  local filetype = elem[1]
  local pattern = elem[2]
  --vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
    pattern = pattern,
    callback = function()
      vim.bo.filetype = filetype
    end,
  })
end

-- Indentation
local event_indent_pairs = {
  { { "FileType" }, { "c", "make" }, 8, false },
  { { "FileType" }, { "lua", "dart" }, 2, true },
  {
    { "BufRead", "BufNewFile" },
    { "*.dts", "*.dtsi", "Kconfig*", "*_defconfig" },
    8,
    false,
  },
}
for _, elem in pairs(event_indent_pairs) do
  local events = elem[1]
  local patterns = elem[2]
  local tabspace = elem[3]
  local tab_expandable = elem[4]
  vim.api.nvim_create_autocmd(events, {
    pattern = patterns,
    callback = function()
      vim.opt.tabstop = tabspace
      vim.opt.shiftwidth = tabspace
      vim.opt.expandtab = tab_expandable
    end,
  })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("lazy.core.config").options.checker.notify = false
  end
})
