
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

      local lsp_dir = vim.fn.stdpath("config") .. "/lua/plugins/lsp"
      local files = vim.fn.glob(lsp_dir .. "/*.lua", false, true)

      local servers = {}
      for _, file in ipairs(files) do
        local mod = "plugins.lsp." .. vim.fn.fnamemodify(file, ":t:r")
        local ok, spec = pcall(require, mod)
        if ok and spec.name then
          table.insert(servers, spec)
        end
      end

      local ensure_installed = {}
      for _, spec in ipairs(servers) do
        if spec.ensure_installed then
          table.insert(ensure_installed, spec.name)
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

      for _, spec in ipairs(servers) do
        if spec.config then
          vim.lsp.config(spec.name, spec.config)
        end
        vim.lsp.enable(spec.name)
      end

      require('mason-tool-installer').setup({
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
