-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add more treesitter parsers
  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "t32",
        "verilog",
        "vim",
        "xml",
        "toml",
        "bash",
        "html",
        "markdown",
        "markdown_inline",
        "latex",
        -- "regex",
        -- "query",
        --"c",
        --"rust",
        --"python",
        --"lua",
        --"json",
        --"yaml",
      })
    end,
  },
}
