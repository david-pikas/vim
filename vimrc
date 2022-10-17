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

" true colors
set termguicolors

" change language to english
language en_US.utf8

" symbols
set conceallevel=2

" trailing whitespace
set list
set listchars=trail:·,tab:» 

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

" 'fuzzy' finding with :find
set path+=**

" ^N from includes and tags
set complete+=i
set complete+=t

" recolor tabline
hi TabLineFill guifg=Black ctermfg=Black guibg=Black ctermbg=Black
hi TabLine guifg=NONE ctermfg=DarkGrey guibg=NONE ctermbg=Black gui=NONE cterm=NONE
hi Tabline guifg=NONE ctermfg=LightGrey guibg=NONE ctermbg=Grey

" recolor split
hi VertSplit ctermfg=Black ctermbg=Black 

" remove split character
set fillchars=vert:\ 

" recolor gutter
set signcolumn=number
augroup myGitGutter
  autocmd!
  autocmd ColorScheme *
    \ highlight clear SignColumn |
    \ highlight GitGutterAdd ctermfg=Green     |
    \ highlight GitGutterChange ctermfg=Yellow |
    \ highlight GitGutterDelete ctermfg=Red
augroup END

" line numbers
set number

let mapleader = ' '

" complete buffer based on how recently they where used
set wildmode=lastused
" switch between buffers
nnoremap <leader>b :ls<cr>:b<space>
" switch in arglst
nnoremap <leader>a :args<cr>:argument<space>

" open windows in a more normal wa
set splitbelow
set splitright

