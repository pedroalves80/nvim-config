-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	-- NOTE: First, some plugins that don't require any configuration

	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',

	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',
			opts = {
				inlay_hints = { enabled = true }
			}
		},
		init = function()
			local plugin = 'nvim-lspconfig'
			vim.api.nvim_create_autocmd({ 'BufRead', 'BufWinEnter', 'BufNewfile' }, {
				group = vim.api.nvim_create_augroup('BeLazyOnFileOpen' .. plugin, {}),
				callback = function()
					local file = vim.fn.expand '%'
					local condition = file ~= 'NvimTree_1' and file ~= '[lazy]' and file ~= ''

					if condition then
						vim.api.nvim_del_augroup_by_name('BeLazyOnFileOpen' .. plugin)

						require('lazy').load { plugins = plugin }
					end
				end
			})
		end
	},

	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
	},

	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim',          opts = {} },
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
					{ buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
				vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
					{ buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
				vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
					{ buffer = bufnr, desc = '[P]review [H]unk' })
			end,
		},
	},

	{
		-- Theme
		'catppuccin/nvim',
		name = 'catppuccin',
		lazy = false,
		priority = 2000,
		opts = {
			flavour = 'macchiato',
			background = { -- :h background
				light = 'latte',
				dark = 'mocha',
			},
			transparent_background = true,
		},
		config = function(_, opts)
			local catppuccin = require 'catppuccin';
			catppuccin.setup(opts);
			catppuccin.load();
		end,
	},

	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = 'catppuccin',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = '┊',
			show_trailing_blankline_indent = false,
		},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim',         opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{ 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},

	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		config = function()
			require('nvim-treesitter.configs').setup {
				require 'custom.plugins.configs.treesitter'
			}
		end,
		build = ':TSUpdate',
	},

	{
		'akinsho/bufferline.nvim',
		version = '*',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			vim.opt.termguicolors = true;
			require('bufferline').setup()
		end,
		init = function()
			return require 'custom.core.mappings'
		end
	},

	{
		'nvim-tree/nvim-tree.lua',
		opts = function()
			return require 'custom.plugins.configs.nvimtree'
		end,
		config = function(_, opts)
			require('nvim-tree').setup(opts)
		end,
	},


	-- Todo Comments Hightlights
	{
		'folke/todo-comments.nvim',
		lazy = false,
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('todo-comments').setup()
		end,
	},

	{
		'ThePrimeagen/vim-be-good',
		event = 'BufRead',
		config = function()
			vim.g['be_good_do_not_map_keys'] = 1
		end,
	},

	{
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup()
		end,
	},

	{
		'windwp/nvim-ts-autotag',
		event = 'InsertEnter',
		config = function()
			require('nvim-ts-autotag').setup()
		end,
	},

	{
		'f-person/git-blame.nvim',
		event = 'BufRead',
		config = function()
			vim.cmd [[
        nnoremap <leader>gb <cmd>GitBlameToggle<cr>
      ]]
		end,
	},

	{
		'jose-elias-alvarez/null-ls.nvim'
	}
}
