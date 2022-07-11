-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim'
  use 'nathom/filetype.nvim'

  use {
    'preservim/tagbar',
    cmd = 'TagbarToggle',
  }
  use 'godlygeek/tabular'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
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
    'nvim-treesitter/nvim-treesitter-textobjects',
  }

  -- autocompletion
  use({
    'hrsh7th/nvim-cmp',
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
      { 'williamboman/nvim-lsp-installer' },
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
    event = 'BufWinEnter',
    disable = false,
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
    config = function()
      vim.cmd("colorscheme dayfox")
    end,
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
    'RRethy/vim-illuminate',
    config = function ()
      vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>N', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})
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
          max_file_lines = nil, -- Do not enable for files with more than n lines, int
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

end)
