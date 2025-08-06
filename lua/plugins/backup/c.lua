local ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }
return {
  {
    "dhananjaylatkar/cscope_maps.nvim",
    ft = ft,
    dependencies = {
      "folke/which-key.nvim",          -- optional [for whichkey hints]
      "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
      "ibhagwan/fzf-lua",              -- optional [for picker="fzf-lua"]
      "nvim-tree/nvim-web-devicons",   -- optional [for devicons in telescope or fzf]
    },
    opts = {
      disable_maps = true,
      -- skip_input_prompt = false, -- "true" doesn't ask for input

      -- -- cscope related defaults
      -- cscope = {
      --     -- location of cscope db file
      --     db_file = "./cscope.out",
      --     -- cscope executable
      --     exec = "cscope", -- "cscope" or "gtags-cscope"
      --     -- choose your fav picker
      --     picker = "quickfix", -- "telescope", "fzf-lua" or "quickfix"
      --     -- "true" does not open picker for single result, just JUMP
      --     skip_picker_for_single_result = false, -- "false" or "true"
      --     -- these args are directly passed to "cscope -f <db_file> <args>"
      --     db_build_cmd_args = { "-bqkv" },
      --     -- statusline indicator, default is cscope executable
      --     statusline_indicator = nil,
      -- },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = ft,
    keys = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = function()
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({
              mode = "n",
              { "<localleader>C", group = "Clangd Extensions" },
              { "<localleader>Ca", "<cmd>ClangdAST<cr>", desc = "[a]bstract structure" },
              { "<localleader>Ch", "<cmd>ClangdToggleInlayHints<cr>", desc = "toggle inlay [h]ints" },
              { "<localleader>Cm", "<cmd>ClangdMemoryUsage<cr>", desc = "[m]emory usage" },
              { "<localleader>Ct", "<cmd>ClangdTypeHierarchy<cr>", desc = "[t]ype hierarchy" },
              { "<localleader>Cs", "<cmd>ClangdSymbolInfo<cr>", desc = "[s]ymbol info" },
              { "<localleader>Cw", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "s[w]itch source/header" },
            })
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
