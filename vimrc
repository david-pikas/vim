" nocompatible
set nocompatible
syntax on
filetype on
filetype indent on
filetype plugin on

" symbols
set conceallevel=2

" vimtex
let g:vimtex_view_method='mupdf'

" Search with ddg
let g:vim_g_query_url='https://duckduckgo.com/?q='


" Buffers
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" recolor tabline
hi TabLineFill guifg=Black ctermfg=Black guibg=Black ctermbg=Black
hi TabLine guifg=NONE ctermfg=DarkGrey guibg=NONE ctermbg=Black gui=NONE cterm=NONE
hi Tabline guifg=NONE ctermfg=LightGrey guibg=NONE ctermbg=Grey

" recolor split
hi VertSplit ctermfg=Black ctermbg=Black 

" remove split character
set fillchars=vert:\ 

" line numbers
set nu

let mapleader = ' '

" switch between buffers
nnoremap <leader>b :ls<cr>:b<space>

" More colors
set t_Co=256

" Change colorscheme
colo elflord

" recolor split
hi VertSplit ctermfg=Black ctermbg=Black 

" remove split character
set fillchars=vert:\ 

" spaces instead of tabs
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab smartindent

" case insensitve q/w/wq
command! WQ wq
command! Wq wq
command! W w
command! Q q

" swap
nnoremap <silent> öc xph
nnoremap <silent> öw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>
nnoremap <silent> öö ddpk
nnoremap <silent> öj ddp
nnoremap <silent> ök ddkkp

" Y
nnoremap <silent> Y y$

" more print commands 
nnoremap <silent> gop op
nnoremap <silent> gOp Op
nnoremap <silent> gpp $p
nnoremap gcp :set opfunc=ReplacePrint<CR>g@
vnoremap <silent> gcp :<C-U>call ReplacePrint(visualmode(), 1)<CR>

function! ReplacePrint(type, ...)
    if a:0
        silent exe "normal! `<\"_d`>\"_xp"
    else
        silent exe "normal! `[\"_d`]\"_xp"
    endif
endfunction



" comments
let g:NERDSpaceDelims = 1

" spell check
autocmd FileType markdown,md,tex,latex setlocal spell

" symbols
set conceallevel=2

