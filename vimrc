" other config files:
" syntax:
"     ~/.vim/ftplugin/latex.vim
" plugin:
"     ~/.vim/plugin/lsc.vim
"     ~/.vim/plugin/ale.vim
"     ~/.vim/plugin/textobj.vim
"     ~/.config/nvim/nvim-plugins.vim


set nocompatible
syntax on
filetype indent on
filetype plugin on

" symbols
set conceallevel=2

" highlight embeded languages
let g:vimsyn_embed = 'lp'

" Buffers
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" search settings
set incsearch
set hlsearch
nnoremap <silent> <Esc> :nohlsearch<CR>

" recolor tabline
hi TabLineFill guifg=Black ctermfg=Black guibg=Black ctermbg=Black
hi TabLine guifg=NONE ctermfg=DarkGrey guibg=NONE ctermbg=Black gui=NONE cterm=NONE
hi Tabline guifg=NONE ctermfg=LightGrey guibg=NONE ctermbg=Grey

" recolor split
hi VertSplit ctermfg=Black ctermbg=Black 

" remove split character
set fillchars=vert:\ 

" recolor gutter
highlight clear SignColumn 
set signcolumn=number
augroup myGitGutter
  autocmd!
  autocmd ColorScheme *
    \ highlight GitGutterAdd ctermfg=Green     |
    \ highlight GitGutterChange ctermfg=Yellow |
    \ highlight GitGutterDelete ctermfg=Red
augroup END


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
colo pablo

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

" select pasted content
nnoremap gp `[v`]


" spell check
augroup spellgroup
    autocmd!
    autocmd FileType txt,markdown,md,tex,latex setlocal spell
augroup END

augroup md
  autocmd!
  " pandoc as make
  autocmd FileType markdown
    \ setlocal makeprg=pandoc\ %\ -t\ latex\ -o\ %:r.pdf |
    \ setlocal errorformat=\"%f\",\ line\ %l:\ %m
augroup END

augroup rust
  autocmd!
  autocmd FileType rust
    \ setlocal makeprg=cargo\ check |
    \ setlocal errorformat=%.%#-->\ %f:%l:%c |
    \ setlocal errorformat+=%.%#-->\ %f\|%l\ col\ %c\\
augroup END

augroup haskell
  autocmd!
  autocmd FileType haskell
    \ compiler stack |
    \ setlocal makeprg=stack\ build
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

" auto tags
command -bang AutoTags call ToggleAutoTags(<bang>0)

function ToggleAutoTags(bang)
  augroup autotags
    autocmd! * 
    if a:bang == 0
      autocmd BufWritePost <buffer> silent exec "Spawn! ctags %:h/*"
    endif
  augroup END
endfunction

" view as pdf
command AsPdf silent exec "Start! zathura %:r.pdf"

" copy as rich text via pandoc
" https://unix.stackexchange.com/questions/84951/copy-markdown-input-to-the-clipboard-as-rich-text
command -range=% PandocCopy execute "<line1>,<line2>w !pandoc -f " . PandocSyntax(&syntax) . " | xclip -t text/html -selection clipboard"
command PandocPaste execute "r !xclip -o -t text/html -selection clipboard | pandoc -f html -t " . PandocSyntax(&syntax)

function! PandocSyntax(format)
  let pandocFormats = { "markdown": "gfm", "plaintex": "latex", "tex": "latex", "txt": "plain" }
  return get(pandocFormats, a:format, a:format)
endfunction

command -range Dictate execute "<line1>,<line2>w !pandoc -f " . PandocSyntax(&syntax) . " -t plain | festival --tts"

" soft wordwrap
autocmd FileType txt,markdown,md,tex,latex setlocal linebreak

" symbols
set conceallevel=2

" extra syntax highligting
autocmd BufNewFile,BufRead .xmobarrc set syntax=haskell

" open external programs (like urls)
let g:netrw_browsex_viewer= "xdg-open"

" close netrw buffer after selecting file
let g:netrw_fastbrowse = 0

" plugins
" install with
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
    " [] mappings
    Plug 'tpope/vim-unimpaired'
    "" highlight f/F/t/T
    "Plug 'unblevable/quick-scope'
    "let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
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
    Plug 'tpope/vim-rhubarb'
    Plug 'airblade/vim-gitgutter'
    let g:gitgutter_set_sign_backgrounds = 0
    " file explorer
    Plug 'tpope/vim-vinegar'

    "## LANGUAGES AND SYNTAX ##"
    " indent
    Plug 'tpope/vim-sleuth'
    " linting
    " (see ~/.vim/plugin/ale.vim)
    Plug 'dense-analysis/ale'
    " LSP (vim only)
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
    " OpenGL
    Plug 'bfrg/vim-opengl-syntax'
    " Shaders
    Plug 'tikhomirov/vim-glsl'
    " TOML
    Plug 'cespare/vim-toml'

    "## NVIM SPECIFIC ##"
    if has('nvim')
        source ~/.config/nvim/nvim-plugins.vim
    endif

call plug#end()
