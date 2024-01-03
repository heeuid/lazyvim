return {
  {
    "dhananjaylatkar/cscope_maps.nvim",
    ft = { "c", "cpp" },
    dependencies = {
      "folke/which-key.nvim",                -- optional [for whichkey hints]
      "nvim-telescope/telescope.nvim",       -- optional [for picker="telescope"]
      "ibhagwan/fzf-lua",                    -- optional [for picker="fzf-lua"]
      "nvim-tree/nvim-web-devicons",         -- optional [for devicons in telescope or fzf]
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
