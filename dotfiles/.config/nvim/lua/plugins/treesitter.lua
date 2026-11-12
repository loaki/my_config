return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "bash", "c", "css", "dockerfile", "go", "html", "javascript", "json",
      "lua", "markdown", "markdown_inline", "python", "toml", "typescript", "vim", "vimdoc", "yaml",
    })
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
