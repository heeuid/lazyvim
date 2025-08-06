-- run script after autocmds.lua

vim.api.nvim_create_user_command('RefreshIndentation', function()
  local width, expandable = vim.fn.get_indent_and_type_from_file()
  if type(width) == "number" then
    vim.opt.tabstop = width
    vim.opt.shiftwidth = width
  end
  if type(expandable) == "boolean" then
    vim.opt.expandtab = expandable
  end
end, { desc = "Refresh Indentation from XXX/.nvim/indentation, e.g. \'2 space\'" })
