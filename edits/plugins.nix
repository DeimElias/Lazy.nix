{ pkgs }:
with pkgs.vimPlugins;
[
  lazy-nvim
  plenary-nvim
  flash-nvim
  r-nvim
  which-key-nvim
  blink-cmp
  blink-compat
  cmp-r
  otter-nvim
  telescope-nvim
  undotree
  vim-dadbod
  vim-dadbod-ui
  vim-dadbod-completion
  neogit
  gitsigns-nvim
  lualine-nvim
  nvim-web-devicons
  noice-nvim
  nui-nvim
  nvim-notify
  diffview-nvim
  (tokyonight-nvim.overrideAttrs (original: {
    doCheck = false;
  }))
  nvim-lspconfig
  nvim-treesitter.withAllGrammars
  nvim-dap
  nvim-dap-ui
]
