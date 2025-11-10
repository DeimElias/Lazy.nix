{ luaDir, plugins }:
# lua
''
  --- Add ./Lua directory to VimRuntimePath so LazyVim can read lua files
  vim.opt.runtimepath:append("${luaDir}")
  --- Here we load lazy with some options that enable nix-plugins to be loaded
  require("lazy").setup(
  	{
  		performance = {
  			reset_packpath = false,
  			rtp = {
  				reset = false
  			}
  		},
  		dev = {
  			path = "${plugins}",
  			patterns = { "" }, 
  		},
  		install = {
  			missing = false
  		},
  		spec = {
  			{ import = "plugins" }
  		}
  	}
  )
''
