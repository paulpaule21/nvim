return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    { "hrsh7th/cmp-nvim-lsp",                lazy = false },
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },

  config = function()
    ---------------------------------------------------------------------------
    -- CAPABILITIES
    ---------------------------------------------------------------------------
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local keymap = vim.keymap

    ---------------------------------------------------------------------------
    -- DIAGNOSTICS
    ---------------------------------------------------------------------------
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN]  = " ",
          [vim.diagnostic.severity.HINT]  = "󰠠 ",
          [vim.diagnostic.severity.INFO]  = " ",
        },
      },
    })

    ---------------------------------------------------------------------------
    -- LSP ATTACH
    ---------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local opts = { buffer = bufnr, silent = true }

        -----------------------------------------------------------------------
        -- KEYMAPS
        -----------------------------------------------------------------------
        keymap.set("n", "<leader>gR", "<cmd>Telescope lsp_references<CR>",
          vim.tbl_extend("force", opts, { desc = "LSP references" }))
        keymap.set("n", "<leader>gD", vim.lsp.buf.declaration,
          vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>",
          vim.tbl_extend("force", opts, { desc = "Definitions" }))
        keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>",
          vim.tbl_extend("force", opts, { desc = "Implementations" }))
        keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>",
          vim.tbl_extend("force", opts, { desc = "Type definitions" }))
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code actions" }))
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>",
          vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))
        keymap.set("n", "<leader>d", vim.diagnostic.open_float,
          vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
        keymap.set("n", "<leader>K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
        keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))

        -----------------------------------------------------------------------
        -- FORMAT ON SAVE
        -----------------------------------------------------------------------
        if client.name == "gopls" or client:supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                timeout_ms = 1000,
              })
            end,
          })
        end
      end,
    })

    ---------------------------------------------------------------------------
    -- LSP SERVERS (EXPLICIT & STABLE)
    ---------------------------------------------------------------------------
    local lspconfig = require("lspconfig")

    lspconfig.gopls.setup({
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
        },
      },
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })
  end,
}
