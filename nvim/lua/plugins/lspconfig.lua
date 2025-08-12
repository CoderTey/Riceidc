return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Clangd setup
      lspconfig.clangd.setup{
        capabilities = capabilities,
      }

      -- Lua LS setup
      lspconfig.lua_ls.setup{
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      }

      -- Assembly LSP setup (if available)
      lspconfig.asm_lsp.setup{
        capabilities = capabilities,
      }
    end,
  },
}

