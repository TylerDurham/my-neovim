
return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "neovim/nvim-lspconfig"
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = vim.keymap.set
          local buf = { buffer = event.buf }
          map("n", "K",           vim.lsp.buf.hover,            vim.tbl_extend("force", buf, { desc = "LSP: hover documentation" }))
          map("n", "<C-k>",       vim.lsp.buf.signature_help,   vim.tbl_extend("force", buf, { desc = "LSP: signature help" }))
          map("n", "<leader>rn",  vim.lsp.buf.rename,           vim.tbl_extend("force", buf, { desc = "LSP: rename symbol" }))
          map("n", "gd",          vim.lsp.buf.definition,       vim.tbl_extend("force", buf, { desc = "LSP: go to definition" }))
        end,
      })

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
          "prettier",
          "shfmt",
        }
      })
    end
  },
}
