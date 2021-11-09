" Vim syntax file
" Language: Ink game dialouge files
" Maintainer: David Pikas
" Latest Revision: 3 February 2021
" see: https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md


if exists("b:current_syntax")
  finish
endif

syn keyword inkSpecialDiverts DONE END


syn match inkIdentifier /[a-zA-Z_]\([a-zA-Z0-9_]\)*/ contained
syn match inkDialouge /\v^(\s*[\+\-\*])*/
" The '\s*' is neccesary for it to always get matched before inkDialouge
syn match inkDivert /\s*->/ nextgroup=inkSpecialDiverts,inkIdentifier skipwhite
syn match inkComment /\/\/.*/
syn match inkTodo /TODO:.*/

syn region inkSequence matchgroup=inkBrackets start=/{[!&~]\?/ end='}' contains=inkSequence,inkSeperarator,inkDivert
syn match inkSeperarator /|/ contained 
syn region inkPreview matchgroup=inkPreBrackets start='\[' end=']' contains=inkSequence,inkDivert

syn region inkBlockComment start='/\*' end='\*/'

syn region inkStitchHeader start='=' end=/\(=\|$\)/ oneline contains=inkIdentifier
syn region inkKnotHeader start='===' end=/\(===\|$\)/ oneline contains=inkIdentifier

let b:current_syntax = "ink"
highlight default link inkComment Comment
highlight default link inkBlockComment Comment
highlight default link inkTodo Todo
highlight default link inkSpecialDiverts Keyword
highlight default link inkKnotHeader Special
highlight default link inkStitchHeader String
highlight default link inkDialouge Keyword
highlight default link inkDivert Special
highlight default link inkIdentifier String
highlight default link inkBrackets Special
highlight default link inkPreBrackets Keyword
highlight default link inkSeperarator Special
