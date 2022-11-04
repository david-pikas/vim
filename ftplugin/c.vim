set commentstring=//%s
let s:path = expand('%:p:h')
let s:file = ''
if filereadable('compile_commands.json')
  let s:file = 'compile_commands.json'
else
  let s:newpath = s:path
  while 1
    let s:newpath = fnamemodify(s:path, ':h')
    if s:path == s:newpath
      break
    endif
    let s:path = s:newpath
    if filereadable(s:path . '/compile_commands.json')
      let s:file = s:path . '/compile_commands.json'
      break
    endif
  endwhile
endif

if s:file != ''
  let s:includes = system('jq -f ' . glob('~\.vim\scripts\compile_command_includes.jq') . ' ' . s:file)
  let s:includes = '.,'.s:includes->split('\n')->join(',')->substitute('"', '', 'g')->substitute('\\\\','\\','g')
  let &path= s:includes
endif
