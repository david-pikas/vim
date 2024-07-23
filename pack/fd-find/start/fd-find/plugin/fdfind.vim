command! -nargs=1 -complete=customlist,fdfind#FindComplete Find call fdfind#FindCmd('<args>')
command! -nargs=+ -complete=file Cfd call fdfind#CFd('<args>')
