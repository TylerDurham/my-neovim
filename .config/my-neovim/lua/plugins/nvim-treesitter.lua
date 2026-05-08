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
      "tst",
      "typescript",
      "vim",
      "vimdoc",
      "templ",
    },
  },
  -- custom setup
  config = function()

    -- install templ 
    require('nvim-treesitter').install({ 'templ' })

    -- register filetype
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'templ',
      callback = function()
        vim.treesitter.start()
      end,
    })
  end
}

