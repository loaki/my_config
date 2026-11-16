-- Minimal Neovim config: built-in vim.pack + mini.nvim
-- Plugins live in ~/.local/share/nvim/site/pack/core/opt
-- Update: :lua vim.pack.update()   Lockfile: nvim-pack-lock.json

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- No netrw: no file explorer opens when nvim is given a directory
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Options ---------------------------------------------------------------------
local o = vim.o
o.number = true
o.relativenumber = false
o.mouse = "a"
o.clipboard = "unnamedplus"
o.ignorecase = true
o.smartcase = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.signcolumn = "yes"
o.cursorline = true
o.undofile = true
o.splitright = true
o.splitbelow = true
o.scrolloff = 8
o.updatetime = 250
o.timeoutlen = 300
o.confirm = true
o.laststatus = 3
o.winborder = "rounded"
o.list = true
o.listchars = "tab:» ,trail:·,nbsp:␣"
o.completeopt = "menuone,noselect,fuzzy"

-- Pickers (rg) show hidden files, but not .git/
vim.env.RIPGREP_CONFIG_PATH = vim.fn.stdpath("config") .. "/ripgreprc"

-- Plugins ---------------------------------------------------------------------
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      vim.schedule(function() vim.cmd("TSUpdate") end)
    end
  end,
})

vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  { src = "https://github.com/akinsho/git-conflict.nvim", version = vim.version.range("*") },
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/ibhagwan/fzf-lua",
})

-- Colorscheme
require("catppuccin").setup({ flavour = "macchiato" })
vim.cmd.colorscheme("catppuccin-macchiato")

-- mini.nvim -------------------------------------------------------------------
require("mini.icons").setup()
require("mini.notify").setup()
vim.notify = require("mini.notify").make_notify()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.bufremove").setup()
require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.move").setup() -- Alt-hjkl moves line / selection
require("mini.git").setup()

-- Surround on gs* (s is used for jumping): gsa add, gsd delete, gsr replace
require("mini.surround").setup({
  mappings = {
    add = "gsa", delete = "gsd", find = "gsf", find_left = "gsF",
    highlight = "gsh", replace = "gsr", update_n_lines = "gsn",
  },
})

-- File explorer (columns, with preview)
-- Opened only via <leader>e / <leader>E, never automatically on a directory
require("mini.files").setup({
  windows = { preview = true, width_preview = 60 },
  options = { use_as_default_explorer = false },
})

-- Fuzzy picker with live preview (uses the fzf binary)
require("fzf-lua").setup({
  winopts = { height = 0.9, width = 0.9, preview = { layout = "flex", horizontal = "right:55%" } },
  lsp = { includeDeclaration = false, ignore_current_line = true },
})
require("fzf-lua").register_ui_select()

-- 2-char label jump (like flash / helix gw)
require("mini.jump2d").setup({
  mappings = { start_jumping = "" },
  view = { n_steps_ahead = 1 },
})
-- Both label characters in the same color (second char is SpotAhead by default)
vim.api.nvim_set_hl(0, "MiniJump2dSpotAhead", { link = "MiniJump2dSpot" })

-- LSP completion: <Tab>/<S-Tab> to move, <CR> to accept
require("mini.completion").setup()

-- Key hints (which-key)
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" }, { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "g" }, { mode = "x", keys = "g" },
    { mode = "n", keys = "[" }, { mode = "n", keys = "]" },
    { mode = "n", keys = "z" }, { mode = "x", keys = "z" },
    { mode = "n", keys = "'" }, { mode = "n", keys = "`" },
    { mode = "n", keys = '"' }, { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" }, { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" },
  },
  clues = {
    { mode = "n", keys = "<Leader>b", desc = "+buffer" },
    { mode = "n", keys = "<Leader>c", desc = "+code" },
    { mode = "n", keys = "<Leader>f", desc = "+find" },
    { mode = "n", keys = "<Leader>g", desc = "+git" },
    { mode = "n", keys = "<Leader>gh", desc = "+hunks" },
    { mode = "n", keys = "<Leader>s", desc = "+search" },
    { mode = "n", keys = "<Leader>u", desc = "+toggle" },
    { mode = "n", keys = "<Leader>q", desc = "+quit" },
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = { delay = 300 },
})

-- Other plugins ---------------------------------------------------------------
require("git-conflict").setup()

