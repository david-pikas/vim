if exists("current_compiler")
  finish
endif
let current_compiler = "visualstudio"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=msbuild
CompilerSet errorformat=
      \%f(%l\\\,%c):\ %trror%m,
      \\\s%f(%l\\\,%c):\ %trror%m,
      \%f(%l\\\,%c):\ %tarning%m,
      \\\s%f(%l\\\,%c):\ %tarning%m,
      \LINK\ :\ fatal\ %trror\ %m,
      " \%-G%f,
      " \%-G\\s%#,
      " \%-G%.%#,
      " \%-G,

let &cpo = s:cpo_save
unlet s:cpo_save
