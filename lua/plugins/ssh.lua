return {
  "nosduco/remote-sshfs.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-telescope/telescope.nvim" }, -- optional if you declare plugin somewhere else
  config = function()
    require("remote-sshfs").setup({})

    require("telescope").load_extension("remote-sshfs")

    -- local Util = require("lazyvim.util")
    -- local telescope_find_files = Util.pick("files", {})
    -- local telescope_live_grep = Util.pick("live_grep", {})
    local util_telescope = require("lazyvim.util.telescope")
    local telescope_find_files = util_telescope("files", {})
    local telescope_live_grep = util_telescope("live_grep", {})
    local connections = require("remote-sshfs.connections")

    local api = require("remote-sshfs.api")
    vim.keymap.set("n", "<leader>rc", api.connect, { desc = "Remote SSHFS connect" })
    vim.keymap.set("n", "<leader>rd", api.disconnect, { desc = "Remote SSHFS disconnect" })
    vim.keymap.set("n", "<leader>re", api.edit, { desc = "Remote SSHFS edit" })
    vim.keymap.set("n", "<leader>r?", function()
      print(connections.is_connected())
    end, { desc = "Remote SSHFS check connection" })

    -- (optional) Override telescope find_files and live_grep to make dynamic based on if connected to host
    vim.keymap.set("n", "<leader>ff", function()
      if connections.is_connected() then
        api.find_files({})
      else
        telescope_find_files()
        --builtin.find_files()
      end
    end, { desc = "Find Files (root dir)" })
    vim.keymap.set("n", "<leader>fg", function()
      if connections.is_connected() then
        api.live_grep({})
      else
        telescope_live_grep()
        --builtin.live_grep()
      end
    end, { desc = "Grep (root dir)" })
  end,
}
