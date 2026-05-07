return {
  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "catppuccin-nvim",
        globalstatus         = true,
        section_separators   = { left = "\xee\x82\xb0", right = "\xee\x82\xb2" },
        component_separators = { left = "\xee\x82\xb1", right = "\xee\x82\xb3" },
      },
      sections = {
        lualine_a = {
          { "mode", icon = "" },
        },
        lualine_b = {
          { "branch", icon = "" },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        lualine_c = {
          {
            "filename",
            path = 1, -- 相対パスで表示
            symbols = { modified = "●", readonly = "", unnamed = "[No Name]" },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources  = { "nvim_lsp" },
            symbols  = { error = " ", warn = " ", info = " ", hint = "󰠠 " },
          },
          { "filetype", icon_only = false },
        },
        lualine_y = {
          { "encoding" },
          { "fileformat", icons_enabled = true },
        },
        lualine_z = {
          { "location" },
          { "progress", padding = { left = 1, right = 2 } },
        },
      },
    },
  },

  -- バッファタブライン
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", padding = 1 },
        },
      },
    },
  },

  -- ファイルエクスプローラー
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer Toggle" },
    },
    opts = {
      view = { width = 35, side = "left" },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
    },
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- which-key: キーバインドのヘルプ表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- 通知をおしゃれに
  {
    "rcarriga/nvim-notify",
    opts = { timeout = 2000, render = "compact" },
    init = function()
      vim.notify = require("notify")
    end,
  },

  -- スタートスクリーン
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "doom",
      config = {
        header = {
          "",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
          "",
        },
        center = {
          {
            icon = "  ",
            desc = "Find File          ",
            key  = "f",
            action = function() require("telescope.builtin").find_files() end,
          },
          {
            icon = "  ",
            desc = "Recent Files       ",
            key  = "r",
            action = function() require("telescope.builtin").oldfiles() end,
          },
          {
            icon = "  ",
            desc = "Live Grep          ",
            key  = "g",
            action = function() require("telescope.builtin").live_grep() end,
          },
          {
            icon = "  ",
            desc = "New File           ",
            key  = "n",
            action = "enew",
          },
          {
            icon = "  ",
            desc = "Config             ",
            key  = "c",
            action = "edit ~/.config/nvim/init.lua",
          },
          {
            icon = "󰒲  ",
            desc = "Lazy               ",
            key  = "l",
            action = "Lazy",
          },
          {
            icon = "  ",
            desc = "Quit               ",
            key  = "q",
            action = "quit",
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          return { "⚡ " .. stats.count .. " plugins loaded" }
        end,
      },
    },
  },

  -- ブロックの開始・終了をハイライト
  {
    "shellRaining/hlchunk.nvim",
    event = "BufReadPost",
    opts = {
      chunk    = { enable = true },
      indent   = { enable = false }, -- indent-blankline と競合するため無効
      line_num = { enable = true },
    },
  },

  -- パンくずリスト
  {
    "Bekaboo/dropbar.nvim",
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
    event = "BufReadPost",
    opts = {},
  },

  -- スクロールバー（LSP エラー・Git 差分も表示）
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    dependencies = { "lewis6991/gitsigns.nvim" },
    config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
}
