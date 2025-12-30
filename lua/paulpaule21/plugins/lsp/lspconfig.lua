return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    { "hrsh7th/cmp-nvim-lsp",                lazy = false },
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim",                  ft = "lua" },
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
        local keymap_opts = { buffer = bufnr, silent = true }

        -----------------------------------------------------------------------
        -- KEYMAPS
        -----------------------------------------------------------------------

        keymap.set("n", "<leader>gR", function()
          vim.lsp.buf.references(nil, {
            on_list = function(opts)
              vim.fn.setqflist({}, "r", opts)
              vim.cmd("copen")
            end,
          })
        end, { desc = "LSP references (quickfix)" })

        keymap.set("n", "<leader>gD", vim.lsp.buf.declaration,
          vim.tbl_extend("force", keymap_opts, { desc = "Go to declaration" }))

        keymap.set("n", "<leader>gd", function()
          vim.lsp.buf.definition({
            on_list = function(opts)
              if #opts.items == 1 then
                vim.cmd("edit " .. opts.items[1].filename)
                vim.api.nvim_win_set_cursor(0, { opts.items[1].lnum, opts.items[1].col - 1 })
              else
                vim.fn.setqflist({}, "r", opts)
                vim.cmd("copen")
              end
            end,
          })
        end, { desc = "LSP definitions" })

        keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>",
          vim.tbl_extend("force", keymap_opts, { desc = "Implementations" }))
        keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>",
          vim.tbl_extend("force", keymap_opts, { desc = "Type definitions" }))
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
          vim.tbl_extend("force", keymap_opts, { desc = "Code actions" }))
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
          vim.tbl_extend("force", keymap_opts, { desc = "Rename symbol" }))

        keymap.set("n", "<leader>D", function()
          vim.diagnostic.setqflist({ open = true })
        end, { desc = "Workspace diagnostics" })

        keymap.set("n", "<leader>d", vim.diagnostic.open_float,
          { desc = "Line diagnostics" })

        keymap.set("n", "<leader>K", vim.lsp.buf.hover, vim.tbl_extend("force", keymap_opts, { desc = "Hover" }))
        keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>",
          vim.tbl_extend("force", keymap_opts, { desc = "Restart LSP" }))

        -----------------------------------------------------------------------
        -- FORMAT ON SAVE
        -----------------------------------------------------------------------
        local group = vim.api.nvim_create_augroup("LspFormat", { clear = false })

        if client
            and (
              client.name == "gopls"
              or client.supports_method
              and client:supports_method("textDocument/formatting")
            )
        then
          vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

          vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
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
    vim.lsp.config("gopls", {
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

    vim.lsp.config("lua_ls", {
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

    -- Enable servers
    vim.lsp.enable({ "gopls", "lua_ls" })
  end,
}
