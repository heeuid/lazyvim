-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Color
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.api.nvim_set_hl(0, "LspInlayHint", {
      fg = "#406060"
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
vim.fn.get_indent_and_type_from_file = function()
  local indentation_file = vim.fs.find({ ".nvim/indentation" }, { type = 'file', upward = true })
  if next(indentation_file) == nil then
    return
  end
  local file = io.open(indentation_file[1], 'r')
  if not file then
    return
  end

  local content = file:read("*a")
  file:close()

  content = vim.fn.trim(content:match("[ \t\n]*[0-9]+[ \t\n]+[a-zA-Z]+[ \t\n]*"))
  content = vim.fn.split(content)
  local width = content[1]
  local tab_or_space = content[2]
  local expandable = nil
  if type(tab_or_space) == "string" then
    local _type = string.lower(vim.fn.trim(tab_or_space))
    if _type == "tab" then
      expandable = false
    elseif _type == "space" then
      expandable = true
    end
  end
  if type(width) == "string" then
    width = tonumber(vim.fn.trim(width))
  else
    width = nil
  end

  return width, expandable
end

local event_indent_pairs = {
  { { "FileType" }, { "c", "make" },   8, false },
  { { "FileType" }, { "lua", "dart", "markdown" }, 2, true },
  {
    { "BufRead", "BufNewFile" },
    { "*.dts",   "*.dtsi",    "Kconfig*", "*_defconfig" },
    8,
    false,
  },
}
-- '.nvim/indentation' has higher priority than upper table info.
for _, elem in pairs(event_indent_pairs) do
  local events = elem[1]
  local patterns = elem[2]
  local tabspace = elem[3]
  local tab_expandable = elem[4]
  vim.api.nvim_create_autocmd(events, {
    pattern = patterns,
    callback = function()
      local _tabspace, _tab_expandable = vim.fn.get_indent_and_type_from_file()
      if type(_tabspace) == "number" then
        tabspace = _tabspace
      end
      if type(_tab_expandable) == "boolean" then
        tab_expandable = _tab_expandable
      end
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

vim.cmd([[autocmd BufEnter * checktime]])

-- to solve tab error for insert mode s.t. jump to somewhere
-- vim.api.nvim_create_autocmd("ModeChanged", {
--   callback = function()
--     -- stop snippets when you leave to normal mode
--     if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
--         and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
--         and not require('luasnip').session.jump_active
--     then
--       require('luasnip').unlink_current()
--     end
--   end
-- })
--

-- run .nvim/*.lua
vim.fn.find_nvim_dir_upward = function(cwd)
    local current_dir = cwd
    while current_dir ~= "/" do
        local nvim_path = current_dir .. "/.nvim"
        if vim.fn.isdirectory(nvim_path) == 1 then
            return nvim_path
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end
    return nil
end
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local lua_dir = vim.fn.find_nvim_dir_upward(vim.fn.getcwd())

    if not lua_dir then
      return
    end

    local lua_file = vim.fs.find(function(name, _)
      return name:match('.*%.lua')
    end, { type = 'file', limit = math.huge, path = lua_dir })

    for _, file in pairs(lua_file) do
      dofile(file)
    end

    vim.notify('run ' .. vim.inspect(lua_file))
  end
})

-- enable inlay-hint of lua lsp server
local lspconfig = require'lspconfig'
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.lua",
  callback = function()
    lspconfig.lua_ls.manager.config.settings.Lua.hint = {
      enable = true
    }
  end
})

-- control scrollview column
local ok = pcall(require, 'scrollview')
if ok then
  vim.api.nvim_create_autocmd({"WinEnter", "WinResized"}, {
    callback = function()
      local win_width = vim.api.nvim_win_get_width(0) -- window size
      local sign_column_width = 3 -- empty line btw line-num and contents
      local content_width = win_width - sign_column_width
      if vim.wo.number or vim.wo.relativenumber then
        local max_line_number = vim.api.nvim_buf_line_count(0) -- current buffer maximum line-num
        local number_column_width = math.max(4, #tostring(max_line_number)) -- size of string of line-num
        content_width = content_width - number_column_width
      end
      vim.g.scrollview_column = content_width
    end
  })
end

-- run usercmds.lua and configs.lua
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require('config.usercmds')
    require('config.configs')
  end
})
