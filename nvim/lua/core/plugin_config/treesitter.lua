require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "ruby", "python", "vim" },

  sync_install = false,
  auto_install = true,
  highligth = {
    enable = true,
  }

}
