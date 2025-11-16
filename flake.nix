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
        {
          neovim = pkgs.custom-neovim;
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
