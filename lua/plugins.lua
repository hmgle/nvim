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

end)
