vim.g.mapleader = " "   -- Need to set leader before lazy for correct keybindings

-- Save undo history
vim.opt.undofile = true

-- colorscheme
require('tokyonight').setup({ transparent = true })
vim.cmd.colorscheme('tokyonight')

vim.o.relativenumber = true
-- Enable break indent
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Move Line
vim.keymap.set('n', '<C-k>', '<cmd>mo .-2<CR>')
vim.keymap.set('n', '<C-j>', '<cmd>mo .+1<CR>')
vim.keymap.set('v', '<C-k>', ":'< mo .-2<CR>gv")
vim.keymap.set('v', '<C-j>', ":'<,'> mo '>+1<CR>gv")

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Page relocate
vim.keymap.set('n', '<C-D>', '<C-D>zz')
vim.keymap.set('n', '<C-U>', '<C-U>zz')

-- Highlight line
vim.opt.cursorline = true

-- Set cursror type
vim.opt.guicursor = 'n-v-c:block'
-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Set window border
vim.opt.winborder = 'rounded'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- TIP: Disable arrow keys in normal and insert mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set('i', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('i', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('i', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('i', '<down>', '<cmd>echo "Use j to move!!"<CR>')


-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 15
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.api.nvim_create_autocmd('BufWritePre', {
	desc = 'Autoformat on save',
	callback = function()
		vim.lsp.buf.format()
	end,
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fr', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Telescope Fuzzy find in Buffer' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
