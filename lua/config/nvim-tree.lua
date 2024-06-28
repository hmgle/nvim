local nvim_tree, api = require('nvim-tree'), require('nvim-tree.api')
local node, tree, fs, marks = api.node, api.tree, api.fs, api.marks

nvim_tree.setup({
  diagnostics = {
    enable = true,
    show_on_dirs = true
  },
  update_cwd = true,
  git = {
    ignore = false,
  },
  renderer = {
    highlight_opened_files = 'all',
    special_files = {},
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        file = false,
        git = false,
        diagnostics = false,
      },
      git_placement = 'signcolumn',
    }
  },
  view = {
    width = 26,
  },

  on_attach = function(bufnr)
    local map = function(lhs, rhs, desc)
      require('utils').map('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Custom mappings
    map('o',     node.open.edit,                    'Open')
    map('<CR>',  node.open.edit,                    'Open')
    map('l',     tree.change_root_to_node,          'CD')
    map('h',     tree.change_root_to_parent,        'CD up')
    map('d',     fs.trash,                          'Trash')
    map('D',     fs.remove,                         'Delete')

    -- Recommended defaults
    map('<C-t>', node.open.tab,                  'Open: New Tab')
    map('<C-v>', node.open.vertical,             'Open: Vertical Split')
    map('.',     node.run.cmd,                   'Run Command')
    map(']e',    node.navigate.diagnostics.next, 'Next Diagnostic')
    map('[e',    node.navigate.diagnostics.prev, 'Prev Diagnostic')
    map('J',     node.navigate.sibling.last,     'Last Sibling')
    map('K',     node.navigate.sibling.first,    'First Sibling')
    map('P',     node.navigate.parent,           'Parent Directory')
    map('s',     node.run.system,                'Run System')
    map('B',     tree.toggle_no_buffer_filter,   'Toggle No Buffer')
    map('C',     tree.toggle_git_clean_filter,   'Toggle Git Clean')
    map('H',     tree.toggle_hidden_filter,      'Toggle Dotfiles')
    map('I',     tree.toggle_gitignore_filter,   'Toggle Git Ignore')
    map('S',     tree.search_node,               'Search')
    map('U',     tree.toggle_custom_filter,      'Toggle Hidden')
    map('g?',    tree.toggle_help,               'Help')
    map('W',     tree.collapse_all,              'Collapse')
    map('F',     api.live_filter.clear,          'Clean Filter')
    map('f',     api.live_filter.start,          'Filter')
    map('m',     marks.toggle,                   'Toggle Bookmark')
    map('bmv',   marks.bulk.move,                'Move Bookmarked')
    map('a',     fs.create,                      'Create')
    map('c',     fs.copy.node,                   'Copy')
    map('gy',    fs.copy.absolute_path,          'Copy Absolute Path')
    map('p',     fs.paste,                       'Paste')
    map('r',     fs.rename,                      'Rename')
    map('x',     fs.cut,                         'Cut')
    map('y',     fs.copy.filename,               'Copy Name')
    map('Y',     fs.copy.relative_path,          'Copy Relative Path')

    map('<2-LeftMouse>',  api.node.open.edit,       'Open')
    map('<2-RightMouse>', tree.change_root_to_node, 'CD')
  end,
})

-- Make :bd and :q behave as usual when tree is visible
vim.api.nvim_create_autocmd({'BufEnter', 'QuitPre'}, {
  nested = false,
  callback = function(e)
    -- Nothing to do if tree is not opened
    if not tree.is_visible() then
      return
    end

    -- How many focusable windows do we have? (excluding e.g. incline status window)
    local winCount = 0
    for _,winId in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winId).focusable then
        winCount = winCount + 1
      end
    end

    -- We want to quit and only one window besides tree is left
    if e.event == 'QuitPre' and winCount == 2 then
      vim.api.nvim_cmd({cmd = 'qall'}, {})
    end

    -- :bd was probably issued an only tree window is left
    -- Behave as if tree was closed (see `:h :bd`)
    if e.event == 'BufEnter' and winCount == 1 then
      -- Required to avoid "Vim:E444: Cannot close last window"
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last buffer used before closing
        tree.toggle({find_file = true, focus = true})
        -- re-open nivm-tree
        tree.toggle({find_file = true, focus = false})
      end, 10)
    end
  end
})

local map = require('utils').map
map('n', '<leader>tt', ':NvimTreeToggle<CR>')
