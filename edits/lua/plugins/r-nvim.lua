return {
	{
		"R-nvim/R.nvim",
		lazy = false,
		opts = {
			-- Create a table with the options to be passed to setup()

			R_app = "radian",
			bracketed_paste = true,
			R_args = { "--save", "--restore-data" },
			quarto_preview_args = ", port=42069",
			clear_line = true,
			external_term = "tmux new-window -d -n Radian",
			auto_start = "on startup",
			auto_quit = true,
			hook = {
				on_filetype = function()
					-- This function will be called at the FileType event
					-- of files supported by R.nvim. This is an
					-- opportunity to create mappings local to buffers.
					vim.keymap.set("n", "<C-i>", "<Plug>RDSendLine", { buffer = true })
					vim.keymap.set("v", "<C-i>", "<Plug>RSendSelection", { buffer = true })
					vim.keymap.set("i", "<C-i>", "<Esc><Plug>RSendLine i", { buffer = true })
					vim.keymap.set("i", "<C-T>", "|><enter>", { buffer = true })

					local wk = require("which-key")
					wk.add({
						buffer = true,
						{ "<localleader>a", group = "all" },
						{ "<localleader>b", group = "between marks" },
						{ "<localleader>c", group = "chunks" },
						{ "<localleader>f", group = "functions" },
						{ "<localleader>g", group = "goto" },
						{ "<localleader>i", group = "install" },
						{ "<localleader>k", group = "knit" },
						{ "<localleader>p", group = "paragraph" },
						{ "<localleader>q", group = "quarto" },
						{ "<localleader>r", group = "r general" },
						{ "<localleader>s", group = "split or send" },
						{ "<localleader>t", group = "terminal" },
						{ "<localleader>v", group = "view" },
					})
				end,
			},
			pdfviewer = "ebook-viewer",
		},
		config = function(_, opts)
			vim.g.rout_follow_colorscheme = true
			require("r").setup(opts)
			require("r.pdf.generic").open = vim.ui.open
		end,
	}
}
