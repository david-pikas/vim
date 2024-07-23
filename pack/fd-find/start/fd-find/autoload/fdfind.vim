function! fdfind#FindComplete(arg_lead, cmd_line, cursor_pos) abort
  let path = a:arg_lead
  if path[-1] != '*'
    let path .= '*'
  endif
  return s:FindRunFd(path)
endfunction

function s:PathSep()
  if has('win32')
    return '[/\\]'
  else
    return '/'
  endif
endfunction

function! s:FindRunFd(path) abort
  let needle = a:path
  let haystack = ''
  if a:path =~# s:PathSep()
    if a:path =~# s:PathSep() . '\*\*' . s:PathSep()
      let split = stridx(a:path, '**')
      let seplen = 3
    else
      let split = strridx(a:path, '/')
      if has('win32')
        let split = max([split, strridx(a:path, '\')])
      endif
      let seplen = 1
    endif
    let haystack = a:path[:split-1]
    let needle = a:path[split+seplen:]
    if haystack == ''
      let haystack = '/'
    endif
  endif
  if needle == ''
    let needle = '*'
  endif
  return system('fd --glob '.needle . ' ' . haystack)->split('\n')
endfunction

function! fdfind#FindCmd(name) abort
  let match = ''
  if filereadable(a:name)
    let match = a:name
  else
    let matches = s:FindRunFd(a:name)
    if !len(matches)
      echoerr "No matches found"
      return
    else
      let match = matches[0]
    endif
  endif
  execute 'edit '.match
endfunction

function! fdfind#CFd(args)
  let olderrorformat = &errorformat
  set errorformat=\%f
  cexpr system('fd '.a:args)
  let &errorformat=olderrorformat
endfunction
