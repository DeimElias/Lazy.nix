return {
	{
		'jiaoshijie/undotree',
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ '<leader>u', ':UndotreeToggle<CR>', desc = "UndoTree" },
		},
		init = function()
			vim.g.undotree_SetFocusWhenToggle = 1
		end
	},
	{
		'folke/flash.nvim',
		event = 'VeryLazy',
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
	{                 -- Useful plugin to show you pending keybinds.
		'folke/which-key.nvim',
		event = 'VimEnter', -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.opt.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = '<Up> ',
					Down = '<Down> ',
					Left = '<Left> ',
					Right = '<Right> ',
					C = '<C-…> ',
					M = '<M-…> ',
					D = '<D-…> ',
					S = '<S-…> ',
					CR = '<CR> ',
					Esc = '<Esc> ',
					ScrollWheelDown = '<ScrollWheelDown> ',
					ScrollWheelUp = '<ScrollWheelUp> ',
					NL = '<NL> ',
					BS = '<BS> ',
					Space = '<Space> ',
					Tab = '<Tab> ',
					F1 = '<F1>',
					F2 = '<F2>',
					F3 = '<F3>',
					F4 = '<F4>',
					F5 = '<F5>',
					F6 = '<F6>',
					F7 = '<F7>',
					F8 = '<F8>',
					F9 = '<F9>',
					F10 = '<F10>',
					F11 = '<F11>',
					F12 = '<F12>',
				},
			},
		},
	},
	{
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
			{ "<leader>w", '<Plug>(DBUI_SaveQuery)',         mode = 'n', ft = { 'dbui', 'sql' }, desc = "Save Query" },
			{ "<leader>d", '<cmd>DBUIToggle<CR>',            mode = 'n', ft = { 'dbui', 'sql' }, desc = "Toggle Drawer" },
			{ "<C-i>",     '<Plug>(DBUI_ExecuteQuery)',      mode = 'n', ft = { 'dbui', 'sql' }, desc = "Exec Query" },
			{ "<C-i>",     '<ESC><Plug>(DBUI_ExecuteQuery) i', mode = 'i', ft = { 'dbui', 'sql' }, desc = "Exec Query" }
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_execute_on_save = 0
			vim.g.db_ui_win_position = 'right'
			vim.g.db_ui_disable_mappings_sql = 1
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = { "sindrets/diffview.nvim" },
		opts = {
			graph_style = "unicode",
			integrations = {
				telescope = true,
				diffview = true,
			},
		},
		keys = {
			{ "<leader>g", mode = "n", function() require("neogit").open() end, desc = "Neogit" },
		},
		cmd = "Neogit"
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
		},
		event = "VimEnter",
		keys = {
			{
				']c',
				mode = 'n',
				function()
					if vim.wo.diff then
						vim.cmd.normal({ ']c', bang = true })
					else
						require('gitsigns').nav_hunk('next')
					end
				end,
				desc = "Next hunk"
			},
			{
				'[c',
				mode = 'n',
				function()
					if vim.wo.diff then
						vim.cmd.normal({ '[c', bang = true })
					else
						require('gitsigns').nav_hunk('prev')
					end
				end,
				desc = "Prev hunk"
			},
			-- Actions
			{ '<leader>hs', mode = 'n', require('gitsigns').stage_hunk, desc = "Stage Hunk" },
			{ '<leader>hr', mode = 'n', require('gitsigns').reset_hunk, desc = "Reset Hunk" },
			{
				'<leader>hs',
				mode = 'v',
				function()
					require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
				end,
				desc = "Stage hunk"
			},
			{
				'<leader>hr',
				mode = 'v',
				function()
					require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
				end,
				desc = "Reset hunk"
			},
			{ '<leader>hS', mode = 'n', require('gitsigns').stage_buffer,                    desc = "Stage buffer" },
			{ '<leader>hR', mode = 'n', require('gitsigns').reset_buffer,                    desc = "Reset buffer" },
			{ '<leader>hp', mode = 'n', require('gitsigns').preview_hunk,                    desc = "Preview diff" },
			{ '<leader>hQ', mode = 'n', function() require('gitsigns').setqflist('all') end, desc = "Send all hunks to QFList" },
			{ '<leader>hq', mode = 'n', require('gitsigns').setqflist,                       desc = "Add Hunk to QFList" },

			-- Toggles
			{ '<leader>tb', mode = 'n', require('gitsigns').toggle_current_line_blame,       desc = "Toggle line blame" },
		}
	},
}
