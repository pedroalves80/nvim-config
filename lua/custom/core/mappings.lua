ContinuousResize = require"custom.core.utils".ContinuousResize

--, Core
vim.keymap.set('n', '<Esc>', ':noh<CR>', { desc = 'Clear highlights' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<C-c>', ':%y+<CR>', { desc = 'Copy whole file' })
vim.keymap.set('n', '<leader>n', ':set nu!<CR>', { desc = 'Toggle line number' })
vim.keymap.set('n', '<leader>rl', ':set rnu!<CR>', { desc = 'Toggle relative number' })
vim.keymap.set('n', 'j', [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], { desc = 'Move down', expr = true })
vim.keymap.set('n', 'k', [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], { desc = 'Move up', expr = true })
vim.keymap.set('n', '<Up>', [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], { desc = 'Move up', expr = true })
vim.keymap.set('n', '<Down>', [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], { desc = 'Move down', expr = true })
vim.keymap.set('n', '<leader>b', ':enew<CR>', { desc = 'New buffer' })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('i', '<C-b>', '<ESC>^i', { desc = 'Beginning of line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'End of line' })
vim.keymap.set('n', '<leader>st', ':syntax sync fromstart<CR>', { desc = 'Fix theme colors' })
vim.keymap.set("n", "<leader>rn", ":IncRename ")
--Change to unix file format
vim.keymap.set('n', '<leader>cf', ':set ff=unix<CR>', { desc = 'Change to Unix file format' })
vim.keymap.set('n', '<leader>cd', ':set ff=dos<CR>', { desc = 'Change to Dos file format' })


-- Terminal
-- Open terminal
vim.keymap.set('n', '<leader>tt', ':terminal<CR>', { desc = 'Open terminal' })

-- Split window
vim.keymap.set("n", "<leader>zh", ":vsplit<Return>", { desc = 'Split window horizontally' })
vim.keymap.set("n", "<leader>zv", ":split<Return>", { desc = 'Split window vertically' })

-- Resize Window
vim.keymap.set('n', "<C-w><left>", "<C-w><", { desc = 'Decrease window width' })
vim.keymap.set('n', "<C-w><right>", "<C-w>>", { desc = 'Increase window width' })
vim.keymap.set('n', "<C-w><up>", "<C-w>+", { desc = 'Increase window height' })
vim.keymap.set('n', "<c-w><down>", "<C-w>-", { desc = 'Decrease window height' })


-- go back to normal mode inside terminal 
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Go back to normal mode' })

--[[
vim.keymap.set('n', '<C-w><Down>', function() ContinuousResize("down") end, { noremap = true, silent = true })
vim.keymap.set('n', '<C-w><Up>', function() ContinuousResize("up") end, { noremap = true, silent = true })
vim.keymap.set('n', '<C-w><Left>', function() ContinuousResize("left") end, { noremap = true, silent = true })
vim.keymap.set('n', '<C-w><Right>', function() ContinuousResize("right") end, { noremap = true, silent = true })
]]--

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

-- Telescope
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = '[S]earch [G]it [S]tatus' })
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = '[S]earch [G]it [B]ranches' })
vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_bcommits, { desc = '[S]earch [G]it [C]ommits' })

vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })


-- Nvimtree
vim.keymap.set('n', '<C-n>', '<cmd> NvimTreeToggle <CR>');
vim.keymap.set('n', '<leader>e', '<cmd> NvimTreeFocus <CR>');

-- Git Conflict
vim.keymap.set('n', '<leader>gq', '<cmd> GitConflictListQf <CR>', { desc = 'Git Conflict List Quickfix' })

-- Harpoon
vim.keymap.set('n', '<leader>hh', '<cmd> lua require("harpoon.mark").add_file()<CR>', { desc = 'Add file to harpoon' })
vim.keymap.set('n', '<leader>hm', '<cmd> lua require("harpoon.ui").toggle_quick_menu()<CR>', { desc = 'Toggle harpoon menu' })
vim.keymap.set('n', '<leader>ht', ':Telescope harpoon marks<CR>', { desc = 'Toggle harpoon menu' })
