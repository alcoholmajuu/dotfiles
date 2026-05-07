return {
  -- Mason: LSP サーバーのインストール管理
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- gopls はシステム側 (~/go/bin/gopls) を使用するため除外
        "lua_ls",    -- Lua
        "pyright",   -- Python
        "yamlls",    -- YAML
        "jsonls",    -- JSON
      },
      -- handlers を空にして lspconfig の自動セットアップを抑制
      -- vim.lsp.enable() で明示的に有効化する
      handlers = {},
    },
  },

  -- LSP 設定本体 (Neovim 0.11+ の vim.lsp.config API を使用)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = "BufReadPre",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- octo:// など file:// 以外のバッファには LSP をアタッチしない
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local uri = vim.uri_from_bufnr(args.buf)
          if not vim.startswith(uri, "file://") then
            vim.lsp.buf_detach_client(args.buf, args.data.client_id)
          end
        end,
      })

      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd",         vim.lsp.buf.definition,      "Go to Definition")
        map("gD",         vim.lsp.buf.declaration,     "Go to Declaration")
        map("gr",         vim.lsp.buf.references,      "References")
        map("gi",         vim.lsp.buf.implementation,  "Implementation")
        map("K",          vim.lsp.buf.hover,           "Hover Docs")
        map("<leader>rn", vim.lsp.buf.rename,          "Rename")
        map("<leader>ca", vim.lsp.buf.code_action,     "Code Action")
        map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        map("[d",         vim.diagnostic.goto_prev,    "Prev Diagnostic")
        map("]d",         vim.diagnostic.goto_next,    "Next Diagnostic")
      end

      -- 全サーバー共通設定
      vim.lsp.config("*", {
        on_attach    = on_attach,
        capabilities = capabilities,
      })

      -- サーバー固有設定
      vim.lsp.config("gopls", {
        settings = { gopls = { gofumpt = true } },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
          },
        },
      })

      -- サーバーを有効化
      vim.lsp.enable({ "gopls", "lua_ls", "pyright", "yamlls", "jsonls" })

      vim.diagnostic.config({
        virtual_text  = true,
        signs         = true,
        underline     = true,
        severity_sort = true,
      })
    end,
  },

  -- 自動補完
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets", -- 豊富なスニペット集
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]   = cmp.mapping.select_next_item(),
          ["<C-p>"]   = cmp.mapping.select_prev_item(),
          ["<C-d>"]   = cmp.mapping.scroll_docs(4),
          ["<C-u>"]   = cmp.mapping.scroll_docs(-4),
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- フォーマッター (LSP formatter の補完)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        go     = { "gofumpt", "goimports" },
        lua    = { "stylua" },
        python = { "black" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },
}
