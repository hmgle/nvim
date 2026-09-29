set whichwrap+=<,>,h,l
set ignorecase "Ignore case when searching
set smartcase

set so=2

set guicursor=i:block

set ffs=unix,dos,mac "Default file types

" set expandtab
set noexpandtab
set shiftwidth=8
set tabstop=8
set smarttab
set textwidth=500
set smartindent
set splitright

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-B> <Left>
cnoremap <C-F> <right>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
" <C-d>: delete char.
cnoremap <C-d> <Del>
" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>

nnoremap <silent> <leader><cr> <Cmd>nohlsearch<CR>
xnoremap <silent> <leader><cr> <Cmd>nohlsearch<CR>

" Smart way to move btw. windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
xnoremap <C-j> <C-W>j
xnoremap <C-k> <C-W>k
xnoremap <C-h> <C-W>h
xnoremap <C-l> <C-W>l

au FileType c,cpp,python,markdown,mkd,asciidoc,go,erlang,lua set colorcolumn=81

" https://www.reddit.com/r/neovim/comments/olp9lr/elegant_map_for_togglequikfixlist/
nnoremap <silent><expr> <leader>q "<cmd>".(get(getqflist({"winid": 1}), "winid") != 0? "cclose" : "botright copen")."<cr>"


inoremap <C-d> <C-R>=strftime("%Y-%m-%d")<CR>

if exists('$TMUX')
    au VimResized * wincmd =
endif


let g:Lf_PopupPalette = {
\    'light': {
\       'Lf_hl_cursorline': {
\               'gui': 'bold',
\               'guifg': 'NONE',
\               'guibg': '#d4ede8',
\               'cterm': 'NONE',
\               'ctermfg': '7',
\               'ctermbg': '1'
\       }
\    }
\}

let g:Lf_NormalCommandMap = {
            \ "*":      {
            \               "<C-Down>": "<C-J>",
            \               "<C-Up>":   "<C-K>",
            \               "<Esc>": "<C-O>",
            \           },
            \ "File":   {
            \               "q":     "<Esc>",
            \               "a":     "<C-A>",
            \           },
            \ "Buffer": {},
            \ "Mru":    {},
            \ "Tag":    {},
            \ "BufTag": {},
            \ "Function": {},
            \ "Line":   {},
            \ "History":{},
            \ "Help":   {},
            \ "Rg":     {},
            \ "Gtags":  {},
            \ "Colorscheme": {}
            \}
