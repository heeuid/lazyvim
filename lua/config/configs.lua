-- run after autocmds.lua

require'lspconfig'.lua_ls.manager.config.settings.Lua.hint = {
  enable = true
}

local cmp = require'cmp'
cmp.setup{
  window={
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
}
