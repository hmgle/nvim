local telescope = require('telescope')
local actions = require('telescope.actions')
local u = require('utils')

local default_mappings = {
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
  n = {
    ['Q'] = actions.smart_add_to_qflist + actions.open_qflist,
    ['q'] = actions.smart_send_to_qflist + actions.open_qflist,
    ['<tab>'] = actions.toggle_selection + actions.move_selection_next,
    ['<s-tab>'] = actions.toggle_selection + actions.move_selection_previous,
    ['v'] = actions.file_vsplit,
    ['s'] = actions.file_split,
    ['<cr>'] = actions.file_edit,
  },
}

local opts_cursor = {
  initial_mode = 'normal',
  sorting_strategy = 'ascending', -- ascending | descending
  layout_strategy = 'cursor',
  results_title = false,
  layout_config = {
    width = 0.5,
    height = 0.4,
  },
}

local opts_vertical = {
  initial_mode = 'normal',
  sorting_strategy = 'ascending',
  layout_strategy = 'vertical',
  results_title = false,
  layout_config = {
    width = 0.5,
    height = 0.5,
    prompt_position = 'top',
    mirror = true,
  },
}

local opts_flex = {
  layout_strategy = 'flex',
  layout_config = {
    width = 0.7,
    height = 0.7,
    prompt_position = 'top',
  },
}

telescope.setup({
  defaults = {
    scroll_strategy = 'limit',
    prompt_prefix = '🔍 ',
    file_ignore_patterns = {
      '%.git/',
    },
    dynamic_preview_title = true,
    vimgrep_arguments = {
      'rg',
      '--ignore',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--trim',
    },
    prompt_position = 'top',
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
    default_mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-o>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-]>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
        ["<C-w>"] = { "<c-s-w>", type = "command" },
      },
      n = {
        ["<C-o>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-]>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        -- TODO: This would be weird if we switch the ordering.
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
  pickers = {
    buffers = u.merge(opts_flex, {
      prompt_title = '✨ Search Buffers ✨',
      mappings = u.merge({
        n = {
          ['d'] = actions.delete_buffer,
        },
      }, default_mappings),
      sort_mru = true,
      sort_lastused = true,
      preview_title = false,
    }),
    lsp_implementations = u.merge(opts_cursor, {
      prompt_title = 'Implementations',
      mappings = default_mappings,
    }),
    lsp_definitions = u.merge(opts_cursor, {
      prompt_title = 'Definitions',
      mappings = default_mappings,
    }),
    lsp_references = u.merge(opts_vertical, {
      prompt_title = 'References',
      mappings = default_mappings,
    }),
    find_files = u.merge(opts_flex, {
      prompt_title = '✨ Search Project ✨',
      mappings = default_mappings,
      hidden = true,
    }),
    diagnostics = u.merge(opts_vertical, {
      mappings = default_mappings,
    }),
    git_files = u.merge(opts_flex, {
      prompt_title = '✨ Search Git Project ✨',
      mappings = default_mappings,
      hidden = true,
    }),
    live_grep = u.merge(opts_flex, {
      prompt_title = '✨ Live Grep ✨',
      mappings = default_mappings,
    }),
    grep_string = u.merge(opts_vertical, {
      prompt_title = '✨ Grep String ✨',
      mappings = default_mappings,
    }),
    current_buffer_fuzzy_find = {
      mappings = default_mappings,
    },
  },
})

telescope.load_extension('fzf')


local map = require('utils').map
map('n', '<leader>fb', ':Telescope current_buffer_fuzzy_find<CR>')
map('n', '<leader>fl', ':Telescope live_grep<CR>')
map('n', '<C-p>', ':Telescope find_files<CR>')
map('n', '<leader>ff', ':Telescope find_files<CR>')
map('n', '<leader>ss', ':Telescope lsp_document_symbols<CR>')
map('n', '<leader>sS', ':Telescope lsp_dynamic_workspace_symbols<CR>')
map('n', '<C-w>d', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="split"})<CR>')
map('n', '<leader>*', ':Telescope grep_string<CR>')
map('n', '<leader>b', ':Telescope buffers<CR>')
