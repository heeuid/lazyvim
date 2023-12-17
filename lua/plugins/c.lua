return {
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp" },
    keys = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function()
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.register({
              C = {
                name = "Clangd Extensions",
                a = { "<cmd>ClangdAST<cr>", "[a]bstract structure" },
                h = { "<cmd>ClangdToggleInlayHints<cr>", "toggle inlay [h]ints" },
                m = { "<cmd>ClangdMemoryUsage<cr>", "[m]emory usage" },
                t = { "<cmd>ClangdTypeHierarchy<cr>", "[t]ype hierarchy" },
                s = { "<cmd>ClangdSymbolInfo<cr>", "[s]ymbol info" },
                w = { "<cmd>ClangdSwitchSourceHeader<cr>", "s[w]itch source/header" },
              },
            }, { prefix = "<localleader>" })
          end
        end,
      })
    end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
          type = "[type]",
          declaration = "[decl]",
          expression = "[expr]",
          specifier = "[spec]",
          statement = "[stmt]",
          ["template argument"] = "[tmpl]",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },
}
