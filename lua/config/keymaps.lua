-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

----------------------------
-- Delete Default Keymaps --
----------------------------

------------------------
-- Add Custom Keymaps --
------------------------

local cscope_sym_map = {
  s = "Find this symbol",
  g = "Find this global defination",
  c = "Find functions calling this function",
  t = "Find this text string",
  e = "Find this egrep pattern",
  f = "Find this file",
  i = "Find files #including this file",
  d = "Find functions called by this function",
  a = "Find places where this symbol is assigned a value",
  b = "Build database",
}

local get_cscope_prompt_cmd = function(operation, selection)
  local sel = "cword"      -- word under cursor
  if selection == "f" then -- file under cursor
    sel = "cfile"
  end

  return function()
    require("cscope_maps").cscope_prompt(operation, vim.fn.expand("<" .. sel .. ">"))
  end
end

local function change_indent(n)
  vim.opt.tabstop = n
  vim.opt.shiftwidth = n
  if n == 8 then
    vim.opt.expandtab = false
  else
    vim.opt.expandtab = true
  end
end

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    {
      mode = "c", -- command mode
      { "<c-b>", "<Left>", desc = "move cursor left"  },
      { "<c-f>", "<Right>", desc = "move cursor right"  },
      { "<F1>", "<c-r>", desc = "list registers", remap = true },
    },
    {
      mode = "i", -- insert mode
      { "<c-h>", "<Left>", desc = "move cursor left" },
      { "<c-l>", "<Right>", desc = "move cursor right" },
      -- { "<c-a>", "<Up>", "move cursor up", mode = "" },
      -- { "<c-d>", "<Down>", "move cursor down" },
    },
    {
      mode = "v", -- visual mode
      { "<leader>a", group = "append str" },
      { "<leader>ac", "<cmd>AddCharsOne<cr>", desc = "add chars to both ends", noremap = true },
      { "<leader>aa", "<cmd>AddCharsAll<cr>", desc = "add chars to both ends for each line", noremap = true },
      { "<leader>ah", "<cmd>AddCharsLeftAll<cr>", desc = "add chars to left end for each line", noremap = true },
      { "<leader>al", "<cmd>AddCharsRightAll<cr>", desc = "add chars to right end for each line", noremap = true },
    },
    {
      mode = "n", -- normal mode
      { "U", "<c-r>", desc = "Redo" },
      { "Q", "<cmd>q<cr>", desc = "Quit window (:q)" },
      { "<c-q>", "<cmd>q!<cr>", desc = "Quit window" },
      { "<tab>", "<cmd>bn<cr>", desc = "Next buffer" },
      { "<S-tab>", "<cmd>bp<cr>", desc = "Previous buffer" },

      { "<leader>a","<cmd>wa<cr>", desc = "Save All(:wa)" },
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zoom" },

      { "<leader>p", group = "copy" },
      { "<leader>pp", "<cmd>CopyPath<cr>", desc = "CopyPath" },
      { "<leader>pa", "<cmd>CopyAbsPath<cr>", desc = "CopyAbsPath" },
      { "<leader>pr", "<cmd>CopyRelPath<cr>", desc = "CopyRelPath" },

      { "<leader>l", group = "lazy" },
      { "<leader>ll", "<cmd>Lazy<cr>", desc = "Lazy" },
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },

      { "<localleader>b", group = "buffers" },
      { "<localleader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
      { "<localleader>bf", "<cmd>Telescope buffers previewer=false<cr>", desc = "Find" },
      { "<localleader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
      { "<localleader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
      { "<localleader>bW", "<cmd>noautocmd w<cr>", desc = "Save without formatting (noautocmd)" },
      { "<localleader>bw", "<cmd>BufferWipeout<cr>", desc = "Wipeout" },
      { "<localleader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick which buffer to close" },
      { "<localleader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
      { "<localleader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
      { "<localleader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
      { "<localleader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language" },
      { "<localleader>bc", "<cmd>BufferKill<CR>", desc = "Close Buffer" },

      { "<localleader>c", group = "cscope" },
      { "<localleader>cs", get_cscope_prompt_cmd("s", "w"), desc = cscope_sym_map.s },
      { "<localleader>cg", get_cscope_prompt_cmd("g", "w"), desc = cscope_sym_map.g },
      { "<localleader>cc", get_cscope_prompt_cmd("c", "w"), desc = cscope_sym_map.c },
      { "<localleader>ct", get_cscope_prompt_cmd("t", "w"), desc = cscope_sym_map.t },
      { "<localleader>ce", get_cscope_prompt_cmd("e", "w"), desc = cscope_sym_map.e },
      { "<localleader>cf", get_cscope_prompt_cmd("f", "f"), desc = cscope_sym_map.f },
      { "<localleader>ci", get_cscope_prompt_cmd("i", "f"), desc = cscope_sym_map.i },
      { "<localleader>cd", get_cscope_prompt_cmd("d", "w"), desc = cscope_sym_map.d },
      { "<localleader>ca", get_cscope_prompt_cmd("a", "w"), desc = cscope_sym_map.a },
      { "<localleader>cb", "<cmd>Cscope build<cr>", desc = cscope_sym_map.b },

      { "<localleader>g", group = "git" },
      { "<localleader>gg", "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", desc = "Lazygit" },
      { "<localleader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk" },
      { "<localleader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev Hunk" },
      { "<localleader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Git Blame(Who Changed)" },
      { "<localleader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
      { "<localleader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
      { "<localleader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
      { "<localleader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
      { "<localleader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
      { "<localleader>go", "<cmd>Telescope git_status<cr>", desc = "Git Status(Open Changed Files)" },
      { "<localleader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Checkout Branch" },
      { "<localleader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Checkout Commit" },
      { "<localleader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Git Checkout commit(for current file)" },
      { "<localleader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },

      { "<localleader>i", group = "indentation" },
      { "<localleader>i2", function() change_indent(2) end, desc = "Indentation to 2" },
      { "<localleader>i4", function() change_indent(4) end, desc = "Indentation to 4" },
      { "<localleader>i8", function() change_indent(8) end, desc = "Indentation to 8" },
      { "<localleader>ir", "<cmd>RefreshIndentation<cr>", desc = "Refresh from .nvim/indentation" },

      { "<localleader>l", group = "lsp" },
      { "<localleader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
      { "<localleader>ld", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", desc = "Buffer Diagnostics" },
      { "<localleader>lW", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<localleader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format" },
      { "<localleader>li", "<cmd>LspInfo<cr>", desc = "Info" },
      { "<localleader>lI", "<cmd>Mason<cr>", desc = "Mason Info" },
      { "<localleader>ln", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
      { "<localleader>lp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
      { "<localleader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
      { "<localleader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
      { "<localleader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
      { "<localleader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<localleader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<localleader>le", "<cmd>Telescope quickfix<cr>", desc = "Telescope Quickfix" },
      { "<localleader>lD", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type Def." },
      { "<localleader>lK", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover Explanation" },
      { "<localleader>lh", "<cmd>InlayHintsToggle<cr>", desc = "Toggle Inlay Hints" },
      { "<localleader>lv", "<cmd>Vista nvim_lsp<cr>", desc = "view code map (like tagbar; 'Vista nvim_lsp')" },

      { "<localleader>lw", group = "lsp workspace" },
      { "<localleader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", desc = "Add Workspace" },
      { "<localleader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", desc = "Remove Workspace" },
      { "<localleader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", desc = "List Workspace" },

      { "<localleader>lg", group = "lsp goto..." },
      { "<localleader>lgd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Goto definition" },
      { "<localleader>lgD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Goto Declaration" },
      { "<localleader>lgr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Goto references" },
      { "<localleader>lgi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Goto Implementation" },
      { "<localleader>lgs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Show signature help" },

      { "<localleader>p", group = "lazy plugins" },
      { "<localleader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
      { "<localleader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
      { "<localleader>pS", "<cmd>Lazy clear<cr>", desc = "Status" },
      { "<localleader>pc", "<cmd>Lazy clean<cr>", desc = "Clean" },
      { "<localleader>pu", "<cmd>Lazy update<cr>", desc = "Update" },
      { "<localleader>pp", "<cmd>Lazy profile<cr>", desc = "Profile" },
      { "<localleader>pl", "<cmd>Lazy log<cr>", desc = "Log" },
      { "<localleader>pd", "<cmd>Lazy debug<cr>", desc = "Debug" },

      { "<localleader>t", group = "tagbar|telescope" },
      { "<localleader>ta", "<cmd>Tagbar<cr>", desc = "Tagbar" },
      { "<localleader>te", "<cmd>Telescope<cr>", desc = "Telescope" },

      { "<localleader>w", group = "workspace" },
      { "<localleader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", desc = "Add Workspace" },
      { "<localleader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", desc = "Remove Workspace" },
      { "<localleader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", desc = "List Workspace" },

      { "<localleader>T", group = "lazy plugins" },
      { "<localleader>Ti", ":TSConfigInfo<cr>", desc = "Info" },
    },
  })
end
