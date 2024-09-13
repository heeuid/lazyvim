return {
  "nosduco/remote-sshfs.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-telescope/telescope.nvim" }, -- optional if you declare plugin somewhere else
  config = function()
    require("remote-sshfs").setup({})

    require("telescope").load_extension("remote-sshfs")

    local util = require("lazyvim.util")
    local telescope_find_files = util.pick("files", {})
    local telescope_live_grep = util.pick("live_grep", {})
    -- local util_telescope = require("lazyvim.util.telescope")
    -- local telescope_find_files = util_telescope("files", {})
    -- local telescope_live_grep = util_telescope("live_grep", {})
    local connections = require("remote-sshfs.connections")

    local api = require("remote-sshfs.api")
    local ok, wk = pcall(require, "which-key")

    local find_file = function()
      if connections.is_connected() then
        api.find_files({})
      else
        telescope_find_files()
        --builtin.find_files()
      end
    end

    local live_grep = function()
      if connections.is_connected() then
        api.live_grep({})
      else
        telescope_live_grep()
        --builtin.live_grep()
      end
    end

    local connect = function()
      local cmd = vim.fn.input("<user>@<hostname>:<path>")
      if cmd ~= "" then
        local host = require'remote-sshfs.utils'.parse_host_from_command(cmd)
        require'remote-sshfs.connections'.connect(host)
      else
        api.connect({})
      end
    end

    local is_connected = function() print(connections.is_connected()) end

    if not ok then
      vim.keymap.set("n", "<leader>rc", connect, { desc = "Remote SSHFS connect" })
      vim.keymap.set("n", "<leader>rd", api.disconnect, { desc = "Remote SSHFS disconnect" })
      vim.keymap.set("n", "<leader>re", api.edit, { desc = "Remote SSHFS edit" })
      vim.keymap.set("n", "<leader>r?", is_connected, { desc = "Remote SSHFS check connection" })
      vim.keymap.set("n", "<leader>ff", find_file, { desc = "Find Files (root dir)" })
      vim.keymap.set("n", "<leader>fg", live_grep, { desc = "Grep (root dir)" })
    else
      wk.add({
        mode = "n",

        { "<leader>r",  group = "remote ssh" },
        { "<leader>rc", connect, desc = "Remote SSHFS connect" },
        { "<leader>rd", api.disconnect, desc = "Remote SSHFS disconnect" },
        { "<leader>re", api.edit, desc = "SSH config edit" },
        { "<leader>r?", is_connected, desc = "Remote SSHFS check connection" },

        { "<leader>ff", find_file, desc = "Find Files (root dir)" },
        { "<leader>fg", live_grep, desc = "Grep (root dir)" }
      })
    end
  end,
}
