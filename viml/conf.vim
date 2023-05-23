let mapleader = ","
let g:mapleader = ","

set whichwrap+=<,>,h,l
set ignorecase "Ignore case when searching
set smartcase

set tm=500
set so=2

set guicursor=i:block


try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types

" set expandtab
set noexpandtab
set shiftwidth=8
set tabstop=8
set smarttab
set textwidth=500
set smartindent


" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-B> <Left>
cnoremap <C-F> <right>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
" <C-d>: delete char.
cnoremap <C-d> <Del>
" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>

map <silent> <leader><cr> :noh<cr>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

au FileType c,cpp,python,markdown,mkd,asciidoc,go,erlang,lua set colorcolumn=81

" https://www.reddit.com/r/neovim/comments/olp9lr/elegant_map_for_togglequikfixlist/
nnoremap <silent><expr> <leader>q "<cmd>".(get(getqflist({"winid": 1}), "winid") != 0? "cclose" : "botright copen")."<cr>"


nnoremap <C-d> "=strftime("%Y-%m-%d")<CR>P
inoremap <C-d> <C-R>=strftime("%Y-%m-%d")<CR>

if exists('$TMUX')
    au VimResized * wincmd =
endif


function! s:gruvbox_material_custom() abort
    hi Search guibg=None guifg=#ff2222
    hi CurSearch guibg=None guifg=#ff0000 gui=bold
endfunction

augroup GruvboxMaterialCustom
    autocmd!
    autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END
