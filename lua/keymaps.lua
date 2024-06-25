-- Map Space as Leader
vim.g.mapleader = " "

-- Clear search highlight on Escape
vim.keymap.set("n", "<Esc>", ":nohls<CR>", { silent = true })

-- Save with Ctrl+S
vim.keymap.set({ "i", "n", "v", "x" }, "<C-s>", vim.cmd.write, { silent = true })

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Ctrl-Backspace tp delete word backwards
vim.keymap.set("i", "<C-h>", "<C-w>")
vim.keymap.set("c", "<C-h>", "<C-w>")

-- Close buffer
vim.keymap.set("n", "<C-w>", "<Cmd>bd<CR>")

-- New buffer
vim.keymap.set('n', '<leader>b', ':enew<CR>')

-- Copy Whole file
vim.keymap.set('n', '<C-c>', ':%y+<CR>')

-- Open terminal
vim.keymap.set('n', '<leader>tt', ':terminal<CR>', { desc = 'Open terminal' })

-- Split window
vim.keymap.set("n", "<leader>zh", ":vsplit<Return>", { desc = 'Split window horizontally' })
vim.keymap.set("n", "<leader>zv", ":split<Return>", { desc = 'Split window vertically' })

-- Don't yank on pasting
vim.keymap.set("v", "p", "P")

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Bufferline
vim.keymap.set("n", "<C-l>", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineMoveNext<CR>", { silent = true })
vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineMovePrev<CR>", { silent = true })

-- Bufferline
vim.keymap.set('n', '<tab>', function()
  require('bufferline').cycle(1)
end, { desc = 'Goto next buffer' })


vim.keymap.set('n', '<S-tab>', function()
  require('bufferline').cycle(-1)
end, { desc = 'Goto prev buffer' })

vim.keymap.set('n', '<leader>x', function()
  vim.cmd('bwipeout!')
end, { desc = 'Close Buffer' })

-- NvimTree
vim.keymap.set("n", "<Leader>e", "<Cmd>NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<C-n>", "<Cmd>NvimTreeToggle<CR>", { silent = true })

-- Telescope
vim.keymap.set("n", "<Leader>ff", "<Cmd>Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<Leader>fg", "<Cmd>Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<Leader>fp", "<Cmd>Telescope projects<CR>", { silent = true })
vim.keymap.set("n", "<Leader><Space>", "<Cmd>Telescope buffers<CR>", { silent = true })
vim.keymap.set("n", "<Leader>gs", "<Cmd>Telescope git_status<CR>", { silent = true })

-- Lsp
vim.keymap.set("n", "<Leader>fm", "<Cmd>lua vim.lsp.buf.format({ async = true })<CR>", { silent = true })

-- Open terminal
vim.keymap.set('n', '<leader>tt', ':terminal<CR>')

-- go back to normal mode inside terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')

-- Fix theme colors
vim.keymap.set('n', '<leader>st', ':syntax sync fromstart<CR>')

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
