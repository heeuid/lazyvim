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
