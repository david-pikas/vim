if exists("current_compiler")
  finish
endif
let current_compiler = "t2"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=t2\ make\ --log_commands
CompilerSet errorformat=
      \stdout:\ FAILED\ ASS%tRT:\ %f:%l\ %m,
      \stdout:\ %f:%l:in%m,
      \std%trr:\ %f:%l:%m

let &cpo = s:cpo_save
unlet s:cpo_save
