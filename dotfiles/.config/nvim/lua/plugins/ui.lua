return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "catppuccin-macchiato", section_separators = "", component_separators = "" } },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(k, f) vim.keymap.set("n", k, f, { buffer = buf }) end
        map("]h", function() gs.nav_hunk("next") end)
        map("[h", function() gs.nav_hunk("prev") end)
        map("<leader>hp", gs.preview_hunk)
        map("<leader>hr", gs.reset_hunk)
        map("<leader>hs", gs.stage_hunk)
        map("<leader>hb", gs.blame_line)
      end,
    },
  },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  { "stevearc/oil.nvim", opts = { view_options = { show_hidden = true } } },
}
