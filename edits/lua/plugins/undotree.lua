return {
	'jiaoshijie/undotree',
	config = true,
	keys = { -- load the plugin only when using it's keybinding:
		{ '<leader>u', ':UndotreeToggle<CR>', desc = "UndoTree" },
	},
	init = function()
		vim.g.undotree_SetFocusWhenToggle = 1
	end
}
