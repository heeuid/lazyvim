-- run script after autocmds.lua

vim.api.nvim_create_user_command('ToggleDiagnosticVText', function()
  local opts = vim.diagnostic.config()
  if opts then
    vim.diagnostic.config({ virtual_text = not opts.virtual_text })
  end
end, {desc = 'toggle virtual text of diagnostic'})

vim.api.nvim_create_user_command('ToggleDiagnostic', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.diagnostic.config({ virtual_text = true })
end, {desc = 'toggle diagnostic'})

vim.api.nvim_create_user_command('InlayHintsToggle', function()
  local enabled = vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(not enabled)
  vim.notify('inlay hints: ' .. vim.inspect(not enabled))
end, {desc = "toggle inlay hints"})

vim.api.nvim_create_user_command('Gitui', function()
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)

  local win_height = math.ceil(height * 0.8)
  local win_width = math.ceil(width * 0.9)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded"
  }

  -- new buffer for new window
  local buf = vim.api.nvim_create_buf(false, true)

  -- open floating window
  local _ = vim.api.nvim_open_win(buf, true, opts)

  local debug = function(_, data, event)
    if data then
      local msg = event .. "!\n" .. vim.inspect(data)
      vim.notify(msg)
    end
  end

  vim.fn.termopen("gitui", {
    on_exit = function()
      vim.api.nvim_buf_delete(buf, {force = true})
    end,
    on_stderr = debug,
    on_stdout = debug,
    stderr_buffered = true,
    stdout_buffered = true,
  })

  -- terminal mode
  vim.cmd("startinsert")
end, { desc = 'open `gitui`' })

vim.api.nvim_create_user_command('CopyAbsPath', function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  require("notify").dismiss({ silent = true, pending = true })
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command('CopyRelPath', function()
  local path = vim.fn.expand("%:t")
  vim.fn.setreg("+", path)
  require("notify").dismiss({ silent = true, pending = true })
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command('CopyPath', function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  require("notify").dismiss({ silent = true, pending = true })
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

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
