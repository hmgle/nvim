-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

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

  use 'ianva/vim-youdao-translater'
  use 'jremmen/vim-ripgrep'
  use 'dyng/ctrlsf.vim'
  use 'ap/vim-buftabline'

  use({ "Yggdroot/LeaderF", run = ":LeaderfInstallCExtension" })

  use 'ray-x/go.nvim'

  use {
    'nvim-treesitter/nvim-treesitter'
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects'
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
  }

end)
