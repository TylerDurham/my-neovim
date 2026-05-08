
return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "neovim/nvim-lspconfig"
    },
    config = function()
      require("mason").setup({})

      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "lua_ls",
        }
      })

      local lsp_config = require("lspconfig")

      local mason_tools = require('mason-tool-installer')
      mason_tools.setup({
        ensure_installed = {
          "gofumpt",
          "goimports",
          "shfmt",
          "stylua",
        }
      })
    end
  },
}
