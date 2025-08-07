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

local lspconfig
ok, lspconfig = pcall(require, 'lspconfig')
if ok then
  lspconfig.lua_ls.setup {
    settings = {
      Lua = {
        hint = {
          arrayIndex = true,
          enable = true,
          paramName = true,
          paramType = true,
          semicolon = true,
          setType = true,
        }
      }
    }
  }
end

