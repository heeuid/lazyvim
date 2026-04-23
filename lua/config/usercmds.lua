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

vim.api.nvim_create_user_command('TN', function(opts)
  local nargs = #opts.fargs
  if nargs == 0 then
    vim.cmd("tab split")
  else
    vim.cmd("tabedit " .. opts.fargs[1])
  end
end, { nargs = "?", complete = "file" })

vim.api.nvim_create_user_command('TC', function(opts)
  local nargs = #opts.fargs
  if nargs == 0 then
    vim.cmd("tabclose")
  else
    local args = opts.fargs
    table.sort(args, function(a, b) return a > b end)
    for _, tab in ipairs(args) do
      vim.cmd("tabclose " .. tab)
    end
  end
end, { nargs = "*" })

vim.api.nvim_create_user_command("Snacks", function(opts)
  local snacks = require("snacks")
  local cmd = opts.args

  -- 1. 인자가 없으면 picker 목록(pickers)을 실행
  if cmd == "" then
    snacks.picker.pickers()
    return
  end

  -- 2. <CMD>가 snacks.picker 내에 존재하고 함수라면 실행
  if snacks.picker[cmd] and type(snacks.picker[cmd]) == "function" then
    snacks.picker[cmd]()
  else
    vim.notify("Snacks.picker에 '" .. cmd .. "' 기능이 없습니다.", vim.log.levels.ERROR)
  end
end, {
  nargs = "?", -- 인자를 선택적으로 받을 수 있음
  -- 자동완성 기능 (Tab 키로 목록 확인 가능)
  complete = function(ArgLead, CmdLine, CursorPos)
    local keys = {}
    for k, v in pairs(require("snacks").picker) do
      if type(v) == "function" and not k:find("^_") then -- 내부 함수(_) 제외
        table.insert(keys, k)
      end
    end
    table.sort(keys)
    return keys
  end
})

vim.api.nvim_create_user_command('GitDiffCommits', function()
  local ok, _ = pcall(require, 'codediff')
  if not ok then
    vim.notify("Need codediff.nvim")
    return
  end


  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("Need fzf-lua.nvim")
    return
  end

  local git_root = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
  local abs_file = vim.api.nvim_buf_get_name(0)
  if abs_file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  -- local git_file = abs_file:sub(#git_root + 2)
  local wt = "0000000"

  local function strip_ansi(str)
    return str:gsub("\27%[[0-9;]*m", "")
  end

  local function rev_label(rev)
    if rev == wt then return "(working tree)" end
    return rev
  end

  local wt_log_cmd = "echo \"" .. wt .. " (working tree)\""
  local git_log_n_cmd = "git log --color=always --oneline" -- .. " -- " .. git_file
  local git_log_1_cmd = "git log {1} -1 --stat"            -- .. " -- " .. git_file

  fzf.fzf_exec(wt_log_cmd .. " && " .. git_log_n_cmd, {
    prompt = "BASE> ",
    fzf_opts = {
      ["--ansi"] = "",
      ["--header"] = "Select BASE commit for diff", -- .. " | File: " .. git_file,
      ["--preview"] = "cd " .. git_root
          .. " && if [ \"{1}\" = \"'" .. wt .. "'\" ]; then "
          .. "echo \"working tree\"; else " .. git_log_1_cmd .. "; fi",
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local base = strip_ansi(selected[1]):match("^(%S+)")

        fzf.fzf_exec(git_log_n_cmd, {
          prompt = "TARGET> ",
          fzf_opts = {
            ["--ansi"] = "",
            ["--header"] = "BASE: " .. rev_label(base) .. ", Select TARGET commit for diff", -- .. " | File: " -- .. git_file,
            ["--preview"] = "cd " .. git_root .. " && " .. git_log_1_cmd
          },
          actions = {
            ["default"] = function(selected2)
              if not selected2 or #selected2 == 0 then return end
              local target = strip_ansi(selected2[1]):match("^(%S+)")

              -- Target: left split, Base: right split
              vim.schedule(function()
                if base == wt then
                  vim.api.nvim_command("CodeDiff " .. target)
                else
                  vim.api.nvim_command("CodeDiff " .. base .. " " .. target)
                end
              end)
            end,
          }
        })
      end
    }
  })
end, { desc = "Git diff between two selected commits (fzf)" })
