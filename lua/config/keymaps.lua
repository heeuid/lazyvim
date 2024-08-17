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
    -----------------------------
    -- command mode, no prefix --
    -----------------------------
    { "<c-b>", "<Left>", desc = "move cursor left" , mode = "c" },
    { "<c-f>", "<Right>", desc = "move cursor right", mode = "c"  },
    { "<F1>", "<c-r>", desc = "list registers", mode = "c", remap = true },

    -- insert mode, no prefix
    { "<c-h>", "<Left>", desc = "move cursor left" , mode = "i"},
    { "<c-l>", "<Right>", desc = "move cursor right" , mode = "i"},
    -- { "<c-a>", "<Up>", "move cursor up", mode = "" },
    -- { "<c-d>", "<Down>", "move cursor down" },

    ----------------------------
    -- normal mode, no prefix --
    ----------------------------
    { "U", "<c-r>", desc = "Redo", mode = "n" },
    { "Q", "<cmd>q<cr>", desc = "Quit window (:q)", mode = "n" },
    { "<c-q>", "<cmd>q!<cr>", desc = "Quit window", mode = "n" },
    { "<tab>", "<cmd>bn<cr>", desc = "Next buffer", mode = "n" },
    { "<S-tab>", "<cmd>bp<cr>", desc = "Previous buffer", mode = "n" },

    ---------------------------
    -- normal mode, <leader> --
    ---------------------------
    { "<leader>a","<cmd>wa<cr>", desc = "Save All(:wa)", mode = "n" },
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zoom", mode = "n" },

    { "<leader>p", group = "copy" },
    { "<leader>pp", "<cmd>CopyPath<cr>", desc = "CopyPath", mode = "n" },
    { "<leader>pa", "<cmd>CopyAbsPath<cr>", desc = "CopyAbsPath", mode = "n" },
    { "<leader>pr", "<cmd>CopyRelPath<cr>", desc = "CopyRelPath", mode = "n" },

    { "<leader>l", group = "lazy" },
    { "<leader>ll", "<cmd>Lazy<cr>", desc = "Lazy", mode = "n" },
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit", mode = "n" },

    --------------------------------
    -- normal mode, <localleader> --
    --------------------------------
    { "<localleader>b", group = "buffers" },
    { "<localleader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump", mode = "n" },
    { "<localleader>bf", "<cmd>Telescope buffers previewer=false<cr>", desc = "Find", mode = "n" },
    { "<localleader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous", mode = "n" },
    { "<localleader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next", mode = "n" },
    { "<localleader>bW", "<cmd>noautocmd w<cr>", desc = "Save without formatting (noautocmd)", mode = "n" },
    { "<localleader>bw", "<cmd>BufferWipeout<cr>", desc = "Wipeout", mode = "n" },
    { "<localleader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick which buffer to close", mode = "n" },
    { "<localleader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left", mode = "n" },
    { "<localleader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right", mode = "n" },
    { "<localleader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory", mode = "n" },
    { "<localleader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language", mode = "n" },
    { "<localleader>bc", "<cmd>BufferKill<CR>", desc = "Close Buffer", mode = "n" },

    { "<localleader>c", group = "cscope" },
    { "<localleader>cs", get_cscope_prompt_cmd("s", "w"), desc = cscope_sym_map.s, mode = "n" },
    { "<localleader>cg", get_cscope_prompt_cmd("g", "w"), desc = cscope_sym_map.g, mode = "n" },
    { "<localleader>cc", get_cscope_prompt_cmd("c", "w"), desc = cscope_sym_map.c, mode = "n" },
    { "<localleader>ct", get_cscope_prompt_cmd("t", "w"), desc = cscope_sym_map.t, mode = "n" },
    { "<localleader>ce", get_cscope_prompt_cmd("e", "w"), desc = cscope_sym_map.e, mode = "n" },
    { "<localleader>cf", get_cscope_prompt_cmd("f", "f"), desc = cscope_sym_map.f, mode = "n" },
    { "<localleader>ci", get_cscope_prompt_cmd("i", "f"), desc = cscope_sym_map.i, mode = "n" },
    { "<localleader>cd", get_cscope_prompt_cmd("d", "w"), desc = cscope_sym_map.d, mode = "n" },
    { "<localleader>ca", get_cscope_prompt_cmd("a", "w"), desc = cscope_sym_map.a, mode = "n" },
    { "<localleader>cb", "<cmd>Cscope build<cr>", desc = cscope_sym_map.b, mode = "n" },

    { "<localleader>g", group = "git" },
    { "<localleader>gg", "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", desc = "Lazygit", mode = "n" },
    { "<localleader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk", mode = "n" },
    { "<localleader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev Hunk", mode = "n" },
    { "<localleader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Git Blame(Who Changed)", mode = "n" },
    { "<localleader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk", mode = "n" },
    { "<localleader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk", mode = "n" },
    { "<localleader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer", mode = "n" },
    { "<localleader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk", mode = "n" },
    { "<localleader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", mode = "n" },
    { "<localleader>go", "<cmd>Telescope git_status<cr>", desc = "Git Status(Open Changed Files)", mode = "n" },
    { "<localleader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Checkout Branch", mode = "n" },
    { "<localleader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Checkout Commit", mode = "n" },
    { "<localleader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Git Checkout commit(for current file)", mode = "n" },
    { "<localleader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff", mode = "n" },

    { "<localleader>i", group = "indentation" },
    { "<localleader>i2", function() change_indent(2) end, desc = "Indentation to 2", mode = "n" },
    { "<localleader>i4", function() change_indent(4) end, desc = "Indentation to 4", mode = "n" },
    { "<localleader>i8", function() change_indent(8) end, desc = "Indentation to 8", mode = "n" },

    { "<localleader>l", group = "lsp" },
    { "<localleader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", mode = "n" },
    { "<localleader>ld", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", desc = "Buffer Diagnostics", mode = "n" },
    { "<localleader>lW", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics", mode = "n" },
    { "<localleader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format", mode = "n" },
    { "<localleader>li", "<cmd>LspInfo<cr>", desc = "Info", mode = "n" },
    { "<localleader>lI", "<cmd>Mason<cr>", desc = "Mason Info", mode = "n" },
    { "<localleader>ln", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic", mode = "n" },
    { "<localleader>lp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic", mode = "n" },
    { "<localleader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action", mode = "n" },
    { "<localleader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix", mode = "n" },
    { "<localleader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", mode = "n" },
    { "<localleader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols", mode = "n" },
    { "<localleader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols", mode = "n" },
    { "<localleader>le", "<cmd>Telescope quickfix<cr>", desc = "Telescope Quickfix", mode = "n" },
    { "<localleader>lD", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type Def.", mode = "n" },
    { "<localleader>lK", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover Explanation", mode = "n" },
    { "<localleader>lh", "<cmd>InlayHintsToggle<cr>", desc = "Toggle Inlay Hints", mode = "n" },
    { "<localleader>lv", "<cmd>Vista nvim_lsp<cr>", desc = "view code map (like tagbar; 'Vista nvim_lsp')", mode = "n" },

    { "<localleader>lw", group = "lsp workspace" },
    { "<localleader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", desc = "Add Workspace", mode = "n" },
    { "<localleader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", desc = "Remove Workspace", mode = "n" },
    { "<localleader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", desc = "List Workspace", mode = "n" },

    { "<localleader>lg", group = "lsp goto..." },
    { "<localleader>lgd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Goto definition", mode = "n" },
    { "<localleader>lgD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Goto Declaration", mode = "n" },
    { "<localleader>lgr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Goto references", mode = "n" },
    { "<localleader>lgi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Goto Implementation", mode = "n" },
    { "<localleader>lgs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Show signature help", mode = "n" },

    { "<localleader>p", group = "lazy plugins" },
    { "<localleader>pi", "<cmd>Lazy install<cr>", desc = "Install", mode = "n" },
    { "<localleader>ps", "<cmd>Lazy sync<cr>", desc = "Sync", mode = "n" },
    { "<localleader>pS", "<cmd>Lazy clear<cr>", desc = "Status", mode = "n" },
    { "<localleader>pc", "<cmd>Lazy clean<cr>", desc = "Clean", mode = "n" },
    { "<localleader>pu", "<cmd>Lazy update<cr>", desc = "Update", mode = "n" },
    { "<localleader>pp", "<cmd>Lazy profile<cr>", desc = "Profile", mode = "n" },
    { "<localleader>pl", "<cmd>Lazy log<cr>", desc = "Log", mode = "n" },
    { "<localleader>pd", "<cmd>Lazy debug<cr>", desc = "Debug", mode = "n" },

    { "<localleader>t", group = "tagbar|telescope" },
    { "<localleader>ta", "<cmd>Tagbar<cr>", desc = "Tagbar", mode = "n" },
    { "<localleader>te", "<cmd>Telescope<cr>", desc = "Telescope", mode = "n" },

    { "<localleader>w", group = "workspace" },
    { "<localleader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", desc = "Add Workspace", mode = "n" },
    { "<localleader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", desc = "Remove Workspace", mode = "n" },
    { "<localleader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", desc = "List Workspace", mode = "n" },

    { "<localleader>T", group = "lazy plugins" },
    { "<localleader>Ti", ":TSConfigInfo<cr>", desc = "Info", mode = "n" },
  })
end
