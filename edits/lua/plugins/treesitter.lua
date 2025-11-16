return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		auto_install = false,
		ensure_installed = {},
		highlight = { enalble = true, additional_vim_regex_highlighting = false, },
	},
	config = function()
		vim.api.nvim_create_autocmd('FileType', {
			pattern = { "python", "nix", "r", "quarto", "lua", "markdown", "html", "nu", "sql" },
			callback = function() vim.treesitter.start() end,
		})
	end
}
