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
  { { "FileType" }, { "c", "make" },   8, false },
  { { "FileType" }, { "lua", "dart" }, 2, true },
  {
    { "BufRead", "BufNewFile" },
    { "*.dts",   "*.dtsi",    "Kconfig*", "*_defconfig" },
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

vim.cmd([[autocmd BufEnter * checktime]])

-- to solve tab error for insert mode s.t. jump to somewhere
vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    -- stop snippets when you leave to normal mode
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
      require('luasnip').unlink_current()
    end
  end
})

-------------------
-- User Commands --
-------------------

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
    prepend_text = vim.fn.input('각 라인 첫 문자 변경: ')
  else
    prepend_text = ''
  end
  if not dir or dir == 'right' or dir == 'both' or dir == 'one-line' then
    append_text = vim.fn.input('각 라인 마지막 문자 변경: ')
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
end, {})
vim.api.nvim_create_user_command('AddCharsAll', function()
  add_chars()
end, {})
vim.api.nvim_create_user_command('AddCharsLeftAll', function()
  add_chars('left')
end, {})
vim.api.nvim_create_user_command('AddCharsRightAll', function()
  add_chars('right')
end, {})

vim.api.nvim_set_keymap('v', '<leader>ac', "<cmd>AddCharsOne<cr>", { noremap = true, desc = "add chars to both ends" })
vim.api.nvim_set_keymap('v', '<leader>aa', "<cmd>AddCharsAll<cr>",
  { noremap = true, desc = "add chars to both ends for each line" })
vim.api.nvim_set_keymap('v', '<leader>ah', "<cmd>AddCharsLeftAll<cr>",
  { noremap = true, desc = "add chars to left end for each line" })
vim.api.nvim_set_keymap('v', '<leader>al', "<cmd>AddCharsRightAll<cr>",
  { noremap = true, desc = "addr chars to right end for each line" })
