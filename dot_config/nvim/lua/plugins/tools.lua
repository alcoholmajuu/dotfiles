return {
  -- ===== PR レビュー =====

  -- Markdown レンダリング（Octo.nvim の PR 詳細表示を改善）
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "octo" },
    opts = {},
  },

  -- GitHub PR・Issue をNeovim 内で操作
  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    config = function()
      require("octo").setup({
        enable_builtin = true,
        mappings_disable_default = false,
      })
    end,
  },

  -- 差分ビューア
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>dv", "<cmd>DiffviewOpen<CR>",        desc = "Diffview Open" },
      { "<leader>dh", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview File History" },
      { "<leader>dc", "<cmd>DiffviewClose<CR>",       desc = "Diffview Close" },
    },
    opts = {},
  },

  -- ===== IME 自動切り替え
  {
    "keaising/im-select.nvim",
    lazy = false, -- FocusGained を確実に拾うため起動時からロード
    config = function()
      local opts = {
        -- Neovim にフォーカスが戻った時・Insert を抜けた時に英語へ
        set_default_events  = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
        -- Insert に入った時だけ前の IME を復元
        set_previous_events = { "InsertEnter" },
      }

      if vim.fn.has("macunix") == 1 then
        opts.default_im_select = "com.apple.keylayout.ABC"
        opts.default_command = "macism"
      end

      require("im_select").setup(opts)
    end,
  },

  -- lazygit を Neovim 内で起動
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },

  -- ターミナル
  {
    "akinsho/toggleterm.nvim",
    keys = { { "<C-\\>", desc = "Toggle Terminal" } },
    opts = {
      open_mapping = [[<C-\>]],
      direction    = "float",
      float_opts   = { border = "curved" },
    },
  },

  -- trouble.nvim: 診断・参照を一覧表示
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<CR>",                       desc = "Trouble Toggle" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace Diagnostics" },
    },
    opts = {},
  },

  -- LSP 定義元・参照元をポップアップでプレビュー
  {
    "dnlhc/glance.nvim",
    keys = {
      { "gD", "<cmd>Glance definitions<CR>",      desc = "Glance Definitions" },
      { "gR", "<cmd>Glance references<CR>",       desc = "Glance References" },
      { "gI", "<cmd>Glance implementations<CR>",  desc = "Glance Implementations" },
    },
    opts = {},
  },

  -- LSP 診断をインラインでスタイリッシュに表示
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    config = function()
      vim.diagnostic.config({ virtual_text = false }) -- デフォルトの virtual_text を無効化
      require("tiny-inline-diagnostic").setup()
    end,
  },

  -- コードシンボル検索・ジャンプ
  {
    "bassamsdata/namu.nvim",
    keys = {
      { "<leader>fs", "<cmd>Namu symbols<CR>", desc = "Symbol Search" },
    },
    opts = {},
  },

  -- 集中モード（他要素を非表示）
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
    },
    opts = {},
  },

  -- 関数・クラスのドキュメントコメントを自動生成
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    keys = {
      { "<leader>dg", "<cmd>DogeGenerate<CR>", desc = "Generate Docs" },
    },
  },

  -- Go 専用拡張 
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPre *.go",
    ft    = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    opts  = {
      lsp_cfg      = false, -- nvim-lspconfig 側で管理
      lsp_gofumpt  = true,
      lsp_on_attach = false,
    },
    keys = {
      { "<leader>gt", "<cmd>GoTest<CR>",       desc = "Go Test" },
      { "<leader>gr", "<cmd>GoRun<CR>",        desc = "Go Run" },
      { "<leader>gi", "<cmd>GoImports<CR>",    desc = "Go Imports" },
    },
  },
}
