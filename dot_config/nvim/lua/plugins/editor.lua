return {
  -- Telescope: ファジーファインダー
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",    desc = "Recent Files" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Help Tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/", "vendor/" },
          preview = {
            -- nvim-treesitter.parsers が新バージョンで削除されたため無効化
            -- regex ハイライトにフォールバック
            treesitter = false,
          },
        },
        extensions = { fzf = {} },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- chezmoi: source state/template のシンタックスハイライト
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },

  -- Treesitter: シンタックスハイライト
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      ensure_installed = {
        "go", "gomod", "gosum", "gowork",
        "lua", "vim", "vimdoc",
        "python", "bash", "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "java",  -- Keycloak extension 用
      },
      highlight    = {
        enable = true,
        disable = function(_, bufnr)
          return vim.bo[bufnr].filetype:find("chezmoitmpl", 1, true) ~= nil
        end,
      },
      indent       = { enable = true },
      auto_install = true,
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },

  -- Git signs: 差分をガターに表示
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk,         "Next Hunk")
        map("n", "[h", gs.prev_hunk,         "Prev Hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>hs", gs.stage_hunk,   "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk,   "Reset Hunk")
        map("n", "<leader>gb", gs.blame_line,   "Blame Line")
      end,
    },
  },

  -- 自動ペア補完
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- コメントトグル
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n" },
      { "gc",  mode = "v" },
    },
    opts = {},
  },

  -- 囲み文字の操作 (ys, cs, ds)
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- スムーズスクロール
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- ジャンプ強化 (s + 2文字でジャンプ)
  {
    "leap.nvim",
    url = "https://codeberg.org/andyg/leap.nvim",
    event = "VeryLazy",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- TODO コメントのハイライト
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {},
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs" },
    },
  },

  -- 現在の関数・クラスのスコープを画面上部に固定表示
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    opts = { max_lines = 3 },
  },

  -- Ctrl+a/x を日付・bool・hex など多様な値に対応
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>",  "<Plug>(dial-increment)",  mode = { "n", "v" } },
      { "<C-x>",  "<Plug>(dial-decrement)",  mode = { "n", "v" } },
    },
  },

  -- プロジェクト横断の検索・置換
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>sr", "<cmd>GrugFar<CR>", desc = "Search & Replace" },
    },
    opts = {},
  },

  -- VSCode 風コード折りたたみ
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel  = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup({
        provider_selector = function() return { "treesitter", "indent" } end,
      })
      vim.keymap.set("n", "zR", require("ufo").openAllFolds,  { desc = "Open All Folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close All Folds" })
    end,
  },

  -- Normal モードで Markdown をリアルタイムプレビュー
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },

  -- j/k 長押しで加速
  {
    "rainbowhxch/accelerated-jk.nvim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)")
      vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)")
    end,
  },
}
