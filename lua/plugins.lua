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
    'aaronik/treewalker.nvim',
    opts = {
      highlight = true, -- default is false
    },
    keys = {
      {
        '<c-d>',
        mode = { 'n', 'v' },
        function()
          require('treewalker').move_down()
        end,
        desc = 'Treewalker move_down',
      },
      {
        '<c-u>',
        mode = { 'n', 'v' },
        function()
          require('treewalker').move_up()
        end,
        desc = 'Treewalker move_down',
      },
      {
        '<leader>h',
        mode = { 'n', 'v' },
        function()
          require('treewalker').move_out()
        end,
        desc = 'Treewalker move_out',
      },
      {
        '<leader>l',
        mode = { 'n', 'v' },
        function()
          require('treewalker').move_in()
        end,
        desc = 'Treewalker move_in',
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
    enabled = false,
    init = function()
      vim.g.Lf_ShortcutF = '<leader>fp'
      vim.g.Lf_UseCache = 0
      vim.g.Lf_PreviewInPopup = 0
      vim.g.Lf_HideHelp = 1
      vim.g.Lf_CommandMap = {
        ['<ESC>'] = { '<ESC>', '<C-O>' },
      }
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
    ft = { 'go', 'gomod' },
    event = { 'CmdlineEnter' },
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
    end,
    cond = function()
      -- too slow to load on startup for big files
      local max_file_size = 1024 * 100 -- 100KB
      local file_size = vim.fn.getfsize(vim.fn.expand '%:p')
      return file_size < max_file_size
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
  {
    'andymass/vim-matchup',
    event = 'BufRead',
    config = function()
      vim.cmd 'highlight OffscreenPopup guibg=#FF0000CC guifg=blue'
      vim.g.matchup_matchparen_offscreen = {
        method = 'popup',
        highlight = 'OffscreenPopup',
      }
    end,
  },

  -- autocompletion
  { -- gh copilot
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    build = ':Copilot auth',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
        },
        logger = {
          print_log = false,
        },
        copilot_model = 'gpt-4o-copilot', -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
      }
    end,
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = 'InsertEnter',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
  },

  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'giuxtaposition/blink-cmp-copilot',
    },

    version = '*',
    event = 'InsertEnter',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-h>'] = {
          function()
            local snippets = require('blink.cmp.config').snippets
            local feedkeys = require('utils').feedkeys
            if snippets.active { direction = -1 } then
              vim.schedule(function()
                snippets.jump(-1)
              end)
            else
              feedkeys '<Left>'
            end
          end,
        },
        ['<C-l>'] = {
          function()
            local snippets = require('blink.cmp.config').snippets
            local feedkeys = require('utils').feedkeys
            if snippets.active { direction = 1 } then
              vim.schedule(function()
                snippets.jump(1)
              end)
            else
              feedkeys '<Right>'
            end
          end,
        },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = false,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',

        kind_icons = {
          Copilot = '',
        },
      },

      sources = {
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            -- score_offset = -5,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Copilot'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
          },
        },
        default = { 'lsp', 'path', 'snippets', 'copilot', 'buffer' },
      },

      cmdline = {
        enabled = true,
        completion = {
          menu = { auto_show = true },
          list = {
            selection = { preselect = false },
          },
        },
      },

      completion = {
        accept = {
          -- Experimental auto-brackets support
          auto_brackets = {
            -- Whether to auto-insert brackets for functions
            enabled = true,
          },
        },

        menu = {
          max_height = 36,
          draw = {
            columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } },
            -- Use treesitter to highlight the label text
            -- treesitter = true,
          },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        -- Displays a preview of the selected item on the current line
        ghost_text = {
          enabled = true,
        },
      },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = {
      'sources.completion.enabled_providers',
      'sources.compat',
      'sources.default',
    },
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      require 'config.lspconf'
    end,

    dependencies = {
      { 'saghen/blink.cmp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      {
        'ray-x/lsp_signature.nvim',
        event = 'InsertEnter',
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
    { -- optional blink completion source for require statements and module annotations
      'saghen/blink.cmp',
      opts = {
        sources = {
          -- add lazydev to your completion providers
          default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
          providers = {
            -- dont show LuaLS require statements when lazydev has items
            lsp = { fallbacks = { 'lazydev' } },
            lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
          },
        },
      },
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
        'danielfalk/smart-open.nvim',
        branch = '0.2.x',
        enabled = vim.fn.has 'linux' ~= 1,
        config = function()
          require('telescope').setup {
            extensions = {
              smart_open = {
                cwd_only = true,
                filename_first = false,
              },
            },
          }
          -- require('telescope').load_extension 'smart_open'
        end,
        dependencies = {
          'kkharji/sqlite.lua',
          { 'nvim-telescope/telescope-fzy-native.nvim' },
        },
      },

      {
        'nvim-telescope/telescope-frecency.nvim',
        enabled = vim.fn.has 'linux' == 1,
        config = function()
          require('telescope').setup {
            extensions = {
              frecency = {
                -- https://github.com/nvim-telescope/telescope-frecency.nvim/issues/270
                db_safe_mode = false,
                matcher = 'fuzzy',
                show_scores = true,
                show_filter_column = false,
              },
            },
          }
          require('telescope').load_extension 'frecency'
        end,
      },

      'nvim-telescope/telescope-ui-select.nvim',
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
      vim.keymap.set('n', '<leader>n', function()
        require('illuminate').next_reference { wrap = true, silent = true }
      end)
      vim.keymap.set('n', '<leader>N', function()
        require('illuminate').next_reference { reverse = true, wrap = true, silent = true }
      end)
      -- vim.g.Illuminate_useDeprecated = 1
    end,
  },

  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require 'config.lightbulb'
    end,
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      vim.g.rainbow_delimiters = {
        whitelist = {
          'c',
          'go',
          'erlang',
          'javascript',
          'lua',
          'markdown',
          'python',
          'ruby',
          'rust',
          'zig',
        },
      }
    end,
  },

  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
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
        preset = 'helix',
        plugins = {
          presets = {
            operators = false,
          },
        },
      }
    end,
    enabled = true,
  },

  { 'meznaric/key-analyzer.nvim', opts = {} },

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
    enabled = true,
    config = function()
      require 'config.toggleterm'
    end,
  },

  {
    'rebelot/terminal.nvim',
    enabled = false,
    config = function()
      local terminal = require 'terminal'
      terminal.setup {
        layout = { open_cmd = 'float' },
      }
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'TermOpen' }, {
        callback = function(args)
          if vim.startswith(vim.api.nvim_buf_get_name(args.buf), 'term://') then
            vim.cmd 'startinsert'
          end
        end,
      })

      local active_terminals = require 'terminal.active_terminals'

      vim.keymap.set({ 'n', 't' }, '<c-s>', function()
        if active_terminals:len() > 0 then
          terminal.toggle()
        else
          local default_shell = vim.fn.getenv 'SHELL' or 'bash'
          terminal.run(default_shell)
        end
      end)

      vim.api.nvim_create_autocmd('TermOpen', {
        callback = function()
          local opts = { buffer = 0 }
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        end,
      })

      vim.api.nvim_create_autocmd('TermEnter', {
        callback = function()
          vim.o.background = 'dark'
        end,
      })

      vim.api.nvim_create_autocmd('TermLeave', {
        callback = function()
          vim.o.background = 'light'
          vim.cmd 'hi Search guibg=None guifg=#ff2222'
          vim.cmd 'hi CurSearch guibg=None guifg=#ff0000 gui=bold'
          vim.cmd 'hi HlSearchNear guibg=None guifg=#ff0000'
          vim.cmd 'hi HlSearchLens guibg=None guifg=#bbbbbb'
          vim.cmd 'hi HlSearchLensNear guibg=None guifg=#888888'
        end,
      })
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

  {
    'LunarVim/bigfile.nvim',
    config = function()
      require('bigfile').setup {
        filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
      }
    end,
  },

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
        messages = {
          view_search = false,
        },
        lsp = {
          signature = {
            enabled = false,
          },
        },
      }
    end,
  },

  {
    'rachartier/tiny-code-action.nvim',
    -- There is a bug after the version of 755208f：
    -- https://github.com/rachartier/tiny-code-action.nvim/issues/59
    -- Error: attempt to compare nil with number #59
    commit = 'dcb5dd2',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    event = 'LspAttach',
    config = function()
      require('tiny-code-action').setup {
        vim.keymap.set({ 'n', 'v', 'x' }, '<leader>ca', function()
          require('tiny-code-action').code_action()
        end, { noremap = true, silent = true }),
      }
    end,
  },

  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require 'grug-far'
          grug.open {
            engine = 'ripgrep',
          }
        end,
        mode = { 'n', 'v' },
        desc = 'Search and Replace(rg)',
      },
      {
        '<leader>sa',
        function()
          local grug = require 'grug-far'
          grug.open {
            engine = 'astgrep',
          }
        end,
        mode = { 'n', 'v' },
        desc = 'Search and Replace(ast-grep)',
      },
    },

    config = function()
      require('grug-far').setup {}
    end,
  },

  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        default_mappings = false,
        vim.keymap.set('n', 'gp', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true }),
        vim.keymap.set('n', 'gP', "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true }),
      }
    end,
  },

  {
    'yetone/avante.nvim',
    enabled = false,
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = 'deepseek',
      vendors = {
        deepseek = {
          __inherited_from = 'openai',
          api_key_name = 'DEEPSEEK_API_KEY',
          endpoint = 'https://api.deepseek.com',
          model = 'deepseek-coder',
          temperature = 0,
        },
      },
      -- add any opts here
    },
    keys = {
      {
        '<leader>v',
        mode = { 'n', 'x', 'v' },
        function()
          require('avante').toggle()
        end,
        desc = 'Avante.Toggle',
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      -- 'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },

  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'ollama',
        },
        inline = {
          adapter = 'ollama',
        },
      },
      adapters = {
        ollama = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'https://api.deepseek.com',
              api_key = os.getenv 'DEEPSEEK_API_KEY',
              chat_url = '/chat/completions', -- optional: default value, override if different
            },
          })
        end,
      },
    },
  },

  {
    'aweis89/aider.nvim',
    dependencies = {
      -- required for core functionality
      'akinsho/toggleterm.nvim',

      -- for fuzzy file `/add`ing functionality ("ibhagwan/fzf-lua" supported as well)
      'nvim-telescope/telescope.nvim',

      -- Optional, but great for diff viewing and after_update_hook integration
      'sindrets/diffview.nvim',

      -- Optional but will show aider spinner whenever active
      {
        'folke/snacks.nvim',
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ['<C-O>'] = { 'close', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
        keys = {
          {
            '<C-p>',
            function()
              Snacks.picker.smart {
                multi = { 'recent', 'files' },
                -- layout = 'telescope',
                format = 'file', -- use `file` format for all sources
                matcher = {
                  cwd_bonus = true, -- boost cwd matches
                  frecency = true, -- use frecency boosting
                  sort_empty = true, -- sort even when the filter is empty
                  fuzzy = true,
                  smartcase = true,
                },
                transform = 'unique_file',
                filter = { cwd = true },
              }
            end,
            desc = 'Smart Find Files',
          },
        },
      },

      -- Only if you care about using the /editor command
      'willothy/flatten.nvim',
    },
    event = 'VeryLazy',
    opts = {
      -- Auto trigger diffview after Aider's file changes
      after_update_hook = function()
        require('diffview').open { 'HEAD^' }
      end,
      model_picker_search = { '^deepseek/' },
    },

    telescope = {
      -- Runs `/add <files>` for selected entries (with multi-select supported)
      -- add = '<c-l>',
      -- Runs `/read-only <files>` for selected entries (with multi-select supported)
      read_only = '<c-o>',
      -- Runs `/drop`` <files> for selected entries (with multi-select supported)
      drop = '<c-d>',
    },
    -- config = function()
    --   require('aider').setup {}
    -- end,
    keys = {
      {
        '<leader>as',
        '<cmd>AiderSpawn<CR>',
        desc = 'Toggle Aidper (default)',
      },
      {
        '<leader>a<space>',
        '<cmd>AiderToggle<CR>',
        desc = 'Toggle Aider',
      },
      {
        '<leader>af',
        '<cmd>AiderToggle float<CR>',
        desc = 'Toggle Aider Float',
      },
      {
        '<leader>av',
        '<cmd>AiderToggle vertical<CR>',
        desc = 'Toggle Aider Float',
      },
      {
        '<leader>al',
        '<cmd>AiderAdd<CR>',
        desc = 'Add file to aider',
      },
      {
        '<leader>ad',
        '<cmd>AiderAsk<CR>',
        desc = 'Ask with selection',
        mode = { 'v', 'n' },
      },
      {
        '<leader>am',
        desc = 'Change model',
      },
      {
        '<leader>ams',
        '<cmd>AiderSend /model sonnet<CR>',
        desc = 'Switch to sonnet',
      },
      {
        '<leader>amh',
        '<cmd>AiderSend /model haiku<CR>',
        desc = 'Switch to haiku',
      },
      {
        '<leader>amg',
        '<cmd>AiderSend /model gemini/gemini-exp-1206<CR>',
        desc = 'Switch to haiku',
      },
      {
        '<C-x>',
        '<cmd>AiderToggle<CR>',
        desc = 'Toggle Aider',
        mode = { 'i', 't', 'n' },
      },
      -- Helpful mappings to utilize to manage aider changes
      {
        '<leader>ghh',
        '<cmd>Gitsigns change_base HEAD^<CR>',
        desc = 'Gitsigns pick reversals',
      },
      {
        '<leader>dvh',
        '<cmd>DiffviewOpen HEAD^<CR>',
        desc = 'Diffview HEAD^',
      },
      {
        '<leader>dvo',
        '<cmd>DiffviewOpen<CR>',
        desc = 'Diffview',
      },
      {
        '<leader>dvc',
        '<cmd>DiffviewClose!<CR>',
        desc = 'Diffview close',
      },
    },
  },

  {
    'robitx/gp.nvim',
    enabled = false,
    config = function()
      local conf = {
        providers = {
          openai = {
            endpoint = 'https://api.deepseek.com/chat/completions',
            secret = os.getenv 'DEEPSEEK_API_KEY',
          },
        },

        default_command_agent = 'deepseek',
        default_chat_agent = 'deepseek',
        agents = {
          {
            provider = 'openai',
            name = 'deepseek',
            chat = true,
            command = true,
            model = { model = 'deepseek-chat', temperature = 0, top_p = 0.2 },
            system_prompt = require('gp.defaults').chat_system_prompt,
            disable = false,
          },
        },
      }
      require('gp').setup(conf)
    end,
  },

  -- plantUML preview for .uml
  'aklt/plantuml-syntax',
  'scrooloose/vim-slumlord',
}
