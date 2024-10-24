function open_gitui_floating()
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

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

  -- opn floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.fn.termopen("gitui", {
    on_exit = function()
      vim.api.nvim_buf_delete(buf, {force = true})
    end
  })

  -- terminal mode
  vim.cmd("startinsert")
end

vim.api.nvim_create_user_command('OpenGitui', open_gitui_floating, { desc = 'open `gitui`' })

return {
  "sindrets/diffview.nvim",
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    -- keys = {
    --   { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    -- }
  }
}
