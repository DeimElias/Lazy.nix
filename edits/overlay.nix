final: prev: {
  rPackages = prev.rPackages // {
    nvimcom = final.rPackages.buildRPackage {
      name = "nvimcom";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "main";
        sha256 = "sha256-mb8HCaMasPUP9JZUkH1sPrtdbhM2HMUkJEKDsRt6wTs=";
      };
      sourceRoot = "source/nvimcom";
    };
  };
  rEnv = prev.radianWrapper.override {
    wrapR = true;
    recommendedPackages =
      prev.radianWrapper.recommendedPackages
      ++ (with final.rPackages; [
        nvimcom
        quarto
      ]);
  };
  vimPlugins = prev.vimPlugins // {
    r-nvim = final.vimUtils.buildVimPlugin {
      pname = "R.nvim";
      version = "2025-08-20";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "R.nvim";
        rev = "main";
        sha256 = "sha256-mb8HCaMasPUP9JZUkH1sPrtdbhM2HMUkJEKDsRt6wTs=";
      };
      runtimeDeps = [
        final.rEnv
      ];
    };
    # Added cmp-r to complete functionality for R-nvim
    cmp-r = final.vimUtils.buildVimPlugin {
      pname = "cmp-r";
      version = "2025-08-05";
      src = final.fetchFromGitHub {
        owner = "R-nvim";
        repo = "cmp-r";
        rev = "main";
        sha256 = "sha256-TwmLSILu1H3RyRivCQlbsgUN4dsEqO1E8Hx71N/lFws=";
      };
      doCheck = false;
      passthru.runtimeDeps = [ final.quarto ];
      buildInputs = with final; [
        R
        quarto
      ];
    };
  };
}
