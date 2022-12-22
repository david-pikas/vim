if exists("current_compiler")
  finish
endif
let current_compiler = "grep"

let s:cpo_save = &cpo
set cpo&vim

let &l:makeprg=&grepprg

let &l:errorformat=&grepformat

let &cpo = s:cpo_save
unlet s:cpo_save