" grep word under cursor
nnoremap <leader>gr :vimgrep "\<<C-R><C-W>\>" %:p:h/*

" expand block
inoremap {<Tab> {<CR><CR>}kcc

" More colors
set t_Co=256


" use mouse
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

" Cowerker friendly options
nnoremap <F5>  :Make<cr>
nnoremap <F12> <C-]>
nnoremap <F11> :Step<cr>
nnoremap <F10> :Over<cr>

command! -bang CoworkerMode call CoworkerMode(<bang>1)
" expanded upon in nvim/init.vim
function CoworkerMode(enable)
  if a:enable
    set selectmode=mouse
    let g:smoothie_enabled=1
  else
    let g:smoothie_enabled=0
    set selectmode=
  endif
endfunction

" Y
nnoremap <silent> Y y$

" change language
nnoremap <leader>l :setlocal spell spelllang=

nnoremap <silent> <leader>o :lopen<CR>

" select pasted content
nnoremap gp `[v`]

" scroll horizontally 
nnoremap <C-L> 20zl20l
nnoremap <C-H> 20zh20h

" use \<regex char group> to move to that group e.g. \d to move to next digit
for regex in ['d','w','l','u','<','>','s','S'] 
  " normal
  execute "nnoremap <silent>\\".regex." :call search('\\".regex."', '', line('.'))<CR>"
  " operator
  execute "onoremap <silent>\\".regex." :call search('\\".regex."', '', line('.'))<CR>"
  " backwards
  execute "nnoremap <silent>g\\".regex." :call search('\\".regex."', 'b', line('.'))<CR>"
  " backwards operator
  execute "onoremap <silent>g\\".regex." :call search('\\".regex."', 'b', line('.'))<CR>"
endfor

" use ripgrep for :grep
if executable('vimrg')
  " windows doesn't handle globs inside vim properly
  " so instead we use a script that calls rg from fd
  " if available
  set grepprg=vimrg
elseif executable('rg')
  set grepprg=rg
endif

" use M-i M-o to jump to next/prev file in jumplist
function PrevJumpFile(up)
    let old_lazy_redraw = &lazyredraw
    let &lazyredraw = 1
    let current_buffer = bufnr()

    " Get the jump list and parse the position of the first jump in the list
    " if the number is zero then we reached the top
    let [jumps, curr] = getjumplist()
    let jump_range = []
    if a:up
      " curr can sometimes be == len(jumps)
      let jump_range = reverse(range(0, min([curr, len(jumps)-1])))
    else
      let jump_range = range(curr, len(jumps)-1)
    endif
    let targetjump = curr
    for i in jump_range
      if a:up && jumps[i]['bufnr'] != current_buffer
        let targetjump = i
        break
      " if we're going forward in history, we want to find the last jump in
      " the next file
      elseif !(a:up) && jumps[i]['bufnr'] != current_buffer &&
            \ (i == len(jumps)-1 || jumps[i]['bufnr'] != jumps[i+1]['bufnr'])
        let targetjump = i
        break
      endif
    endfor

    " Execute the jump command until the buffer changes or there are no more jumps
    for _ in range(min([curr, targetjump]), max([curr, targetjump]))[1:]
        if a:up == v:true
            execute "normal! \<c-o>"
        else
            " \<CR> is an ugly hack to do nothing but let the normal command
            " see that it has an argument
            execute "normal! \<CR>\<c-i>"
        endif
    endfor
    let &lazyredraw = old_lazy_redraw
endfunction

nnoremap <silent> <M-o> :call PrevJumpFile(v:true)<CR>
nnoremap <silent> <M-i> :call PrevJumpFile(v:false)<CR>

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
    \ compiler rustc |
    \ setlocal makeprg=cargo\ check 
    " \ setlocal errorformat=%.%#-->\ %f:%l:%c |
    " \ setlocal errorformat+=%.%#-->\ %f\|%l\ col\ %c\\
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
  if exists(':ClangdSwitchSourceHeader')
    ClangdSwitchSourceHeader
    return 1
  endif
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
" bang turns it off again
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
command -range=% PandocCopy execute "<line1>,<line2>w !pandoc -f " . PandocSyntax(&syntax) . " -t html | xclip -t text/html -selection clipboard"
command PandocPaste execute "r !xclip -o -t text/html -selection clipboard | pandoc -f html -t " . PandocSyntax(&syntax)

function! PandocSyntax(format)
  let pandocFormats = { "markdown": "gfm-raw_html", "plaintex": "latex", "tex": "latex", "txt": "plain" }
  return get(pandocFormats, a:format, a:format)
endfunction

command -range Dictate execute "<line1>,<line2>w !pandoc -f " . PandocSyntax(&syntax) . " -t plain | festival --tts"

" see :h :DiffOrig
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

command -nargs=? SvnDiff call SvnDiff("<args>")

function! SvnDiff(revision)
  call SvnDiffFile(expand('%'), revision)
endfunction

command -nargs=? SvnDiffAll call SvnDiffAll("<args>")

function! SvnDiffAll(revision)
  let changed = system('svn diff --summarize')
  if changed =~# '^svn: E.*'
      echoerr "not in a svn directory"
  endif
  let changed_list = split(changed, "\n")
  for item in changed_list 
      if item =~# '^MM\?'
          let file = matchlist(item, 'MM\?\s*\(.*$\)')[1]
          execute 'tabnew'
          execute 'edit '.file
          call SvnDiffFile(file, a:revision)
      endif
  endfor
endfunction

" NOTE: the split gets its syntax highlighting from the current
" open file, not the file argument. These happen to be the same
" so far, but this should be changed if the function is used in
" more complicated ways.
function! SvnDiffFile(file, revision)
  let ft = &filetype
  let diffname = tempname()
  let revisionarg = ""
  if a:revision
    let revisionarg = '-r ' . a:revision
  endif
  let basecontent = system('svn cat ' . a:file . ' ' . revisionarg)
  call writefile(split(basecontent, '\n'), diffname)
  execute 'e ' . diffname
  let &filetype = ft
  execute 'vert diffsplit ' . a:file
endfunction

command -nargs=1 Retab execute "set noexpandtab | retab! | set tabstop=<args> softtabstop=<args> expandtab | retab!"

autocmd FileType txt,text,markdown,md,tex,latex setlocal linebreak

" symbols
set conceallevel=2

" extra syntax highligting
autocmd BufNewFile,BufRead .xmobarrc set syntax=haskell

" open external programs (like urls)
let g:netrw_browsex_viewer= "xdg-open"

" close netrw buffer after selecting file
let g:netrw_fastbrowse = 0
autocmd FileType netrw setl bufhidden=wipe

"## PLUGINS ##"

" built-in debugging plugin
packadd termdebug

augroup debugger
  autocmd!
  autocmd User TermdebugStartPre
        \ nnoremap <leader>ds :Step<cr>     |
        \ nnoremap <leader>db :Break<cr>    |
        \ nnoremap <leader>dB :Clear<cr>    |
        \ nnoremap <leader>dn :Over<cr>     |
        \ nnoremap <leader>dc :Continue<cr> |
        \ nnoremap <leader>df :Finish<cr>   |
        \ nnoremap <leader>de :Evaluate<cr> |
        \ vnoremap <leader>de :Evaluate<cr>
  " for some reason unmap doesn't appear to work with |
  autocmd User TermdebugStopPre unmap <leader>ds
  autocmd User TermdebugStopPre unmap <leader>db
  autocmd User TermdebugStopPre unmap <leader>dB
  autocmd User TermdebugStopPre unmap <leader>dn
  autocmd User TermdebugStopPre unmap <leader>dc
  autocmd User TermdebugStopPre unmap <leader>df
  autocmd User TermdebugStopPre unmap <leader>de
augroup END

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
    " snippets
    "
    " Need to check for python, if it's not there
    " UltiSnips makes insert mode unusable
    " TODO: more rigourus check 
    if has('python') || has('pyhton3') || has('nvim')
      Plug 'SirVer/ultisnips'
      let g:UltiSnipsExpandTrigger="<c-e>"
      let g:UltiSnipsJumpForwardTrigger="<c-z>"
      let g:UltiSnipsJumpBackwardTrigger="<c-a>"
    endif
    " distraction free writing
    Plug 'junegunn/goyo.vim'
    " Moving by indentation level
    Plug 'jeetsukumaran/vim-indentwise'
    " Diffing sections of text
    Plug 'AndrewRadev/linediff.vim'
    " colorscheme
    Plug 'arcticicestudio/nord-vim'
    " Undo tree viewer
    Plug 'mbbill/undotree'
    " highlight words and lines
    Plug 'azabiong/vim-highlighter'
    " smooth scrolling
    Plug 'psliwka/vim-smoothie'
    " disabled by default
    let g:smoothie_enabled=0

    "## OUTSIDE INTEGRATION ##"
    " unix helpers
    Plug 'tpope/vim-eunuch'
    " make sure focus events work in tmux
    Plug 'tmux-plugins/vim-tmux-focus-events'
    " " tmux autocomplete 
    " Plug 'wellle/tmux-complete.vim'
    " run things in tmux instead of blocking vim
    Plug 'tpope/vim-dispatch'
    " fzf (fuzzy file finding)
    Plug 'junegunn/fzf', { 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
    " readline keybindings for command-line mode
    Plug 'tpope/vim-rsi'
    " git stuff
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'airblade/vim-gitgutter'
    let g:gitgutter_set_sign_backgrounds = 0
    " subversion
    " Plug 'juneedahamed/svnj.vim'
    Plug 'lilliputten/vim-svngutter'
    " let g:svngutter_set_sign_backgrounds = 0
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
    Plug 'dpelle/vim-LanguageTool'
    let g:languagetool_jar='~/LanguageTool-5.8/languagetool-commandline.jar'
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
    " ren'py
    Plug 'chaimleib/vim-renpy'
    let g:user_emmet_mode = 'iv'
    nnoremap <leader><C-y>u <plug>(emmet-update-tag)
    nnoremap <leader><C-y>d <plug>(emmet-balance-tag-inward)
    nnoremap <leader><C-y>D <plug>(emmet-balance-tag-outward)
    nnoremap <leader><C-y>n <plug>(emmet-move-next)
    nnoremap <leader><C-y>N <plug>(emmet-move-prev)


    "## NVIM SPECIFIC ##"
    if has('nvim')
        source ~/.config/nvim/nvim-plugins.vim
    endif

call plug#end()

colorscheme nord
hi Normal guibg=NONE ctermbg=NONE
