## Custom plugins

### Brief introduction

We use overlays to add plugins that are not already available in the Nix store.
It makes it easier to follow the tutorial if you know how overlays work, so
here is a small introduction:

Overlays are a way to expand nix-store (or any store) with new packages or
different configurations of packages. An overlay is just a function with 2
arguments, commonly named *final* and *prev*, both of which represent a state
of the nix store. When you load a store of packages, you can modify its content
with a "chain" of overlays (a list of overlays). 


When the first overlay of the chain is being applied, *prev* represents the
state of the store without any overlay applied. After that, *prev* represents
the state of the store after the last overlay has been applied (as you can see,
order does matter).


*final* represents the state of the store at the end of the entire chain of
overlays.


### Adding a plugin Use the ./edits/overlay.nix file to add your custom plugin.
As an example, we will add R-nvim. First, find the source of your plugin; it
may be a GitHub repository or a local directory. If it is a GitHub repository,
you also have to look for an identifier of the current (or past) state of the
repository, which might be a tag, commit hash, or a branch. (recommended a tag
or commit-hash, since a branch may change its hash with a new commit) (but if
you want your config to yell at you that your custom plugin has been updated,
consider using a branch).


R-nvim is an excellent example of a complex plugin, since it has custom
dependencies that also aren't in the Nix store, let's start.


Once we have an identifier, our code should look like this.

```nix
final: prev: {
    # We use prev here, because we want to MODIFY a property
    vimPlugins = prev.vimPlugins // {

        # We use final to account for possible changes to vimUtils.buildVimPlugin,
        # ensuring we use the final version of the package to build our plugin
        r-nvim = final.vimUtils.buildVimPlugin {
            pname = "R.nvim";
            version = "2025-08-20";

            # Same reasoning here
            # If your plugin is in a local directory, you could point to it with a path variable
            # src = ./{your-local-plugin}
            src = final.fetchFromGitHub {
                owner = "R-nvim";
                repo = "R.nvim";
                rev = "main"; 
                #rev = "fef990378e4b5157f23314dca4136bc0079cc2c4"; #commit-hash
                #rev = "v0.99.0"; #tag
                
                # No hash for the moment
                sha256 = "";
            };
        };
    };
}
```
It's important to add your new plugin as an extension of the original attribute
set vimPlugins available in nix, by doing this way we ensure compatibility with
our template. 


To obtain the correct hash, simply build your package (nix build) and it will
fail, giving you the correct hash.

```nix
final: prev: {
    vimPlugins = prev.vimPlugins // {
        r-nvim = final.vimUtils.buildVimPlugin {
            pname = "R.nvim";
            version = "2025-08-20";
            src = final.fetchFromGitHub {
                owner = "R-nvim";
                repo = "R.nvim";
                rev = "main"; 
                #rev = "fef990378e4b5157f23314dca4136bc0079cc2c4"; #commit-hash
                #rev = "v0.99.0"; #tag
                sha256 = "sha256-mb8HCaMasPUP9JZUkH1sPrtdbhM2HMUkJEKDsRt6wTs=";
            };
        };
    };
}
```

Almost any package should be done by this point. You should add your new plugin
to ./edits/plugins.nix list, and some configuration in
./edits/lua/plugins/{your-plugin-name}.lua, an test it's functionality. Some
packages requires some additional configurations, like some dependencies to
work, add them to ./edits/dependencies.nix list if you find this dependency in
the nix-store.


Sadly for us, R.nvim requires an external R package that is currently not
packaged in the Nix store, this package is in the same repository as the
original plugin, following the same route with the last package:


```nix
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

    vimPlugins = prev.vimPlugins // {
        r-nvim = final.vimUtils.buildVimPlugin {
            pname = "R.nvim";
            version = "2025-08-20";
            src = final.fetchFromGitHub {
                owner = "R-nvim";
                repo = "R.nvim";
                rev = "main"; 
                #rev = "fef990378e4b5157f23314dca4136bc0079cc2c4"; #commit-hash
                #rev = "v0.99.0"; #tag
                sha256 = "sha256-mb8HCaMasPUP9JZUkH1sPrtdbhM2HMUkJEKDsRt6wTs=";
            };
        };
    };
}
```

In this case, we added this new package to the rPackages attribute set, just to
have it organized as if the packages were already in the nix-store. 


This time, since the source directory of the package is a nested directory in
the source repository, we point Nix to the correct source directory for the new
package with the *sourceRoot* variable. Maybe some packages need further
configuration, like *buildInputs*, *installPhase*, etc, you have to provide nix
all that it needs to add your package to the store.


Now, since R-nvim requires an R package to work, you need to add this
dependency to your plugin. Since nvimcom is a package for R, you should first
wrap R with nvimcom and then add this new version of R to the dependency list
of your plugin. Following the [instructions provided by Nix maintainers of R
modules][1], this should be something like this:

[1]: https://github.com/NixOS/nixpkgs/blob/nixos-25.05/doc/languages-frameworks/r.section.md

```nix
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
        recommendedPackages = prev.radianWrapper.recommendedPackages ++ (
            with final.rPackages; [
                languageserver
                nvimcom
            ]
        );
    };

    vimPlugins = prev.vimPlugins // {
        r-nvim = final.vimUtils.buildVimPlugin {
            pname = "R.nvim";
            version = "2025-08-20";
            src = final.fetchFromGitHub {
                owner = "R-nvim";
                repo = "R.nvim";
                rev = "main"; 
                #rev = "fef990378e4b5157f23314dca4136bc0079cc2c4"; #commit-hash
                #rev = "v0.99.0"; #tag
                sha256 = "sha256-mb8HCaMasPUP9JZUkH1sPrtdbhM2HMUkJEKDsRt6wTs=";
            };
            # You could also add this new package to ./edits/dependencies.nix,
            # I personally prefer to do it here, the locality of behaviour
            runtimeDeps = [
                final.rEnv
            ];
        };
    };
}
```

And that's it, this should cover a very reasonable amount of cases for new
packages for your Neovim config that are not available in nix-store. As a side
note, if you made it this far and built a new shiny and functional package, you
should consider committing your package to the Nix repository. You are not that
far from accomplishing this. If you have any trouble, feel free to ask. I would
love to help someone contribute to Nix.



