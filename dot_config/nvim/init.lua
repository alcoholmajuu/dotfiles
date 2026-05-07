-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key (スペースキー)
vim.g.mapleader = " "
vim.g.maplocalleader = "," -- Octo.nvim など localleader を使うプラグインと分離

-- ===== 基本設定 =====
local opt = vim.opt

opt.number         = true          -- 行番号表示
opt.relativenumber = true          -- 相対行番号
opt.cursorline     = true          -- カーソル行をハイライト
opt.signcolumn     = "yes"         -- サインカラム常時表示（ガタつき防止）
opt.wrap           = false         -- 行折り返し無効
opt.scrolloff      = 8             -- スクロール時の余白行数
opt.sidescrolloff  = 8

-- タブ・インデント
opt.expandtab      = true          -- タブをスペースに展開
opt.shiftwidth     = 2
opt.tabstop        = 2
opt.smartindent    = true

-- 検索
opt.ignorecase     = true
opt.smartcase      = true          -- 大文字を含む場合は大文字小文字区別
opt.hlsearch       = true
opt.incsearch      = true

-- ファイル
opt.encoding       = "utf-8"
opt.fileencoding   = "utf-8"
opt.swapfile       = false
opt.backup         = false
opt.undofile       = true          -- 永続的 undo 履歴

-- UI
opt.termguicolors  = true          -- 24bit カラー有効
opt.autoread       = true          -- フォーカス復帰時にファイル変更を自動読み込み
opt.splitright     = true          -- 縦分割は右に開く
opt.splitbelow     = true          -- 横分割は下に開く
opt.showmode       = false         -- モード表示は lualine に任せる
opt.clipboard      = "unnamedplus" -- システムクリップボードと共有

-- ===== キーマップ =====
local map = vim.keymap.set

-- ESC でハイライト消去
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ---- ウィンドウ移動 ----
-- Normal モード
map("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window Right" })

-- ターミナルモード（Claude Code 起動中からも移動できる）
map("t", "<C-h>", "<C-\\><C-n><C-w>h")
map("t", "<C-j>", "<C-\\><C-n><C-w>j")
map("t", "<C-k>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal Normal Mode" })

-- ---- ウィンドウ分割 ----
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split Vertical" })
map("n", "<leader>sh", "<cmd>split<CR>",  { desc = "Split Horizontal" })
map("n", "<leader>sc", "<cmd>close<CR>",  { desc = "Close Window" })
map("n", "<leader>so", "<cmd>only<CR>",   { desc = "Close Other Windows" })
map("n", "<leader>se", "<C-w>=",          { desc = "Equalize Windows" })

-- ---- ウィンドウリサイズ ----
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Resize Up" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Resize Down" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Resize Left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize Right" })

-- ---- バッファ操作 ----
map("n", "<Tab>",      "<cmd>bnext<CR>",    { desc = "Next Buffer" })
map("n", "<S-Tab>",    "<cmd>bprevious<CR>", { desc = "Prev Buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>",  { desc = "Buffer Delete" })
map("n", "<leader>bo", "<cmd>%bdelete|edit#|bdelete#<CR>", { desc = "Close Other Buffers" })

-- ---- ファイル保存・終了 ----
map("n", "<leader>w",  "<cmd>write<CR>",   { desc = "Save" })
map("n", "<leader>wa", "<cmd>wall<CR>",    { desc = "Save All" })
map("n", "<leader>q",  "<cmd>quit<CR>",    { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qall!<CR>",   { desc = "Quit All (force)" })
map("i", "<C-s>",      "<Esc><cmd>write<CR>", { desc = "Save (insert)" })

-- ---- タブ操作 ----
map("n", "<leader>tn", "<cmd>tabnew<CR>",      { desc = "New Tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>",    { desc = "Close Tab" })
map("n", "gt",         "<cmd>tabnext<CR>",     { desc = "Next Tab" })
map("n", "gT",         "<cmd>tabprevious<CR>", { desc = "Prev Tab" })

-- ---- 行操作 ----
-- 行を上下に移動（Alt+j/k）
map("n", "<A-j>", "<cmd>move .+1<CR>==",        { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>move .-2<CR>==",        { desc = "Move Line Up" })
map("v", "<A-j>", ":move '>+1<CR>gv=gv",        { desc = "Move Selection Down" })
map("v", "<A-k>", ":move '<-2<CR>gv=gv",        { desc = "Move Selection Up" })

-- ビジュアルモードでインデント後も選択を維持
map("v", "<", "<gv", { desc = "Dedent" })
map("v", ">", ">gv", { desc = "Indent" })

-- ---- 検索 ----
-- 検索結果を常に画面中央に表示
map("n", "n", "nzzzv", { desc = "Next Search (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev Search (centered)" })

-- ---- その他 ----
-- ビジュアル選択中のペーストでレジスタを上書きしない
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- ===== Claude Code =====
-- :ClaudeStart [split|vsplit|tabnew] でターミナルを開いて即起動
-- 終了後は自動でバッファを閉じる
vim.api.nvim_create_user_command("ClaudeStart", function(opts)
  local mode = (opts.args ~= "") and opts.args or "vsplit"
  vim.cmd(mode)
  vim.cmd("terminal claude")
  vim.cmd("startinsert")
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = vim.api.nvim_get_current_buf(),
    once = true,
    callback = function() vim.cmd("bdelete!") end,
  })
end, {
  nargs = "?",
  complete = function() return { "split", "vsplit", "tabnew" } end,
  desc = "Start Claude Code in a terminal split",
})

map("n", "<leader>cc", "<cmd>ClaudeStart vsplit<CR>", { desc = "Claude Code (vsplit)" })

-- ===== プラグイン =====
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})
