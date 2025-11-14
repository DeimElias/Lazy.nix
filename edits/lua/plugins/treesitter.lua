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
