require'nvim-treesitter.configs'.setup {
  ensure_installed = { 
      "vimdoc", 
      "python", 
      "kotlin", 
      "c", 
      "lua", 
      "markdown", 
      "cpp",
      "csv",
      "cuda",
      "dockerfile",

  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
