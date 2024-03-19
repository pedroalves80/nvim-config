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
			--
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
		event = 'InsertEnter',
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
		'rebelot/kanagawa.nvim',
		config = function()
			require('kanagawa').setup(
				{
					transparent = true,
					colors = {
						theme = {
							all = {
								ui = {
									bg_gutter = 'none',
								}
							}
						}
					}
				}
			)
			vim.cmd("colorscheme kanagawa")
		end,
	},

	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = 'auto',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
		end,
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		main = 'ibl',
		config = function()
			require('ibl').setup {
				indent = {
					char = '',
				},
				whitespace = {
					remove_blankline_trail = true,
				}
			}
		end,
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
			require('bufferline').setup(
				require 'custom.plugins.configs.bufferline'
			)
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
		event = 'BufRead',
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
		event = 'InsertEnter',
		config = function()
			require('nvim-autopairs').setup()
		end,
	},

	{
		'windwp/nvim-ts-autotag',
		event = 'BufRead',
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
		'zbirenbaum/copilot.lua',
		event = 'InsertEnter',
		opts = {
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = '<F5>',
				},
			},

		},
	},

	{
		'akinsho/git-conflict.nvim',
		version = '*',
		config = true,
		event = 'BufRead',
	},

	{
		'kevinhwang91/nvim-ufo',
		dependencies = {
			'kevinhwang91/promise-async'
		},
	},

	{
		'numToStr/Comment.nvim',
		opts = {
			-- add any options here
		},
		lazy = false,
		config = function()
			require('Comment').setup()
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true,    -- use a classic bottom cmdline for search
					command_palette = true,  -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false,      -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false,  -- add a border to hover docs and signature help
				},
			})
		end,
	},

	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require('dashboard').setup {
				config = {
					header = {
						"",
						"",
						"███╗   ██╗██╗██╗    ██╗     ██████╗ ███████╗ ██████ ",
						"████╗  ██║██║██║    ██║    ██╔════╝ ██╔════╝██╔════ ",
						"██╔██╗ ██║██║██║ █╗ ██║    ██║  ███╗███████╗██║     ",
						"██║╚██╗██║██║██║███╗██║    ██║   ██║╚════██║██║     ",
						"██║ ╚████║██║╚███╔███╔╝    ╚██████╔╝███████║╚██████╗",
						"╚═╝  ╚═══╝╚═╝ ╚══╝╚══╝      ╚═════╝ ╚══════╝ ╚═════╝",
						"",
						"",

					}, --your header
				}
			}
		end,
		requires = {
			"nvim-tree/nvim-web-devicons",
		}
	},

	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
	},

	{
		"tpope/vim-repeat",
		cmd = "Repeat",
	}

}
