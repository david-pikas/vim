let s:path = expand('%:p:h')
if filereadable('compile_commands.json')
  let s:file = 'compile_commands.json'
elseif filereadable(s:path . '/compile_commands.json')
  let s:file = s:path . '/compile_commands.json'
else
  finish
endif

let s:includes = system('jq -f ' . glob('~\.vim\scripts\compile_command_includes.jq') . ' ' . s:file)
echo s:includes
let s:includes = s:includes->split('\n')->join(',')->substitute('"', '', 'g')->substitute('\\\\','\\','g')
echo s:includes

let &path= &path . s:includes
