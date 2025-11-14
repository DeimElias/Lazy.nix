return {
	"neovim/nvim-lspconfig",
	config = function()
		--- Here you can configure your lsp servers. don't forget to enable them after you configure them
		vim.lsp.config(
			"nixd",
			{
				settings = {
					nixd = {
						nixpkgs = {
							expr = "import <nixpkgs> { }"
						},
						formatting = {
							command = { "nixfmt" }
						},
						options = {
							nixos = {
								expr =
								'(builtins.getFlake "/tmp/NixOS_Home-Manager").nixosConfigurations.hostname.options'
							},
							home_manager = {
								expr =
								'(builtins.getFlake "/tmp/NixOS_Home-Manager").homeConfigurations."user@hostname".options'
							},
							flake_parts = {
								expr =
								'let flake = builtins.getFlake ("/tmp/NixOS_Home-Manager"); in flake.debug.options // flake.currentSystem.options'
							}
						}
					}
				}
			}
		)
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							"FIXME/pack/myNeovimPackages/start/"
						}
					}
				}
			}
		})
		vim.lsp.enable("nixd")
		vim.lsp.enable("lua_ls")
	end
}