-- Git hunks: signs in the gutter, ]h [h to navigate, <leader>gh* actions
require("gitsigns").setup({
  signs = {
    add = { text = "▎" }, change = { text = "▎" }, delete = { text = "" },
    topdelete = { text = "" }, changedelete = { text = "▎" }, untracked = { text = "▎" },
  },
  signs_staged = {
    add = { text = "▎" }, change = { text = "▎" }, delete = { text = "" },
    topdelete = { text = "" }, changedelete = { text = "▎" },
  },
  on_attach = function(buf)
    local gs = require("gitsigns")
    local function bmap(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buf, desc = desc }) end
    bmap("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
    bmap("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
    bmap("n", "]H", function() gs.nav_hunk("last") end, "Last hunk")
    bmap("n", "[H", function() gs.nav_hunk("first") end, "First hunk")
    bmap({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
    bmap({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
    bmap("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
    bmap("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
    bmap("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk inline")
    bmap("n", "<leader>ghP", gs.preview_hunk, "Preview hunk (popup)")
    bmap("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
    bmap("n", "<leader>ghB", gs.blame, "Blame buffer")
    bmap("n", "<leader>ghd", gs.diffthis, "Diff this")
    bmap({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<cr>", "Hunk")
  end,
})

-- Treesitter (main branch: installs parsers, highlighting is enabled below)
require("nvim-treesitter").install({
  "bash", "css", "diff", "dockerfile", "gitcommit", "html", "javascript", "json", "lua",
  "markdown", "markdown_inline", "php", "phpdoc", "python", "regex", "scss", "sql", "toml",
  "twig", "typescript", "vim", "vimdoc", "xml", "yaml",
})
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- LSP: servers are installed with :Mason, configs come from nvim-lspconfig
require("mason").setup()
vim.lsp.config("lua_ls", {
  settings = { Lua = { runtime = { version = "LuaJIT" }, workspace = { library = { vim.env.VIMRUNTIME } } } },
})
vim.lsp.enable({
  "lua_ls", "pyright", "ruff", "jsonls", "dockerls", "docker_compose_language_service", "taplo", "marksman",
  "intelephense", -- PHP
})

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { source = true },
})

-- Keymaps ---------------------------------------------------------------------
local map = vim.keymap.set

-- General
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>")
map({ "n", "i", "x" }, "<C-s>", "<cmd>write<cr><Esc>", { desc = "Save" })
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", function() MiniBufremove.delete() end, { desc = "Delete buffer" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Completion
map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
map("i", "<CR>", function()
  if vim.fn.complete_info({ "selected" }).selected ~= -1 then return "\25" end -- <C-y>
  return MiniPairs.cr()
end, { expr = true, replace_keycodes = false })

-- Jump
map({ "n", "x", "o" }, "s", function() MiniJump2d.start(MiniJump2d.builtin_opts.word_start) end, { desc = "Jump" })

-- Explorer
map("n", "<leader>e", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, { desc = "Explorer (current file)" })
map("n", "<leader>E", function() MiniFiles.open() end, { desc = "Explorer (cwd)" })

-- Find / search
map("n", "<leader><space>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>,", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Grep" })
map("n", "<leader>sw", "<cmd>FzfLua grep_cword<cr>", { desc = "Grep word" })
map("x", "<leader>sw", "<cmd>FzfLua grep_visual<cr>", { desc = "Grep selection" })
map("n", "<leader>sb", "<cmd>FzfLua blines<cr>", { desc = "Lines in buffer" })
map("n", "<leader>sh", "<cmd>FzfLua helptags<cr>", { desc = "Help" })
map("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Diagnostics (file)" })
map("n", "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Diagnostics (project)" })
map("n", "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Symbols (file)" })
map("n", "<leader>sS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "Symbols (project)" })
map("n", "<leader>sq", "<cmd>FzfLua quickfix<cr>", { desc = "Quickfix list" })
map("n", "<leader>sr", "<cmd>FzfLua resume<cr>", { desc = "Resume picker" })

-- Git
map("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Changed files" })
map("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Commits" })
map("n", "<leader>gC", "<cmd>FzfLua git_bcommits<cr>", { desc = "Commits (file)" })
map("n", "<leader>gb", "<cmd>FzfLua git_branches<cr>", { desc = "Branches" })
map({ "n", "x" }, "<leader>gl", function() MiniGit.show_at_cursor() end, { desc = "Line history" })

-- LSP (built-in: K hover, grn rename, gra action, grr refs, gri impl, gO symbols)
map("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Definition" })
map("n", "grr", "<cmd>FzfLua lsp_references<cr>", { desc = "References" })
map("n", "gri", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Implementations" })
map("n", "grt", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "Type definition" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "x" }, "<leader>cf", function() vim.lsp.buf.format() end, { desc = "Format" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Toggles
map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Diagnostics" })
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Wrap" })

-- Autocmds --------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})
