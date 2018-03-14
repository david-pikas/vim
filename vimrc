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

" fuzzy file finder
set rtp+=~/.fzf

" case insensitve q/w/wq
command! WQ wq
command! Wq wq
command! W w
command! Q q

" swap
:nnoremap <silent> öc xph
:nnoremap <silent> öw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>
:nnoremap <silent> öö ddpk
:nnoremap <silent> öj ddp
:nnoremap <silent> ök ddkkp

" pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

" Plug
call plug#begin('~/.vim/plugged')

    " Code Break Game
    Plug 'johngrib/vim-game-code-break'


call plug#end()



" syntastic (error highlighting)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" spell check
autocmd FileType markdown,md,tex,latex setlocal spell

" symbols
set conceallevel=2

" vimtex
let g:vimtex_view_method='mupdf'

" Search with ddg
let g:vim_g_query_url='https://duckduckgo.com/?q='

" vimslime with tmux
let g:slime_target = "tmux"

" Buffers
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" recolor tabline
hi TabLineFill guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi TabLine guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

" recolor split
hi VertSplit ctermfg=Black ctermbg=Black 

" remove split character
set fillchars=vert:\ 

" line numbers
set nu

