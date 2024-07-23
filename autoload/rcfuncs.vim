function! rcfuncs#CoworkerMode(enable)
  if a:enable
    set cursorline
    set selectmode=mouse
    let g:smoothie_enabled=1
  else
    set nocursorline
    let g:smoothie_enabled=0
    set selectmode=
  endif
endfunction


function! rcfuncs#AlignAfterPrevLine()
  let start_pos = getpos('.')
  let pat = input("Pattern to align after: ")
  call setpos('.', [start_pos[0], start_pos[1]-1, 0, start_pos[3]])
  let matched = search(pat, "", line("."))
  let found_pos = getpos('.')
  normal j^
  if (matched)
    let first_non_ws = getpos('.')
    let line = getline(start_pos[1])
    let new_line = substitute(line, '^\s*', repeat(' ', found_pos[2]-1), "")
    call setline(start_pos[1], new_line)
    call setpos('.', [start_pos[0], start_pos[1], start_pos[2] + found_pos[2] - first_non_ws[2], start_pos[3]])
  else
    call setpos('.', start_pos)
  endif
endfunction

function rcfuncs#PrevJumpFile(up)
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

    if curr != targetjump
        let count = abs(curr-targetjump)
        if a:up == v:true
            execute "normal! ".count."\<c-o>"
        else
            " note that `normal ^I` needs a
            " count to work for some reason
            execute "normal! ".count."\<c-i>"
        endif
    endif
endfunction

function! rcfuncs#CFiles()
  nnoremap <buffer> <silent> ]h :call rcfuncs#ToggleHeaderFile()<CR>
  nnoremap <buffer> <silent> ]H :call rcfuncs#ToggleHeaderSearch()<CR>
endfunction

function! rcfuncs#ToggleHeaderSearch()
  let word = expand('<cword>')
  let toggled = ToggleHeaderFile()
  if toggled 
    call feedkeys("/\\<" . word . "\\>\<CR>")
  endif
endfunction

function! rcfuncs#ListArgs()
  let args = argv()
  let i = 0
  for arg in args
    echo i." ".arg
    let i += 1
  endfor
endfunction

function! rcfuncs#ToggleHeaderFile()
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

function rcfuncs#ToggleAutoMake(bang)
  augroup automake
    autocmd! * 
    if a:bang == 0
      autocmd BufWritePost <buffer> Make!
    endif
  augroup END
endfunction

function rcfuncs#MakeTags()
  silent exec "Spawn! ctags -R " . getcwd()
endfunction

function! rcfuncs#SvnDiff(revision) abort
  call rcfuncs#SvnDiffFile(expand('%:p'), a:revision)
endfunction

function! rcfuncs#SvnDiffAll(revision) abort
  let path = expand('%:p:h')
  let changed = system('cd ' .. path .. ' && svn diff --summarize')
  if changed =~# '^svn: E.*'
      echoerr "not in a svn directory"
  endif
  let changed_list = split(changed, "\n")
  for item in changed_list 
      if item =~# '^MM\?'
          let file = matchlist(item, 'MM\?\s*\(.*$\)')[1]
          echo file
          let absfile = path .. '/' .. file
          execute 'tabnew'
          execute 'edit '.absfile
          call rcfuncs#SvnDiffFile(absfile, a:revision)
      endif
  endfor
endfunction

" NOTE: the split gets its syntax highlighting from the current
" open file, not the file argument. These happen to be the same
" so far, but this should be changed if the function is used in
" more complicated ways.
function! rcfuncs#SvnDiffFile(file, revision) abort
  let path = fnamemodify(a:file, ':p:h')
  let ft = &filetype
  let diffname = tempname()
  let revisionarg = ""
  if a:revision
    let revisionarg = '-r ' . a:revision
  endif
  let basecontent = system('cd ' .. path .. ' && svn cat ' . a:file . ' ' . revisionarg)
  call writefile(split(basecontent, '\n'), diffname)
  execute 'e ' . diffname
  let &filetype = ft
  execute 'vert diffsplit ' . a:file
endfunction

" project specific config files
function! rcfuncs#SourceVimLocal()
  set secure
  let s:path = getcwd()
  for i in range(8)
    let s:newpath = fnamemodify(s:path, ':h')
    if s:path == s:newpath
      break
    endif
    if filereadable(s:path . '/.vimlocal')
      execute 'silent source '.s:path.'/.vimlocal'
      break
    endif
    let s:path = s:newpath
  endfor
  set nosecure
endfunction


let s:rg_prefixes = {
      \ 'R': 'grep',
      \ 'RA': 'grepadd'}

function! rcfuncs#ProjectionistRipGrep() abort
  for [command, patterns] in items(projectionist#navigation_commands())
    for [prefix, excmd] in items(s:rg_prefixes)
      execute 'command! -buffer -bang -nargs=1 '
            \ prefix . substitute(command, '\A', '', 'g')
            \ ':call s:Projectionist_ripgrep("'.excmd.'<bang>",'.string(patterns).', <q-args>)'
    endfor
  endfor
endfunction

function! s:Projectionist_ripgrep(grep, variants, pattern) abort
  let secondary_grep = a:grep =~# 'add' ? a:grep : substitute(a:grep, 'grep', 'grepadd', '')
  let first_batch = v:true
  for variant in a:variants
    " group 1: 'foo' in foo/bar*baz
    " group 2: 'bar' in foo/bar*baz
    " group 3: 'baz' in foo/bar*baz
    let match = matchlist(variant[1], '\v^(%([^\/\\*]*/)+)%(\*\*[\/\\]|([^*\/\\])*)\*(.*)$')
    if [] != match
      let path = variant[0] . projectionist#slash() . match[1]
      let glob = ''
      if '' != match[2] . match[3]
        let glob = ' -g ' . escape(match[2] . '*' . match[3], ' ')
      endif
      execute (first_batch ? a:grep : secondary_grep) . ' ' . a:pattern . glob . ' ' . path
      let first_batch = v:false
    endif
  endfor
endfunction
