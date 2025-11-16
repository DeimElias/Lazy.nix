return {
	'kristijanhusak/vim-dadbod-ui',
	dependencies = {
		{ 'tpope/vim-dadbod',                     lazy = true },
		{ 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
	},
	cmd = {
		'DBUI',
		'DBUIToggle',
		'DBUIAddConnection',
		'DBUIFindBuffer',
	},
	keys = {
		{ "<leader>w", '<Plug>(DBUI_SaveQuery)',           mode = 'n', ft = { 'dbui', 'sql' }, desc = "Save Query" },
		{ "<leader>d", '<cmd>DBUIToggle<CR>',              mode = 'n', ft = { 'dbui', 'sql' }, desc = "Toggle Drawer" },
		{ "<C-i>",     '<Plug>(DBUI_ExecuteQuery)',        mode = 'n', ft = { 'dbui', 'sql' }, desc = "Exec Query" },
		{ "<C-i>",     '<ESC><Plug>(DBUI_ExecuteQuery) i', mode = 'i', ft = { 'dbui', 'sql' }, desc = "Exec Query" }
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_execute_on_save = 0
		vim.g.db_ui_win_position = 'right'
		vim.g.db_ui_disable_mappings_sql = 1
	end,
}
