return {
  'nvim-lua/plenary.nvim',

  {
    'preservim/tagbar',
    cmd = 'TagbarToggle',
    config = function ()
      vim.g.tagbar_silent = 1
    end
  },
  'godlygeek/tabular',
  'tpope/vim-sleuth',
  'tpope/vim-fugitive',
  {
    'kylechui/nvim-surround',
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  'tpope/vim-abolish',
  'tpope/vim-repeat',

  -- nerdtree
  {
    'scrooloose/nerdtree',
    cmd = 'NERDTreeTabsToggle',
  },
  'jistr/vim-nerdtree-tabs',

  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- mapping to toggle outline
      { "<c-w><c-e>", "<cmd>Outline!<CR>", desc = "Toggle outline" },
    },
    opts = {
      symbol_folding = {
        autofold_depth = false,
      },
    },
  },

  {
    'smoka7/hop.nvim',
    event = "VeryLazy",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },

  {
    'ianva/vim-youdao-translater',
    config = function()
      local map = require('utils').map
      map('v', '<leader>ee', ':<C-u>Ydv<CR>')
      map('n', '<leader>ee', ':<C-u>Ydc<CR>')
      map('n', '<leader>yd', ':<C-u>Yde<CR>')
    end
  },
  'jremmen/vim-ripgrep',
  'dyng/ctrlsf.vim',
  'ap/vim-buftabline',

  {
    "Yggdroot/LeaderF",
    init = function()
      vim.g.Lf_ShortcutF = '<c-p>'
      vim.g.Lf_UseCache = 0
      vim.g.Lf_PreviewInPopup = 0
      require('utils').map('', '<leader>lf', ':LeaderfFunction!<cr>')
    end,
    build = ":LeaderfInstallCExtension"
  },

  {
    'ray-x/go.nvim',
    ft = { "go" },
    config = function()
      require('go').setup({
        lsp_codelens = false,
        lsp_inlay_hints = {
          enable = false,
          -- hint style, set to 'eol' for end-of-line hints, 'inlay' for inline hints
          -- inlay only avalible for 0.10.x
          style = 'inlay',
        },
      })
      vim.cmd([[
      augroup go.filetype
      autocmd!
        autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
      augroup end
      ]])
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    config = function ()
      require('config.treesitter')
    end
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },

  -- autocompletion
  {
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.cmp')
    end,
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      {
        'L3MON4D3/LuaSnip',
        config = function ()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
        dependencies = {
          'rafamadriz/friendly-snippets',
        },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      require('config.lspconf')
    end,
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
          require('config.lsp.providers.null_ls')
        end,
      },
      {
        'ray-x/lsp_signature.nvim',
        config = function()
          require('config.lsp-signature')
        end,
      },
    },
  },

  -- great ui for lsp
  {
    'glepnir/lspsaga.nvim',
    dependencies = 'nvim-lspconfig',
    config = function() require('config.lspsaga') end,
    enabled = false,
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      }
    },
    config = function()
      require('config.telescope')
    end,
    enabled = true,
  },

  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      {'nvim-telescope/telescope.nvim'},
    },
    config = function()
      require('config.neoclip')
    end,
    enabled = false,
  },

  {
    "gbprod/yanky.nvim",
    dependencies = {
      {'nvim-telescope/telescope.nvim'},
    },
    config = function()
      require('config.yanky')
    end,
  },

  {
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = "day"
      vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

      -- Change the "hint" color to the "orange" color, and make the "error" color bright red
      vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }
      vim.cmd[[colorscheme tokyonight]]
    end,
    enabled = false
  },

  {
    'EdenEast/nightfox.nvim',
    -- config = function()
    --   vim.cmd("colorscheme dayfox")
    -- end,
    enabled = true
  },

  {
    'savq/melange',
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'light'
      vim.cmd("colorscheme melange")
    end,
    enabled = false
  },

  {
    'sainnhe/gruvbox-material',
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'light'
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_current_word = 'bold'
      vim.g.gruvbox_material_foreground = 'original'
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_show_eob = 0
      vim.g.gruvbox_material_dim_inactive_windows = 1
      vim.g.gruvbox_material_ui_contrast = 'high'
      vim.cmd("colorscheme gruvbox-material")
    end
  },

  {
    'RRethy/vim-illuminate',
    config = function ()
      vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>N', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})
      -- vim.g.Illuminate_useDeprecated = 1
    end
  },

  {
    'kosayoda/nvim-lightbulb',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('config.lightbulb')
    end,
  },

  {
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
  },

  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },

  {
    'jeetsukumaran/vim-indentwise',
    config = function()
      local map = require('utils').map
      map('v', '<leader>u', '<Plug>(IndentWisePreviousLesserIndent)')
      map('n', '<leader>u', '<Plug>(IndentWisePreviousLesserIndent)')
      map('v', '<leader>d', '<Plug>(IndentWiseNextLesserIndent)')
      map('n', '<leader>d', '<Plug>(IndentWiseNextLesserIndent)')
    end
  },

  {
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
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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
  },

  -- clipboard over ssh through tmux
  {
    'ojroques/nvim-osc52',
    config = function()
      require('config.osc52')
    end,
    enabled = false,
  },

  {
    'akinsho/toggleterm.nvim', version = "*",
    config = function ()
      require('config.toggleterm')
    end
  },

  {
    'h-hg/fcitx.nvim',
    enable = vim.loop.os_uname().sysname == 'Linux' and true or false,
  },
}
