if exists("current_compiler")
  finish
endif
let current_compiler = "ninjamsvc"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=ninja
CompilerSet errorformat=
      \%f(%l):\ %trror%m,
      \%f(%l):\ fatal\ %trror%m,
      \%f(%l\\\,%c):\ %trror%m,
      \\\s%f(%l\\\,%c):\ %trror%m,
      \%f(%l\\\,%c):\ %tarning%m,
      \\\s%f(%l\\\,%c):\ %tarning%m,
      \LINK\ :\ fatal\ %trror\ %m,
      \%-G[%l/%c\]\ Building%s,
      \%-G[%l/%c\]\ Linking%s,
      \%-G[%l/%c\]\ Generating%s,
      " \%-G%f,
      " \%-G\\s%#,
      " \%-G%.%#,
      " \%-G,

let &cpo = s:cpo_save
unlet s:cpo_save
