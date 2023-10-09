-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'preservim/tagbar',
    cmd = 'TagbarToggle',
    config = function ()
      vim.g.tagbar_silent = 1
    end
  }
  use 'godlygeek/tabular'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-fugitive'
  use {
    'kylechui/nvim-surround',
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  }
  use 'tpope/vim-abolish'
  use 'tpope/vim-repeat'

  -- nerdtree
  use {
    'scrooloose/nerdtree',
    cmd = 'NERDTreeTabsToggle',
  }
  use 'jistr/vim-nerdtree-tabs'


  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  use {
    'ianva/vim-youdao-translater',
    config = function()
      local map = require('utils').map
      map('v', '<leader>ee', ':<C-u>Ydv<CR>')
      map('n', '<leader>ee', ':<C-u>Ydc<CR>')
      map('n', '<leader>yd', ':<C-u>Yde<CR>')
    end
  }
  use 'jremmen/vim-ripgrep'
  use 'dyng/ctrlsf.vim'
  use 'ap/vim-buftabline'

  use {
    "Yggdroot/LeaderF",
    config = function()
      vim.g.Lf_ShortcutF = '<c-p>'
      vim.g.Lf_UseCache = 0
      vim.g.Lf_PreviewInPopup = 0
      require('utils').map('', '<leader>lf', ':LeaderfFunction!<cr>')
    end,
    run = ":LeaderfInstallCExtension"
  }

  use {
    'ray-x/go.nvim',
    config = function()
      require('go').setup()
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function ()
      require('config.treesitter')
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
  }

  -- autocompletion
  use({
    'hrsh7th/nvim-cmp',
    commit = 'cfafe0a1ca8933f7b7968a287d39904156f2c57d',
    config = function()
      require('config.cmp')
    end,
    requires = {
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      {
        'L3MON4D3/LuaSnip',
        config = function ()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
        requires = {
          'rafamadriz/friendly-snippets',
        },
      },
    },
  })

  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('config.lspconf')
    end,
    requires = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      {
        'jose-elias-alvarez/null-ls.nvim',
        requires = {{'neovim/nvim-lspconfig'}, {'nvim-lua/plenary.nvim'}},
        config = function()
          require('config.lsp.providers.null_ls')
        end,
        after = 'nvim-lspconfig',
      },
      {
        'ray-x/lsp_signature.nvim',
        config = function()
          require('config.lsp-signature')
        end,
        after = 'nvim-lspconfig',
      },
    },
    after = 'cmp-nvim-lsp',
  })

  -- great ui for lsp
  use {
    'glepnir/lspsaga.nvim',
    after = 'nvim-lspconfig',
    config = function() require('config.lspsaga') end,
    disable = true,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
    },
    config = function()
      require('config.telescope')
    end,
    disable = false,
  }

  use {
    "AckslD/nvim-neoclip.lua",
    requires = {
      {'nvim-telescope/telescope.nvim'},
    },
    config = function()
      require('config.neoclip')
    end,
    disable = true,
  }

  use {
    "gbprod/yanky.nvim",
    requires = {
      {'nvim-telescope/telescope.nvim'},
    },
    config = function()
      require('config.yanky')
    end,
  }

  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = "day"
      vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

      -- Change the "hint" color to the "orange" color, and make the "error" color bright red
      vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }
      vim.cmd[[colorscheme tokyonight]]
    end,
    disable = true
  }

  use {
    'EdenEast/nightfox.nvim',
    -- config = function()
    --   vim.cmd("colorscheme dayfox")
    -- end,
    disable = false
  }

  use {
    'savq/melange',
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'light'
      vim.cmd("colorscheme melange")
    end,
    disable = true
  }

  use {
    'sainnhe/gruvbox-material',
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'light'
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_current_word = 'bold'
      vim.cmd("colorscheme gruvbox-material")
    end
  }

  use {
    'RRethy/vim-illuminate',
    config = function ()
      vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>N', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})
      -- vim.g.Illuminate_useDeprecated = 1
    end
  }

  use {
    'kosayoda/nvim-lightbulb',
    requires = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('config.lightbulb')
    end,
  }

  use {
    'p00f/nvim-ts-rainbow',
    config = function ()
      require("nvim-treesitter.configs").setup {
        rainbow = {
          enable = true,
          -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = 1000, -- Do not enable for files with more than n lines, int
          -- colors = {}, -- table of hex strings
          -- termcolors = {} -- table of colour name strings
        }
      }
    end
  }

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  use {
    'jeetsukumaran/vim-indentwise',
    config = function()
      local map = require('utils').map
      map('v', '<leader>u', '<Plug>(IndentWisePreviousLesserIndent)')
      map('n', '<leader>u', '<Plug>(IndentWisePreviousLesserIndent)')
      map('v', '<leader>d', '<Plug>(IndentWiseNextLesserIndent)')
      map('n', '<leader>d', '<Plug>(IndentWiseNextLesserIndent)')
    end
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
      local opt = { expr = true, remap = true }
      -- Toggle using count
      vim.keymap.set('n', '<leader>cc', "v:count == 0 ? '<Plug>(comment_toggle_current_linewise)' : '<Plug>(comment_toggle_linewise_count)'", opt)
      vim.keymap.set('n', '<leader>cb', "v:count == 0 ? '<Plug>(comment_toggle_current_blockwise)' : '<Plug>(comment_toggle_blockwise_count)'", opt)

      -- Toggle in Op-pending mode
      vim.keymap.set('n', '<leader>cgc', '<Plug>(comment_toggle_linewise)')
      vim.keymap.set('n', '<leader>cgb', '<Plug>(comment_toggle_blockwise)')

      -- Toggle in VISUAL mode
      vim.keymap.set('x', '<leader>cc', '<Plug>(comment_toggle_linewise_visual)')
      vim.keymap.set('x', '<leader>cb', '<Plug>(comment_toggle_blockwise_visual)')
    end
  }

  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        triggers_nowait = {
          -- marks
          "`",
          "'",
          "<c-r>",
        },
      }
    end
  }

  -- clipboard over ssh through tmux
  use {
    'ojroques/nvim-osc52',
    config = function()
      require('config.osc52')
    end,
    disable = true,
  }

end)
