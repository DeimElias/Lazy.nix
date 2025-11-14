# Lazy.nix -  A template to nixify your lazy.nvim config Lazy.nix is a Nix
flake that aims to help to “nixify” Neovim configs with the help of lazy.nvim's
[lazyspecs](https://lazy.folke.io/spec), thus getting access to many of the tools
available with Lazy, such as lazy loading plugins.


If you are wondering “why should I do this?”, the main benefits are:


- Your editor configuration anywhere you are, with 2 commands at most (install
  Nix and call your configuration)
- Reproducible way of including your configuration "the Nix way" in Home
  Manager or NixOS.

## Some considerations...

Nix is a powerful package manager, and this template aims to use it as our only
package manager for plugins, lsp servers, treesitter parsers, and runtime
dependencies. This means that if a Neovim plugin is a package manager with
(maybe) some utilities, all of its package manager capabilities should be
disabled and instead rely purely on nix. Some examples are:

- *lazy.nvim*: This project disables any plugin management, only  using
  lazyspecs, which enable multiple ways of lazydoading plugins, configure them
  and "track" it's dependencies.

- *nvim-tressitter*: We use it to enable some treesitter configuration, but all
  parsers should be added via nix.

- *mason*: mason is just a package manager for LSP, DAP adapters, linters,
  formaters, etc. We will fully replace this plugin with nix, and thus you
  should not have any lazyspec to depend on this plugin.


This template was crafted so that any configuration for Neovim would be
contained in the edits directory. The following instructions will explain where
every part of your configuration should be. It's important to keep every folder
and file name as they are, since they are hardcoded in flake.nix, lua.nix, and
overlay.nix

## Use guide


First, clone this repository. There is another branch named Personal, where you
can find my personal configuration to take as an example if you want to see it
in action. Once cloned, you could integrate your configuration as follows:

Any Neovim configuration  with lazy.nvim consists of 2 parts: base neovim
configurations (numberline, relative numbers, colorscheme...), and plugin
configurations, those 2 parts have it's place in edits/settings.lua and
edits/lua/plugins/*.lua, respectively.


You should place all your lazyspec files in ./edits/lua/plugins/ as lua files,
just like you do in a normal lazy.nvim configuration, we have some initial
configurations for treesitter, where we disable all its package manager
capabilities. This version of Tressiter includes all parsers by default. If you
change this initial configuration, just keep all its package manager
capabilities disabled. 


Since the ./edits/lua directory is used to make a derivation, and then added to
the runtime path of Neovim, you can place any directory searched by Neovim in
the VIMRUNTIME (:h vimfiles).


Once you have all your plugins and configurations added, you must list them in
./edits/plugins.nix, with their nixstore name. Many popular plugins are already
in the Nix store. You should first try to find if it is already packaged; some
packages have a different name in the nixstore, many include nvim at the
beginning, use filters to only search for vimplugins. If a plugin is not
packaged, you can add it in ./edits/overlay.nix, see [Custom
plugins](https://github.com/DeimElias/Lazy.nix/blob/main/CustomPlugins.md)
section for instructions.


There are plugins that require some external executables in order to work, like
language servers, debugger adapters, database executables, or utilities, etc,
those external dependencies should be included in ./edits/dependencies.nix


Once all parts are done, you can now use your new configured Neovim with 'nix
run' or add it to your system configuration or home-manager, adding the flake
to the inputs, then add the neovim package from this flake.
