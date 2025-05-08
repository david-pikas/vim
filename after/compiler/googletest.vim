if exists("current_compiler")
  finish
endif
let current_compiler = "googletest"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=ctest
CompilerSet errorformat=
      \%f(%l\\\):\ %trror:\ %m,
      " \%-G%f,
      " \%-G\\s%#,
      " \%-G%.%#,
      " \%-G,

let &cpo = s:cpo_save
unlet s:cpo_save
