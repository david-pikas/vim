set commentstring=//\ %s
let s:path = expand('%:p:h')
let s:compile_commands_file = ''
if filereadable('compile_commands.json')
  let s:compile_commands_file = 'compile_commands.json'
else
  let s:newpath = s:path
  while 1
    let s:newpath = fnamemodify(s:path, ':h')
    if s:path == s:newpath
      break
    endif
    let s:path = s:newpath
    if filereadable(s:path . '/compile_commands.json')
      let s:compile_commands_file = s:path . '/compile_commands.json'
      break
    endif
  endwhile
endif

if (!exists("s:include_cache"))
  let s:include_cache = {}
endif

let s:file = expand('%:p')->substitute('\\','/', 'g')

if s:compile_commands_file != ''
  if !exists("s:include_cache[s:file]")
    let includes_json = system('jq -f ' . glob('~/.vim/scripts/compile_command_includes.jq') . ' ' . s:compile_commands_file)
    let s:include_cache = extend(s:include_cache, json_decode(includes_json))
  endif
  if exists("s:include_cache[s:file]")
    let &path = s:include_cache[s:file]->join(',')
  endif
endif

function! PrintCIncludesCache()
  echo s:include_cache
endfunction

call rcfuncs#CFiles()
