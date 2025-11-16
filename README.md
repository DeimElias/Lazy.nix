# Lazy.nix -  A template to nixify your lazy.nvim config 
Lazy.nix is a Nix flake that aims to help to “nixify” Neovim configs with the
help of lazy.nvim's [lazyspecs](https://lazy.folke.io/spec), thus getting
access to many of the tools available with Lazy, such as lazy loading plugins.


If you are wondering “why should I do this?”, the main benefits are:


- Your editor configuration anywhere you are, with 2 commands at most (install
  Nix and call your configuration).
- Reproducible way of including your configuration "the Nix way" in Home
  Manager or NixOS.

## Some considerations...

Nix is a powerful package manager, and this template aims to use it as our only
package manager for plugins, LSP servers, treesitter parsers, and runtime
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

Clone this repository. You can see the "personal" branch to see an example
configuration. All the configurations for neovim are contained in the "edits" directory.


All your neovim settings will be in ./edits/settings.lua, this is a normal Lua file, for example:

```lua

vim.g.mapleader = " "   -- Need to set leader before lazy for correct keybindings

-- Save undo history
vim.opt.undofile = true

-- colorscheme
require('tokyonight').setup({ transparent = true })
vim.cmd.colorscheme('tokyonight')

vim.o.relativenumber = true
-- etc...
```

You should place all your lazyspec files in ./edits/lua/plugins/ as lua files,
just like you do in a normal lazy.nvim configuration, we have some initial
configurations for treesitter, with all parsers included, here is an example of a lazyspec file:

```lua
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		--- Here we disable language any download of parsers made by the plugin
		auto_install = false,
		ensure_installed = {},
		-- Those last 2 lines MUST remain as false and empty.
		highlight = { enalble = true, additional_vim_regex_highlighting = false, },
	},
	config = function()
		vim.api.nvim_create_autocmd('FileType', {
			--- here you can add any language want to have treesitter highlight
			pattern = { "nix", "lua" },
			callback = function() vim.treesitter.start() end,
		})
	end
}
```


Since the ./edits/lua directory is used to make a derivation, and then added to
the runtime path of Neovim, you can place any directory searched by Neovim in
the VIMRUNTIME (:h vimfiles).

Once you have added a plugin, you have to list this plugin in ./edits/plugins.nix as follows:

```nix
{ pkgs }:
with pkgs.vimPlugins;
[
  lazy-nvim
  blink-cmp
  nvim-lspconfig
  nvim-treesitter.withAllGrammars
  # Some plugins will require other plugins to be installed to pass some tests,
  # if you don't want to install or use them, you can override doCheck attribute
  # to disable those checks
  (tokyonight-nvim.overrideAttrs (original: {
    doCheck = false;
  }))
]
```
Remember that those names are for Nix-packed plugins.


If a plugin is not packaged, you can add it in ./edits/overlay.nix, see [Custom
plugins](https://github.com/DeimElias/Lazy.nix/blob/main/CustomPlugins.md)
section for instructions.


Some plugins require some external executables to work, like
language servers, debugger adapters, database executables, or utilities, etc.
those external dependencies should be included in ./edits/dependencies.nix

```nix
{ final }:
with final;
[
  # Language server
  nixd
  nixfmt-rfc-style
  lua-language-server

  # Debug adapters

  # runtimeDeps
  # sqlite

]
```


Once all parts are done, you can now use your new configured Neovim with 'nix
run' or add it to your system configuration or home-manager, adding the flake
to the inputs, then add the neovim package from this flake.

### For non-flake users


If you want to mimic this configuration without flakes, you can
copy this directory inside your configuration and add the following to
your main file configuration:


```nix
# home.nix or config.nix or whatever your file name is
  nixpkgs.overlays =
    let
      nvimDir = {nvimDir}; # Modify this to match your neovim directory
    in
    [
      (import (nvimDir + "/overlay.nix"))
      (import (nvimDir + "/edits/overlay.nix"))
    ];

# after that, you can install it with custom-neovim

home.programs = with pkgs; [custom-neovim]; # For Home manager
environment.systemPackages = with pkgs; [custom-neovim]; # for NixOS

```
After that, you can configure as described in the previous section
