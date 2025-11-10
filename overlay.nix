final: prev: {
  vimPugins = prev.vimPugins // {
    nvim-lspconfig = prev.vimPlugins.nvim-lspconfig.overrideAttrs (
      original:
      original
      // {
        passthru.runtimeDeps = (import ./edits/dependencies.nix {inherit final;})
          ++ final.lib.optionals (original.passthru ? runtimeDeps) original.passthru.runtimeDeps;
      }
    );

  };
}
