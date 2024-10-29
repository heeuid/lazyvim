-- run script after autocmds.lua

vim.api.nvim_create_user_command('OpenGitui', function()
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

  vim.fn.termopen("gitui", {
    on_exit = function()
      vim.api.nvim_buf_delete(buf, {force = true})
    end
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

-- add chars at the ends of selected lines
local add_chars = function(dir)
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\x16' then
    vim.print("Only for visual mode; now is ...", mode)
    return
  end

  -- 사용자에게 앞뒤에 추가할 문자를 입력받음
  local prepend_text
  local append_text
  if not dir or dir == 'left' or dir == 'both' or dir == 'one-line' then
    prepend_text = vim.fn.input('Left String: ')
  else
    prepend_text = ''
  end
  if not dir or dir == 'right' or dir == 'both' or dir == 'one-line' then
    append_text = vim.fn.input('Right String: ')
  else
    append_text = ''
  end

  -- 현재 선택 영역의 정보를 가져옴
  vim.cmd([[execute "normal! \<ESC>"]])
  local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))

  -- 선택 영역의 텍스트를 가져옴
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  if dir == 'one-line' then
    if #lines == 1 then -- 한 줄만 선택된 경우
      local temp = lines[1]:sub(end_col + 1)
      lines[1] = lines[1]:sub(1, start_col - 1) .. prepend_text .. lines[1]:sub(start_col, end_col) .. append_text
      if end_col ~= vim.v.maxcol then
        lines[1] = lines[1] .. temp
      end
    else
      -- 여러 줄 선택된 경우, 첫 줄과 마지막 줄에만 문자 추가
      lines[1] = lines[1]:sub(1, start_col - 1) .. prepend_text .. lines[1]:sub(start_col)
      local temp = lines[#lines]:sub(end_col + 1)
      lines[#lines] = lines[#lines]:sub(1, end_col) .. append_text
      if end_col ~= vim.v.maxcol then
        lines[#lines] = lines[#lines] .. temp
      end
    end
  else
    for i, line in ipairs(lines) do
      if #line > 0 then -- 라인이 비어있지 않은 경우에만 작업 수행
        local temp = line:sub(end_col + 1)
        local new_line = line:sub(1, start_col - 1) ..
            prepend_text .. line:sub(start_col, end_col) .. append_text
        if end_col ~= vim.v.maxcol then
          lines[i] = new_line .. temp
        else
          lines[i] = new_line
        end
      end
    end
  end

  -- 수정된 텍스트로 선택 영역을 대체
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end

vim.api.nvim_create_user_command('AddCharsOne', function()
  add_chars('one-line')
end, {desc = "add chars to both ends"})
vim.api.nvim_create_user_command('AddCharsAll', function()
  add_chars()
end, {desc = "add chars to both ends for each line"})
vim.api.nvim_create_user_command('AddCharsLeftAll', function()
  add_chars('left')
end, {desc = "add chars to left ends for each line"})
vim.api.nvim_create_user_command('AddCharsRightAll', function()
  add_chars('right')
end, {desc = "add chars to right ends for each line"})

