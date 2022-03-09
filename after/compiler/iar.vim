if exists("current_compiler")
  finish
endif
let current_compiler = "iar"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=IarBuild

CompilerSet errorformat=
      \%f(%l)\ :\ %trror%m,
      \%f(%l)\ :\ %tarning%m,
      \%-GError\ while\ running\ Linker,
      \%trror%m,
      \%-G%f,
      \%-G\\s%#,
      \%-G%.%#,

if exists('g:compiler_gcc_ignore_unmatched_lines')
  CompilerSet errorformat+=%-G%.%#
endif

let &cpo = s:cpo_save
unlet s:cpo_save
