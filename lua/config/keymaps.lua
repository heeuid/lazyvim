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
  local sel = "cword" -- word under cursor
  if selection == "f" then -- file under cursor
    sel = "cfile"
  end

  return string.format(
    [[<cmd>lua require('cscope_maps').cscope_prompt('%s', vim.fn.expand("<%s>"))<cr>]],
    operation,
    sel
  )
end
local cscope_cmd_opt = function(operation, selection)
  local ret = {
    get_cscope_prompt_cmd(operation, selection),
    cscope_sym_map[operation],
  }
  return ret
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
  wk.register({
    a = { "<cmd>wa<cr>", "Save All(:wa)" },
    z = { "<cmd>w<cr>", "Save(:w)" },
  }, { prefix = "<leader>" })
  wk.register({
    b = {
      name = "Buffers",
      j = { "<cmd>BufferLinePick<cr>", "Jump" },
      f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
      b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
      n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
      W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
      -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
      e = {
        "<cmd>BufferLinePickClose<cr>",
        "Pick which buffer to close",
      },
      h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
      l = {
        "<cmd>BufferLineCloseRight<cr>",
        "Close all to the right",
      },
      D = {
        "<cmd>BufferLineSortByDirectory<cr>",
        "Sort by directory",
      },
      L = {
        "<cmd>BufferLineSortByExtension<cr>",
        "Sort by language",
      },
      c = { "<cmd>BufferKill<CR>", "Close Buffer" },
    },
    c = {
      name = "Cscope",
      s = cscope_cmd_opt("s", "w"),
      g = cscope_cmd_opt("g", "w"),
      c = cscope_cmd_opt("c", "w"),
      t = cscope_cmd_opt("t", "w"),
      e = cscope_cmd_opt("e", "w"),
      f = cscope_cmd_opt("f", "f"),
      i = cscope_cmd_opt("i", "f"),
      d = cscope_cmd_opt("d", "w"),
      a = cscope_cmd_opt("a", "w"),
      b = { "<cmd>Cscope build<cr>", cscope_sym_map.b },
    },
    g = {
      name = "git",
      g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
      j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
      l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Git Blame(Who Changed)" },
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
      s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
      u = {
        "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
        "Undo Stage Hunk",
      },
      o = { "<cmd>Telescope git_status<cr>", "Git Status(Open Changed Files)" },
      b = { "<cmd>Telescope git_branches<cr>", "Git Checkout Branch" },
      c = { "<cmd>Telescope git_commits<cr>", "Git Checkout Commit" },
      C = {
        "<cmd>Telescope git_bcommits<cr>",
        "Git Checkout commit(for current file)",
      },
      d = {
        "<cmd>Gitsigns diffthis HEAD<cr>",
        "Git Diff",
      },
    },
    i = {
      name = "indentation",
      ["2"] = {
        function()
          change_indent(2)
        end,
        "Indentation to 2",
      },
      ["4"] = {
        function()
          change_indent(4)
        end,
        "Indentation to 4",
      },
      ["8"] = {
        function()
          change_indent(8)
        end,
        "Indentation to 8",
      },
    },
    l = {
      name = "lsp",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
      W = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
      f = { "<cmd>lua require('lvim.lsp.utils').format()<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>Mason<cr>", "Mason Info" },
      n = {
        "<cmd>lua vim.diagnostic.goto_next()<cr>",
        "Next Diagnostic",
      },
      p = {
        "<cmd>lua vim.diagnostic.goto_prev()<cr>",
        "Prev Diagnostic",
      },
      l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
      q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
      S = {
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        "Workspace Symbols",
      },
      e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
      w = {
        name = "workspace",
        a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add Workspace" },
        r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove Workspace" },
        l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List Workspace" },
      },
      D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Def." },
      K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Explanation" },
      g = {
        name = "goto...",
        d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Declaration" },
        r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto references" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto Implementation" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show signature help" },
      },
    },
    p = {
      name = "Lazy Plugins",
      i = { "<cmd>Lazy install<cr>", "Install" },
      s = { "<cmd>Lazy sync<cr>", "Sync" },
      S = { "<cmd>Lazy clear<cr>", "Status" },
      c = { "<cmd>Lazy clean<cr>", "Clean" },
      u = { "<cmd>Lazy update<cr>", "Update" },
      p = { "<cmd>Lazy profile<cr>", "Profile" },
      l = { "<cmd>Lazy log<cr>", "Log" },
      d = { "<cmd>Lazy debug<cr>", "Debug" },
    },
    t = { "<cmd>Tagbar<cr>", "Tagbar" },
    w = {
      name = "workspace",
      a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add Workspace" },
      r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove Workspace" },
      l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List Workspace" },
    },
    T = {
      name = "Treesitter",
      i = { ":TSConfigInfo<cr>", "Info" },
    },
  }, { prefix = "<localleader>" })
end
