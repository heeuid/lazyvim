-- run after autocmds.lua

local ok, snack = pcall(require, 'snacks')
if ok then
  if snack.animate.enabled() then
    vim.g.snacks_animate = false
  end
end

-- "debug" for debugging
vim.lsp.set_log_level("off")
vim.g.clipboard = "osc52"
