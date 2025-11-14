return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
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
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	}
}
