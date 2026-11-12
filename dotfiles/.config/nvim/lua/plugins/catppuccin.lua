return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "macchiato",
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      mason = true,
      telescope = true,
      treesitter = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
