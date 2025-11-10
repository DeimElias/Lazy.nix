return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			{ "R-nvim/cmp-r" },
			{ "jmbuhr/otter.nvim" },
		},
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = false,
						kind_resolution = {
							enabled = false,
						},
						semantic_token_resolution = {
							enabled = false,
						},
					},
				},
				menu = {
					draw = {
						columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
					}
				}
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { 'snippets', 'dadbod', 'buffer' },
					quarto = { 'snippets', 'cmp_r', 'otter', 'path' },
					r = { 'snippets', 'cmp_r', 'otter', 'path' },
				},
				providers = {
					cmp_r = {
						name = "cmp_r",
						module = "blink.compat.source",
						opts = {},
					},
					otter = {
						name = "otter",
						module = "blink.compat.source",
						opts = {},
					},
					dadbod = { name = "dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	}
}
