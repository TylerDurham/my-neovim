-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      "bash",
      "css",
      "go",
      "html",
      "javascript",
      "lua",
      "python",
      "templ",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end
}

