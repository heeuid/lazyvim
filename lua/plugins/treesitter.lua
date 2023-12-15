-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if false then return {} end

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
        "c",
        "rust",
        "lua",
        "python",
        "vim",
        "json",
        "xml",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "bash",
        "html",
        "json",
        "query",
        "regex",
      })
    end,
  },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  --{ import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "clangd",
        "pyright",
        "rust-analyzer",
        "bash-language-server",
        "json-lsp",
        "lemminx",
        "yaml-language-server",
        "taplo",
      },
    },
  },
}
