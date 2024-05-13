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
      codewindow.apply_default_keybinds()
    end,
  }
}

























