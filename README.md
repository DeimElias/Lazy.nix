# Lazy.nix -  A template to nixify your lazy.nvim config
Lazy.nix is a nix flake that aims to help you to nixify your neovim configs
with the help of lazy.nvim's specs, thus getting access to many of the tools
available with Lazy, such as lazy loading plugins.

## Some considerations...

Nix is a powerful package manager, and we are going to use it as our package
manager for plugins, lsp servers, treesitter parsers and runtime dependencies.
This means that if your neovim plugin is a package manager with (maybe) some
utilities, you should disable all package manager capabilities and instead rely
purely on nix. Some examples are:

- *lazy.nvim*: We will be using lazyspecs, which enable multiple ways of
  lazydoading plugins, configure them and "track" dependencies.

- *nvim-tressitter*: We use it to enable some treesitter configuration, but all
  parsers should be added via nix.

- *mason*: mason is just a package manager for LSP, DAP adapters, linters,
  formaters, etc. We will fully replace this plugin with nix, and thus you
  should not have any lazyspec depend on this plugin.


## Use guide

Any neovim configuration consist of 2 parts, base neovim configurations
(numberline, relative numbers, colorscheme...), and plugins configurations,
those 2 parts have its place in edits/settings.lua and lua/plugins/*.lua,
respectively.


You should place all your lazyspec files in lua/plugins/ as lua files, just
like you do in a normal lazy.nvim configuration, we have some initial
configurations for treesitter, where we disable all it's package manager
capabilities. If you change this initial configuration, just keep disabled all
it's package manager capabilities. 


Since the lua directory is used to make a derivation, and then added to the
runtime path of neovim, you can place any directory searched by neovim in the
runtime (:h vimfiles).


Once you have all your plugins and configurations added, you now must list them
in ./edits/plugins.nix, with it's nixstore name. Many popular plugins are
already in the nix store, you should first try to find if it is already
packaged, some packages have a different name in the nixstore, many include
nvim at the begginning, use filters to only search for vimplugins. If a plugin
is not packaged, you can add them, see Custom plugins section for instructions.


There are plugins that requiere some external executables in order to work,
like language servers, debugger adapters, database exectutables or utilities,
etc, those extrernal dependencies should be included in
./edits/dependencies.nix


Once all parts are done, you can now use your new configured neovim with 'nix
run' or add it to your system configuration or home-manager, adding the flake
to the inputs and then adding the neovim package from this flake.


## Custom plugins

### Brief introduction

We use overlays to add plugins that are not already available in the nix store.
It makes it easier to follow the tutorial if you know how overlays work, so
here is a small introduction:

Overlays are a way to expand nix-store (or any store) with new packages or
different configurations of packages. An overlay is just a function with 2
arguments, commonly named *final* and *prev*, both of which represent a state
of the nix store. When you load a store of packages, you can modify it's
content with a "chain" of overlays (a list of overlays). 


When the first overlay of the chain is being applied, *prev* represents the
state of the store without any overlay applied. After that, *prev* represents
the state of the store after the last overlay have been applied (has you can
see, order does matter).


*final* represents the state of the store at the end of the entire chain of
overlays.


### Adding a plugin
You should use the ./edits/overlay.nix file to add your custom plugin, as an
example we will add R-nvim. First, find the source of your plugin, it may be a
github repository or a local directory. If it is a github repository you also
have to look for an identifier of the current (or past) commit of the
repository, this might be a tag, commit-hash or a branch. (recommened a tag or
commit-hash, since a branch may change it's hash with a new commit) (but if you
want your config to yell at you that your custom plugin has been updated,
consider using a branch).


R-nvim is an excelent example for a complex plugin, since it have custom
dependencies that also aren't in the nix store, let's start.


once we have an indentifier our code should look like this.

```{nix}
final: prev: {
    # We use prev here, because we want to modify a property
    vimPlugins = prev.vimPlugins // {

        # We use final to account for posible changes to vimUtils.buildVimPlugin,
        # ensuring we use the final version of the package to build our plugin
        r-nvim = final.vimUtils.buildVimPlugin {
            pname = "R.nvim";
            version = "2025-08-20";

            # Same reasoning here
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


To obtain the correct hash, simply build your package (nix build) and it will fail, giving you the correct hash.

```{nix}
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

Almost any package should be done by this point, you should try and add your
new plugin to ./edits/plugins.nix list, and some configuration in
./lua/plugins/{your-plugin-name}.lua, an test it's functionality. Some packages
requiere some aditional configurations, like some depenencies to work, add them
to ./edits/dependencies.nix list if you find this dependency in the nix-store.

Sadly for us, R.nvim requieres an external R package that is currently not
packaged in the nix store, this package is in the same repository as the
original plugin, following the same route with the last package:


```{nix}
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
the source repository, we point nix to the correct source directory for the new
package with the *sourceRoot* variable. Maybe some packages need futher
configuration, like *buildInputs*, *installPhase*, etc, you have to provide nix
all what it needs to add your package to the store.


Now, since R-nvim requieres a Rpackage to work you need to add this dependency
to your plugin, since nvimcom is a package for R, you should fist wrap R with
nvimocom and then add this new version of R to the dependency list of your
plugin. Following the [instructions provided by nix mantainters of R
modules][rInfo], this should be something like this:

[rInfo](https://github.com/NixOS/nixpkgs/blob/nixos-25.05/doc/languages-frameworks/r.section.md)

```{nix}
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
            # You could also add this new package in ./edits/dependencies.nix,
            # I personaly find this more reliable, locality of behaviour
            runtimeDeps = [
                final.rEnv
            ];
        };
    };
}
```

And that's it, this should cover a very reasonable amount of cases for new
packages for your neovim config that are nor available in nix-store. As a side
note, if you made it this far and built a new shiny and functional package, you
should consider to commit your package to the Nix repository, you are not that
far to acomplish this. If you have any trouble feel free to ask, I would love
to help someone to contribute to nix.
