set nocompatible
syntax on
filetype indent on
filetype plugin on

" symbols
set conceallevel=2

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
set number

let mapleader = ' '

" switch between buffers
nnoremap <leader>b :ls<cr>:b<space>

" More colors
set t_Co=256

" Change colorscheme
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif
colo elflord

" recolor split
hi VertSplit ctermfg=Black ctermbg=Black 

" remove split character
set fillchars=vert:\ 

" spaces instead of tabs
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab smartindent

" case insensitve q/w/wq/wqa
command! -bang WQ wq<bang>
command! -bang Wq wq<bang>
command! -bang W w<bang>
command! -bang Q q<bang>
command! -bang Wqa wqa<bang>
command! -bang WQa wqa<bang>
command! -bang WQA wqa<bang>

" Y
nnoremap <silent> Y y$

" change language
nnoremap <leader>l :set spelllang=

nnoremap <silent> <leader>o :lopen<CR>


" spell check
augroup spellgroup
    autocmd!
    autocmd FileType txt,markdown,md,tex,latex setlocal spell
augroup END

" auto detect language latex
let s:vim_lang = {'swedish':'sv', 'english':'en'}
let &l:include = '\v\\%(%(input|include|subfile)\{|documentclass\[)\zs\f+\ze%(\}|\]\{subfiles\})'
function! BabelSpellLang()
  let s:babel=''
  redir => s:babel
    try
      silent isearch /^\s*\\usepackage\s*\[[^\]]\+\]{babel}/
    catch /Couldn't find pattern/
      return
    endtry
  redir END
  let s:babel_lang = matchstr(s:babel, 'usepackage\s*\[\zs[^\]]\+\ze\]')
  let s:babel_lang = split(s:babel_lang, '\s*,\s*')
  let s:babel_lang = filter(s:babel_lang, "has_key(s:vim_lang, v:val)")
  let s:spelllang = map(s:babel_lang, "get(s:vim_lang, v:val, '')")
  let &l:spelllang = join(s:spelllang, ',')
endfunc

augroup latex
  autocmd!
  " auto detect language
  autocmd FileType tex,latex silent call BabelSpellLang()
  " pdflatex as make
  autocmd FileType tex,latex 
    \ setlocal makeprg=pdflatex\ -file-line-error\ -interaction=nonstopmode\ % |
    \ setlocal errorformat=%f:%l:\ %m
augroup END

augroup md
  autocmd!
  " pandoc as make
  autocmd FileType markdown
    \ setlocal makeprg=pandoc\ %\ -t\ latex\ -o\ %:r.pdf |
    \ setlocal errorformat=\"%f\",\ line\ %l:\ %m
augroup END

" continous compilation
" bang turns it of again
command -bang AutoMake call ToggleAutoMake(<bang>0)
function ToggleAutoMake(bang)
  augroup automake
    autocmd! * 
    if a:bang == 0
      autocmd BufWritePost <buffer> Make!
    endif
  augroup END
endfunction
" command NoAutoMake augroup aumk | au! | augroup END

" view as pdf
command AsPdf silent exec "Start! zathura %:r.pdf"

" copy as rich text via pandoc
" https://unix.stackexchange.com/questions/84951/copy-markdown-input-to-the-clipboard-as-rich-text
command -range=% PandocCopy <line1>,<line2>w !pandoc %:t | xclip -t text/html -selection clipboard 


" soft wordwrap
autocmd FileType txt,markdown,md,tex,latex setlocal linebreak

" symbols
set conceallevel=2

" extra syntax highligting
autocmd BufNewFile,BufRead .xmobarrc set syntax=haskell

" plugins
call plug#begin('~/.vim/plugged')

    "## MOTIONS and INTERACTIONS ##"
    " comments
    Plug 'tpope/vim-commentary'
    " alignment
    Plug 'tommcdo/vim-lion'
    " surround
    Plug 'machakann/vim-sandwich'
    let g:operator_sandwich_no_default_key_mappings = 1
    map gsa <Plug>(operator-sandwich-add)
    vmap gsd <Plug>(operator-sandwich-delete)
    vmap gsr <Plug>(operator-sandwich-replace)
    " swap
    Plug 'tommcdo/vim-exchange'
    " text objects
    Plug 'wellle/targets.vim'
    " custom text object (dependency of vim-textobj-syntax)
    " (see ~/.vim/plugin/textobj.vim)
    Plug 'kana/vim-textobj-user'
    " syntax text object
    Plug 'kana/vim-textobj-syntax'
    " latex text objects
    Plug 'rbonvall/vim-textobj-latex'
    " replacing text
    Plug 'tpope/vim-abolish'
    " motion
    Plug 'easymotion/vim-easymotion'
    " two character f
    Plug 'roy2220/easyjump.tmux'
    " highlight f/F/t/T
    Plug 'unblevable/quick-scope'
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
    " snippets
    Plug 'SirVer/ultisnips'
    let g:UltiSnipsExpandTrigger="<c-e>"
    let g:UltiSnipsJumpForwardTrigger="<c-z>"
    let g:UltiSnipsJumpBackwardTrigger="<c-a>"

    "## OUTSIDE INTEGRATION ##"
    " unix helpers
    Plug 'tpope/vim-eunuch'
    " make sure focus events work in tmux
    Plug 'tmux-plugins/vim-tmux-focus-events'
    " tmux autocomplete 
    Plug 'wellle/tmux-complete.vim'
    " run things in tmux instead of blocking vim
    Plug 'tpope/vim-dispatch'
    " fzf (fuzzy file finding)
    Plug 'junegunn/fzf', { 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
    " readline keybindings for command-line mode
    Plug 'ryvnf/readline.vim'
    " git stuff
    Plug 'tpope/vim-fugitive'
    " file explorer
    Plug 'tpope/vim-vinegar'

    "## LANGUAGES AND SYNTAX ##"
    " indent
    Plug 'tpope/vim-sleuth'
    " linting
    " (see ~/.vim/plugin/ale.vim)
    Plug 'dense-analysis/ale'
    " LSP
    " (see ~/.vim/plugin/lsc.vim)
    Plug 'natebosch/vim-lsc'
    " elm
    Plug 'andys8/vim-elm-syntax'
    " spell check
    Plug 'rhysd/vim-grammarous'
    "" Plug 'dpelle/vim-LanguageTool'
    "let g:languagetool_cmd='/usr/bin/languagetool'
    " react
    Plug 'peitalin/vim-jsx-typescript'
    " latex syntax highligting
    Plug 'gi1242/vim-tex-syntax'
    " typescript
    Plug 'leafgarland/typescript-vim'
    " dafny
    Plug 'mlr-msft/vim-loves-dafny'

call plug#end()
