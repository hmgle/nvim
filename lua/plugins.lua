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
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim'
    }
  },

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
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  {
    'kevinhwang91/nvim-hlslens',
    config = function ()
      require('hlslens').setup()
      local kopts = {noremap = true, silent = true}

      vim.api.nvim_set_keymap('n', 'n',
      [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
      kopts)
      vim.api.nvim_set_keymap('n', 'N',
      [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
      kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
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

  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    keys =
    {
      {'<A-1>', '<Cmd>BufferGoto 1<CR>', desc = 'Go to the 1 buffer', mode = 'n'},
      {'<A-2>', '<Cmd>BufferGoto 2<CR>', desc = 'Go to the 2 buffer', mode = 'n'},
      {'<A-3>', '<Cmd>BufferGoto 3<CR>', desc = 'Go to the 3 buffer', mode = 'n'},
      {'<A-4>', '<Cmd>BufferGoto 4<CR>', desc = 'Go to the 4 buffer', mode = 'n'},
      {'<A-5>', '<Cmd>BufferGoto 5<CR>', desc = 'Go to the 5 buffer', mode = 'n'},
      {'<A-6>', '<Cmd>BufferGoto 6<CR>', desc = 'Go to the 6 buffer', mode = 'n'},
    },
    lazy = false,
    opts = function(_, o)
      o.icons =
      {
        buffer_index = true,
        -- buffer_number = true,
        filetype = { enabled = false },

        button = false,
        current =
        {
          diagnostics = {{enabled = false}, {enabled = false}},
          gitsigns = {added = {enabled = false}, changed = {enabled = false}, deleted = {enabled = false}},
          -- buffer_index = true,
        },
        diagnostics = {{enabled = true, icon = ''}, {enabled = true, icon = ''}},
        gitsigns = {added = {enabled = true}, changed = {enabled = true}, deleted = {enabled = true}},
        modified = {button = false},
        pinned = {button = '', filename = true},
        preset = 'slanted',
        -- visible = {modified = {buffer_number = true}},
      }
    end,
    enabled = false,
  },

  {
    'ojroques/nvim-hardline',
    config = function ()
      require('hardline').setup({
        bufferline = true,
        bufferline_settings = {
          show_index = true,
        },
        theme = 'nordic',
      })
    end,
  },
  {
    'johann2357/nvim-smartbufs',
    keys = {
      {'<A-1>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(1)<CR>', desc = 'Go to the 1 buffer', mode = 'n'},
      {'<A-2>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(2)<CR>', desc = 'Go to the 2 buffer', mode = 'n'},
      {'<A-3>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(3)<CR>', desc = 'Go to the 3 buffer', mode = 'n'},
      {'<A-4>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(4)<CR>', desc = 'Go to the 4 buffer', mode = 'n'},
      {'<A-5>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(5)<CR>', desc = 'Go to the 5 buffer', mode = 'n'},
      {'<A-6>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(6)<CR>', desc = 'Go to the 6 buffer', mode = 'n'},
    },
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
    "gbprod/substitute.nvim",
    config = function  ()
      require("substitute").setup({
      })
      vim.keymap.set("n", "<leader>r", require('substitute').operator, { noremap = true })
      vim.keymap.set("n", "<leader>rs", require('substitute').line, { noremap = true })
      vim.keymap.set("n", "<leader>rS", require('substitute').eol, { noremap = true })
      vim.keymap.set("x", "<leader>r", require('substitute').visual, { noremap = true })
    end
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

  -- plantUML preview for .uml
  'aklt/plantuml-syntax',
  'scrooloose/vim-slumlord',
}
