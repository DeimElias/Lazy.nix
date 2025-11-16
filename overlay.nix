final: prev:
let
  pluginsDir = final.vimUtils.packDir final.custom-neovim.passthru.packpathDirs;
in
{
  custom-neovim = final.wrapNeovimUnstable final.neovim-unwrapped {
    vimAlias = true;
    viAlias = true;
    plugins = (import ./edits/plugins.nix { inherit final; });
    luaRcContent = final.lib.concatLines [
      (builtins.readFile ./edits/settings.lua)
      (import ./lua.nix {
        luaDir = "${final.luaFiles}";
        plugins = "${pluginsDir}/pack/myNeovimPackages/start";
      })
    ];
  };
  luaFiles = final.stdenv.mkDerivation {
    pname = "neovim-conf";
    version = "1.0";
    src = ./edits/lua;
    installPhase = ''
      	mkdir -p $out/lua
              cp -r ./* $out/lua
      	'';
    # Add completion for plugins and VIMRUNTIME
    fixupPhase = ''
      	  substituteInPlace $out/lua/plugins/lspconfig.lua --replace FIXME ${pluginsDir}
    '';
  };
  vimPugins = prev.vimPugins // {
    nvim-lspconfig = prev.vimPlugins.nvim-lspconfig.overrideAttrs (
      original:
      original
      // {
        passthru.runtimeDeps =
          (import ./edits/dependencies.nix { inherit final; })
          ++ final.lib.optionals (original.passthru ? runtimeDeps) original.passthru.runtimeDeps;
      }
    );

  };
}
