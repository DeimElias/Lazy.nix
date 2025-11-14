{ pkgs }:
with pkgs.vimPlugins;
[
  lazy-nvim
  blink-cmp
  nvim-lspconfig
  nvim-treesitter.withAllGrammars
  # Some plugins will requiere other plugins to be installed to pass some test,
  # if you dont want to install or use them, you can override doCheck attribute
  # to disable those checks
  (tokyonight-nvim.overrideAttrs (original: {
    doCheck = false;
  }))
]
