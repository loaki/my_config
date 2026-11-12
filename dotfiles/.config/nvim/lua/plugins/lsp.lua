return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = { ensure_installed = { "lua_ls", "pyright", "bashls", "dockerls", "yamlls", "jsonls" } },
      },
    },
    config = function()
      vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(k, f) vim.keymap.set("n", k, f, { buffer = ev.buf }) end
          map("gd", vim.lsp.buf.definition)
          map("gr", vim.lsp.buf.references)
          map("K", vim.lsp.buf.hover)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
          map("<leader>f", function() vim.lsp.buf.format({ async = true }) end)
        end,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "enter" },
      completion = { documentation = { auto_show = true } },
    },
  },
}
