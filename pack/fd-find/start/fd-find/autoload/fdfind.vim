function! fdfind#FindComplete(arg_lead, cmd_line, cursor_pos) abort
  let path = a:arg_lead
  if path[-1] != '*'
    let path .= '*'
  endif
  return s:FindRunFd(path)
endfunction

function! s:FindRunFd(path) abort
  let fname = fnamemodify(a:path, ":t")
  let fpath = fnamemodify(a:path, ":h")
  let segments = []
  let depth = ' --max-depth=1'
  if fname == '**'
    let depth = ''
    let fname = '*'
  endif
  " fpath is . even if a:path doesn't include a dir
  if fpath ==# '' || (fpath ==# '.' && a:path[0] != '.')
    let depth = ''
  endif
  let pathsep = '/'
  if has('win32')
    let pathsep = '(/|\\)'
  endif
  let file_glob_regex = '\v('.pathsep.'|^)\*\*('.pathsep.'|$)'
  if fpath =~# file_glob_regex
    let depth = ''
    let segments = fpath->split('\*\*')
    let fpath = segments[0]
    if has('win32')
      let segments = segments->map({ix, val -> val->substitute('[/\\]','\\\\','g')})
    endif
  endif
  return system('fd --type f -g "'.fname.'" '.fpath.depth)
        \ ->split('\n')
        \ ->filter({ix,val -> !len(segments) || val =~# '\V'.segments->join('\.\*')})
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
