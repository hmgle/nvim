return {
  'nvim-lua/plenary.nvim',

  {
    'preservim/tagbar',
    cmd = 'TagbarToggle',
    config = function()
      vim.g.tagbar_silent = 1
    end,
  },
  'godlygeek/tabular',
  'tpope/vim-sleuth',
  'tpope/vim-fugitive',
  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  'tpope/vim-abolish',
  'tpope/vim-repeat',

  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require 'config.nvim-tree'
    end,
  },

  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { -- mapping to toggle outline
      { '<c-w><c-e>', '<cmd>Outline!<CR>', desc = 'Toggle outline' },
    },
    opts = {
      symbol_folding = {
        autofold_depth = false,
      },
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      jump = {
        autojump = true,
        nohlsearch = true,
      },
      label = {
        uppercase = false,
      },
      highlight = {
        -- show a backdrop with hl FlashBackdrop
        backdrop = false,
        -- Highlight the search matches
        matches = false,
        groups = {
          label = 'FlashMatch',
        },
      },
      modes = {
        char = {
          jump_labels = false,
          multi_line = false,
          highlight = {
            backdrop = false,
            matches = false,
            groups = {
              label = 'FlashMatch',
            },
          },
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
    },
  },

  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
      local kopts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
  },

  {
    'ianva/vim-youdao-translater',
    config = function()
      local map = require('utils').map
      map('v', '<leader>ee', ':<C-u>Ydv<CR>')
      map('n', '<leader>ee', ':<C-u>Ydc<CR>')
      map('n', '<leader>yd', ':<C-u>Yde<CR>')
    end,
  },
  {
    'Yggdroot/LeaderF',
    init = function()
      -- vim.g.Lf_ShortcutF = '<c-p>'
      vim.g.Lf_UseCache = 0
      vim.g.Lf_PreviewInPopup = 0
      vim.g.Lf_HideHelp = 1
      vim.g.Lf_CommandMap = {
        ['<ESC>'] = { '<ESC>', '<C-O>' },
      }

      require('utils').map('', '<leader>lf', ':LeaderfFunction!<cr>')
    end,
    build = ':LeaderfInstallCExtension',
  },
  {
    'ojroques/nvim-hardline',
    config = function()
      require('hardline').setup {
        bufferline = true,
        bufferline_settings = {
          show_index = true,
        },
        theme = 'nordic',
      }
      vim.opt.showmode = true
    end,
  },
  {
    'johann2357/nvim-smartbufs',
    keys = {
      { '<A-1>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(1)<CR>', desc = 'Go to the 1 buffer', mode = 'n' },
      { '<A-2>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(2)<CR>', desc = 'Go to the 2 buffer', mode = 'n' },
      { '<A-3>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(3)<CR>', desc = 'Go to the 3 buffer', mode = 'n' },
      { '<A-4>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(4)<CR>', desc = 'Go to the 4 buffer', mode = 'n' },
      { '<A-5>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(5)<CR>', desc = 'Go to the 5 buffer', mode = 'n' },
      { '<A-6>', '<Cmd>lua require("nvim-smartbufs").goto_buffer(6)<CR>', desc = 'Go to the 6 buffer', mode = 'n' },
    },
  },

  {
    'ray-x/go.nvim',
    ft = { 'go' },
    config = function()
      require('go').setup {
        lsp_codelens = false,
        lsp_inlay_hints = {
          enable = false,
          -- hint style, set to 'eol' for end-of-line hints, 'inlay' for inline hints
          -- inlay only avalible for 0.10.x
          style = 'inlay',
        },
      }
      vim.cmd [[
      augroup go.filetype
      autocmd!
        autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
      augroup end
      ]]
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'config.treesitter'
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },

  -- autocompletion
  { -- gh copilot
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
        },
      }
    end,
  },

  {
    'hrsh7th/nvim-cmp',
    commit = '7e348da',
    config = function()
      require 'config.cmp'
    end,
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      {
        'L3MON4D3/LuaSnip',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
        dependencies = {
          'rafamadriz/friendly-snippets',
        },
      },
      -- copilot
      {
        'zbirenbaum/copilot-cmp',
        dependencies = 'zbirenbaum/copilot.lua',
        config = function(_, opts)
          local copilot_cmp = require 'copilot_cmp'
          copilot_cmp.setup(opts)
        end,
      },
      -- codeium
      {
        'Exafunction/codeium.nvim',
        cmd = 'Codeium',
        opts = {},
        enabled = false,
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      require 'config.lspconf'
    end,
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      {
        'ray-x/lsp_signature.nvim',
        config = function()
          require 'config.lsp-signature'
        end,
      },
    },
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require 'config.conform'
    end,
  },

  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require 'config.lint'
    end,
  },

  {
    {
      'folke/lazydev.nvim',
      ft = 'lua', -- only load on lua files
      opts = {
        library = {
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        },
      },
    },
    { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
    { -- optional completion source for require statements and module annotations
      'hrsh7th/nvim-cmp',
      opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
          name = 'lazydev',
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        })
      end,
    },
  },

  -- great ui for lsp
  {
    'glepnir/lspsaga.nvim',
    dependencies = 'nvim-lspconfig',
    config = function()
      require 'config.lspsaga'
    end,
    enabled = false,
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'rcarriga/nvim-notify',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      },

      {
        'nvim-telescope/telescope-frecency.nvim',
        config = function()
          require('telescope').setup {
            extensions = {
              frecency = {
                matcher = 'fuzzy',
                show_scores = true,
                show_filter_column = false,
              },
            },
          }
          require('telescope').load_extension 'frecency'
        end,
      },
    },
    event = 'VeryLazy',
    config = function()
      require 'config.telescope'
    end,
    enabled = true,
  },

  {
    'AckslD/nvim-neoclip.lua',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      require 'config.neoclip'
    end,
    enabled = false,
  },

  {
    'gbprod/yanky.nvim',
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      require 'config.yanky'
    end,
  },

  {
    'gbprod/substitute.nvim',
    config = function()
      require('substitute').setup {}
      vim.keymap.set('n', '<leader>r', require('substitute').operator, { noremap = true })
      vim.keymap.set('n', '<leader>rs', require('substitute').line, { noremap = true })
      vim.keymap.set('n', '<leader>rS', require('substitute').eol, { noremap = true })
      vim.keymap.set('x', '<leader>r', require('substitute').visual, { noremap = true })
    end,
  },

  {
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = 'day'
      vim.g.tokyonight_sidebars = { 'qf', 'vista_kind', 'terminal', 'packer' }

      -- Change the "hint" color to the "orange" color, and make the "error" color bright red
      vim.g.tokyonight_colors = { hint = 'orange', error = '#ff0000' }
      vim.cmd [[colorscheme tokyonight]]
    end,
    enabled = false,
  },

  {
    'EdenEast/nightfox.nvim',
    -- config = function()
    --   vim.cmd("colorscheme dayfox")
    -- end,
    enabled = true,
  },

  {
    'savq/melange',
    config = function()
      vim.o.termguicolors = true
      vim.o.background = 'light'
      vim.cmd 'colorscheme melange'
    end,
    enabled = false,
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
      vim.cmd 'colorscheme gruvbox-material'
    end,
  },

  {
    'RRethy/vim-illuminate',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>N', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', { noremap = true })
      -- vim.g.Illuminate_useDeprecated = 1
    end,
  },

  {
    'kosayoda/nvim-lightbulb',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require 'config.lightbulb'
    end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
  },

  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  {
    'jeetsukumaran/vim-indentwise',
    config = function()
      local map = require('utils').map
      map('v', '<leader>u', '<Plug>(IndentWisePreviousLesserIndent)')
      map('n', '<leader>u', '<Plug>(IndentWisePreviousLesserIndent)')
      map('v', '<leader>d', '<Plug>(IndentWiseNextLesserIndent)')
      map('n', '<leader>d', '<Plug>(IndentWiseNextLesserIndent)')
    end,
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
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup {
        plugins = {
          presets = {
            operators = false,
          },
        },
        disable = {
          -- disable a trigger for a certain context by returning true
          ---@type fun(ctx: { keys: string, mode: string, plugin?: string }):boolean?
          trigger = function(ctx)
            local disabled_keys_v = { 'j', 'k', '"' }
            local disabled_keys_n = { 'o', 'O', '"' }

            if ctx.mode == 'v' then
              return vim.tbl_contains(disabled_keys_v, ctx.keys)
            elseif ctx.mode == 'n' then
              return vim.tbl_contains(disabled_keys_n, ctx.keys)
            end
            return false
          end,
        },
      }
    end,
    enabled = false,
  },

  -- clipboard over ssh through tmux
  {
    'ojroques/nvim-osc52',
    config = function()
      require 'config.osc52'
    end,
    enabled = false,
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require 'config.toggleterm'
    end,
  },

  {
    'nat-418/boole.nvim',
    config = function()
      require('boole').setup {
        mappings = {
          increment = '<C-a>',
          decrement = '<C-x>',
        },
        allow_caps_additions = {
          { 'enable', 'disable' },
        },
      }
    end,
  },

  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    config = function()
      require('render-markdown').setup {
        enabled = false,
      }
    end,
  },

  'LunarVim/bigfile.nvim',

  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function()
      local notify = require 'notify'
      notify.setup { timeout = 2000 }
      vim.notify = notify
    end,
  },

  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
      local utils = require 'utils'
      local map, feedkeys = utils.map, utils.feedkeys

      require('dressing').setup {
        select = {
          telescope = require('telescope.themes').get_dropdown(),
        },
        input = {
          insert_only = false,
          default_prompt = ' ', -- Doesn't seem to work
        },
      }

      vim.api.nvim_create_augroup('Dressing', {})
      vim.api.nvim_create_autocmd('Filetype', {
        pattern = 'DressingInput',
        callback = function()
          local input = require 'dressing.input'

          if vim.g.grep_string_mode then
            -- Enter input window in select mode
            feedkeys('<Esc>V<C-g>', 'i')
          end
          map({ 'i', 's' }, '<C-j>', input.history_next, { buffer = true })
          map({ 's' }, '<C-k>', input.history_prev, { buffer = true })
          map({ 'i' }, '<C-a>', '<Home>', { buffer = true })
          map({ 'i' }, '<C-e>', '<End>', { buffer = true })
          map({ 'i' }, '<C-b>', '<Left>', { buffer = true })
          map({ 'i' }, '<C-f>', '<Right>', { buffer = true })
          map({ 'i' }, '<C-d>', '<Del>', { buffer = true })
          map({ 'i' }, '<C-k>', '<C-o>D', { buffer = true })
          map({ 's', 'n' }, '<C-c>', input.close, { buffer = true })
          map({ 's', 'n' }, '<C-o>', input.close, { buffer = true })
          map('s', '<CR>', input.confirm, { buffer = true })
        end,
        group = 'Dressing',
      })
    end,
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        cmdline = {
          view = 'cmdline',
          format = {
            cmdline = false,
            search_down = false,
            search_up = false,
            filter = false,
            help = false,
            lua = false,
          },
        },
        lsp = {
          signature = {
            enabled = false,
          },
        },
      }
    end,
  },

  -- plantUML preview for .uml
  'aklt/plantuml-syntax',
  'scrooloose/vim-slumlord',
}
