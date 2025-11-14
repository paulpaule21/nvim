return {
  "neovim/nvim-lspconfig",
  version = false, -- use HEAD
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
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local keymap = vim.keymap

    ---------------------------------------------------------------------------
    -- MODERN DIAGNOSTIC SIGNS (Neovim 0.11+ API)
    ---------------------------------------------------------------------------
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    ---------------------------------------------------------------------------
    -- ON_ATTACH VIA LspAttach
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
        opts.desc = "LSP references"
        keymap.set("n", "<leader>gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show definitions"
        keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show implementations"
        keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show type definitions"
        keymap.set("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "Code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Rename symbol"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Hover"
        keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

        -----------------------------------------------------------------------
        -- AUTOFORMAT
        -----------------------------------------------------------------------
        if client.name == "gopls" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              -- organize imports
              local params = {
                context = { only = { "source.organizeImports" } },
                textDocument = vim.lsp.util.make_text_document_params(),
              }

              local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)

              for _, res in pairs(result or {}) do
                for _, action in pairs(res.result or {}) do
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                  elseif action.command then
                    vim.lsp.buf.execute_command(action.command)
                  end
                end
              end

              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        elseif client:supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    ---------------------------------------------------------------------------
    -- MASON-LSPCONFIG
    ---------------------------------------------------------------------------
    mason_lspconfig.setup()

    ---------------------------------------------------------------------------
    -- AUTO-SETUP INSTALLED SERVERS (Neovim 0.11+ API)
    ---------------------------------------------------------------------------

    local lspconfig = require("lspconfig")

    for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
      local opts = {
        capabilities = capabilities,
      }

      if server == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        }
      elseif server == "gopls" then
        opts.settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
          },
        }
        opts.root_dir = vim.fs.dirname(vim.fs.find({ "go.mod", ".git" }, { upward = true })[1])
      end

      -- ✔ Correct API
      lspconfig[server].setup(opts)
    end
  end,
}
