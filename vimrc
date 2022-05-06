" other config files:
" syntax:
"     ~/.vim/ftplugin/latex.vim
"     ~/.vim/ftplugin/c.vim
" plugin:
"     ~/.vim/plugin/lsc.vim
"     ~/.vim/plugin/ale.vim
"     ~/.vim/plugin/textobj.vim
"     ~/.config/nvim/nvim-plugins.vim
"     ~/.vim/after/compiler/iar.vim
"     ~/.vim/after/compiler/visualstudio.vim


set nocompatible
syntax on
filetype indent on
filetype plugin on

" change language to english
language en_US.utf8

" symbols
set conceallevel=2

" highlight embeded languages
let g:vimsyn_embed = 'lp'

" Buffers
set hidden
" diffoff when a buffer becomes hidden
set diffopt+=hiddenoff

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

" grep word under cursor
nnoremap <leader>gr  :vimgrep "\<<C-R><C-W>\>" %:p:h/*

" More colors
set t_Co=256

" Change colorscheme
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif
colo pablo

set mouse=a
map <ScrollWheelUp> <C-Y>
map <S-ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-E>
map <S-ScrollWheelDown> <C-D>

" recolor split
hi VertSplit ctermfg=Black ctermbg=Black 

" remove split character
set fillchars=vert:\ 

" spaces instead of tabs
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab smartindent

" project specific config files
set secure
if filereadable(".vimlocal")
  silent source .vimlocal
endif
augroup vimlocal
  autocmd!
  autocmd BufEnter .vimlocal set filetype=vim
augroup END
set nosecure

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

" scroll horizontally 
nnoremap <C-L> 20zl20l
nnoremap <C-H> 20zh20h


" move based on character class
" normal
nnoremap <silent>\d :call search('\d', '', line('.'))<CR>
nnoremap <silent>\w :call search('\w', '', line('.'))<CR>
nnoremap <silent>\l :call search('\l', '', line('.'))<CR>
nnoremap <silent>\u :call search('\u', '', line('.'))<CR>
nnoremap <silent>\> :call search('\>', '', line('.'))<CR>
nnoremap <silent>\< :call search('\<', '', line('.'))<CR>
nnoremap <silent>\s :call search('\s', '', line('.'))<CR>
nnoremap <silent>\S :call search('\S', '', line('.'))<CR>
" operator
onoremap <silent>\d :call search('\d', '', line('.'))<CR>
onoremap <silent>\w :call search('\w', '', line('.'))<CR>
onoremap <silent>\l :call search('\l', '', line('.'))<CR>
onoremap <silent>\u :call search('\u', '', line('.'))<CR>
onoremap <silent>\> :call search('\>', '', line('.'))<CR>
onoremap <silent>\< :call search('\<', '', line('.'))<CR>
onoremap <silent>\s :call search('\s', '', line('.'))<CR>
onoremap <silent>\S :call search('\S', '', line('.'))<CR>
" backwards
nnoremap <silent>g\d :call search('\d', 'b', line('.'))<CR>
nnoremap <silent>g\w :call search('\w', 'b', line('.'))<CR>
nnoremap <silent>g\l :call search('\l', 'b', line('.'))<CR>
nnoremap <silent>g\u :call search('\u', 'b', line('.'))<CR>
nnoremap <silent>g\> :call search('\>', 'b', line('.'))<CR>
nnoremap <silent>g\< :call search('\<', 'b', line('.'))<CR>
nnoremap <silent>g\s :call search('\s', 'b', line('.'))<CR>
nnoremap <silent>g\S :call search('\S', 'b', line('.'))<CR>
" operator backwards
onoremap <silent>g\d :call search('\d', 'b', line('.'))<CR>
onoremap <silent>g\w :call search('\w', 'b', line('.'))<CR>
onoremap <silent>g\l :call search('\l', 'b', line('.'))<CR>
onoremap <silent>g\u :call search('\u', 'b', line('.'))<CR>
onoremap <silent>g\> :call search('\>', 'b', line('.'))<CR>
onoremap <silent>g\< :call search('\<', 'b', line('.'))<CR>
onoremap <silent>g\s :call search('\s', 'b', line('.'))<CR>
onoremap <silent>g\S :call search('\S', 'b', line('.'))<CR>

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

augroup c
  autocmd!
  autocmd FileType c   call CFiles()
  autocmd FileType cpp call CFiles()
augroup END

function! CFiles()
  nnoremap <buffer> <silent> ]h :call ToggleHeaderFile()<CR>
  nnoremap <buffer> <silent> ]H :call ToggleHeaderSearch()<CR>
endfunction

function! ToggleHeaderSearch()
  let word = expand('<cword>')
  let toggled = ToggleHeaderFile()
  if toggled 
    call feedkeys("/\\<" . word . "\\>\<CR>")
  endif
endfunction

function! ToggleHeaderFile()
  let ext = expand('%:e')
  let fname = expand('%:r')
  if ext == 'h'
    if filereadable(fname . ".cpp")
      execute "edit " . fname . ".cpp"
      return 1
    elseif filereadable(fname . ".c")
      execute "edit " . fname . ".c"
      return 1
    endif 
  elseif ext == 'c' || ext == 'cpp'
    if filereadable(fname . ".h")
      execute "edit " . fname . ".h"
      return 1
    endif
  endif
  return 0
endfunction

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
      autocmd BufWritePost <buffer> call MakeTags()
    endif
  augroup END
endfunction

function MakeTags()
  silent exec "Spawn! ctags -R " . getcwd()
endfunction

" view as pdf
command AsPdf silent exec "Start! zathura %:r.pdf"

" copy as rich text via pandoc
" https://unix.stackexchange.com/questions/84951/copy-markdown-input-to-the-clipboard-as-rich-text
command -range=% PandocCopy execute "<line1>,<line2>w !pandoc -f " . PandocSyntax(&syntax) . " | xclip -t text/html -selection clipboard"
command PandocPaste execute "r !xclip -o -t text/html -selection clipboard | pandoc -f html -t " . PandocSyntax(&syntax)

function! PandocSyntax(format)
  let pandocFormats = { "markdown": "gfm-raw_html", "plaintex": "latex", "tex": "latex", "txt": "plain" }
  return get(pandocFormats, a:format, a:format)
endfunction

command -range Dictate execute "<line1>,<line2>w !pandoc -f " . PandocSyntax(&syntax) . " -t plain | festival --tts"

command -nargs=? SvnDiff call SvnDiff("<args>")

function! SvnDiff(revision)
  let origname = expand('%')
  let origft = &filetype
  let diffname = tempname()
  let revisionarg = ""
  if a:revision
    let revisionarg = '-r ' . a:revision
  endif
  let basecontent = system('svn cat ' . origname . ' ' . revisionarg)
  call writefile(split(basecontent, '\n'), diffname)
  execute 'e ' . diffname
  let &filetype = origft
  execute 'vert diffsplit ' . origname
endfunction

autocmd FileType txt,markdown,md,tex,latex setlocal linebreak

" symbols
set conceallevel=2

" extra syntax highligting
autocmd BufNewFile,BufRead .xmobarrc set syntax=haskell

" open external programs (like urls)
let g:netrw_browsex_viewer= "xdg-open"

" close netrw buffer after selecting file
let g:netrw_fastbrowse = 0
autocmd FileType netrw setl bufhidden=wipe

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
    map <leader>sa <Plug>(operator-sandwich-add)
    map <leader>sd <Plug>(operator-sandwich-delete)<Plug>(textobj-sandwich-query-a)
    map <leader>sr <Plug>(operator-sandwich-replace)<Plug>(textobj-sandwich-query-a)
    vmap <leader>sa <Plug>(operator-sandwich-add)
    vmap <leader>sd <Plug>(operator-sandwich-delete)
    vmap <leader>sr <Plug>(operator-sandwich-replace)
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
    " Plug 'SirVer/ultisnips'
    let g:UltiSnipsExpandTrigger="<c-e>"
    let g:UltiSnipsJumpForwardTrigger="<c-z>"
    let g:UltiSnipsJumpBackwardTrigger="<c-a>"
    " My plugin for document outline / table of contents
    Plug 'david-pikas/toc.vim'
    " Moving by indentation level
    Plug 'jeetsukumaran/vim-indentwise'
    " Diffing sections of text
    Plug 'AndrewRadev/linediff.vim'

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
    " subversion
    " Plug 'juneedahamed/svnj.vim'
    Plug 'fourjay/vim-vcscommand'
    " file explorer
    Plug 'tpope/vim-vinegar'
    " visual studdio
    Plug 'heaths/vim-msbuild'

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
    " Emmet (for HTML)
    Plug 'mattn/emmet-vim'
    let g:user_emmet_mode = 'iv'
    nnoremap   <leader><C-y>u   <plug>(emmet-update-tag)
    nnoremap   <leader><C-y>d   <plug>(emmet-balance-tag-inward)
    nnoremap   <leader><C-y>D   <plug>(emmet-balance-tag-outward)
    nnoremap   <leader><C-y>n   <plug>(emmet-move-next)
    nnoremap   <leader><C-y>N   <plug>(emmet-move-prev)


    "## NVIM SPECIFIC ##"
    if has('nvim')
        source ~/.config/nvim/nvim-plugins.vim
    endif

call plug#end()

" needs to be at the end of the file for some reason
" menu color
hi Pmenu ctermbg=lightblue guibg=lightblue
