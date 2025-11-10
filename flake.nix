{
  description = "Easy Neovim for lazy.nvim users";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                self.overlays.default
                self.overlays.custom
              ];
            };
          }
        );
    in
    {
      packages = forEachSupportedSystem (
        { pkgs }:
        let
          pluginsDir = pkgs.vimUtils.packDir self.packages.${pkgs.system}.neovim.passthru.packpathDirs;
        in
        {
          neovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
            vimAlias = true;
            viAlias = true;
            plugins = (import ./edits/plugins.nix { inherit pkgs; });
            luaRcContent = pkgs.lib.concatLines [
              (builtins.readFile ./edits/settings.lua)
              (import ./lua.nix {
                luaDir = "${self.packages.${pkgs.system}.luaFiles}";
                plugins = "${pluginsDir}/pack/myNeovimPackages/start";
              })
            ];
          };

          luaFiles = pkgs.stdenv.mkDerivation {
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

        }
      );
      apps = nixpkgs.lib.genAttrs supportedSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.neovim}/bin/nvim";
        };
      });
      overlays = {
        default = (import ./overlay.nix);
        custom = (import ./edits/overlay.nix);
      };
    };
}
