function! fdfind#FindComplete(arg_lead, cmd_line, cursor_pos) abort
  let path = a:arg_lead
  if path[-1] != '*'
    let path .= '*'
  endif
  return s:FindRunFd(path)
endfunction

function! s:FindRunFd(path) abort
  return system('fd --full-path --glob path')->split('\n')
endfunction

function FindRunFd(path) abort
  return s:FindRunFd(a:path)
endfunction

function! fdfind#FindCmd(name) abort
  let match = ''
  if filereadable(a:name)
    let match = a:name
  else
    let matches = FindRunFd(a:name)
    if !len(matches)
      echoerr "No matches found"
      return
    else
      let match = matches[0]
    endif
  endif
  execute 'edit '.match
endfunction
