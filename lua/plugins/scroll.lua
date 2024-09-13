return {
  {
    'dstein64/nvim-scrollview',
    config = function()
      require('scrollview').setup({
        current_only = true,
        base = 'right',
        signs_on_startup = { 'all' },
        diagnostics_severities = { vim.diagnostic.severity.ERROR }
      })
    end
  },
  {
    'gorbit99/codewindow.nvim',
    config = function()
      local codewindow = require('codewindow')
      codewindow.setup()

      local ok, wk = pcall(require, "which-key")

      if not ok then
        codewindow.apply_default_keybinds()
      else
        wk.add({
          mode = "n",
          { '<leader>m', group = "minimap scroll" },
          { '<leader>mo', codewindow.open_minimap, desc = "Open minimap" },
          { '<leader>mf', codewindow.toggle_focus, desc = "Toggle minimap focus" },
          { '<leader>mc', codewindow.close_minimap, desc = "Close minimap" },
          { '<leader>mm', codewindow.toggle_minimap, desc = "Toggle minimap" },
        })
      end
    end,
  }
}

























