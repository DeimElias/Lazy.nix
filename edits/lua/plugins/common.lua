return {
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
