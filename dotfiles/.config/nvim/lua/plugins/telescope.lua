return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>" },
  },
  opts = {
    defaults = {
      file_ignore_patterns = { "^%.git/" },
      vimgrep_arguments = {
        "rg", "--color=never", "--no-heading", "--with-filename",
        "--line-number", "--column", "--smart-case", "--hidden",
      },
    },
    pickers = {
      find_files = { hidden = true },
    },
  },
}
